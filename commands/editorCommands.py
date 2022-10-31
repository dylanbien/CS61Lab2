from mysql.connector import MySQLConnection, Error, errorcode, FieldType
import shlex

def editorStatus(cursor):

    query = "SELECT AuthorName, idUser, idManuscript, ManStatus FROM AnyAuthorManuscripts ORDER BY ManStatus, idManuscript;"
    cursor.execute(query)
    results = cursor.fetchall()
    
    maxLength = 0

    for row in results:
      authorLength = len(row[0])
      if authorLength > maxLength:
        maxLength = authorLength

    header = "\nAuthor Name"
    numSpaces = maxLength - len("Author Name")
    for i in range(numSpaces):
      header += " "
    header += "\tAuthor ID\tManuscript ID\tStatus"
    print(header)
    breakline = ""
    for i in range(len(header.expandtabs()) + len("scheduled for publication") - len("Status")):
      breakline += "-"
    print(breakline)
    
    for row in results:
      printRow = row[0]
      numSpaces = maxLength - len(row[0])
      for i in range(numSpaces):
        printRow += " "
      printRow += "\t" + str(row[1]) + "\t\t" + str(row[2]) + "\t\t" + str(row[3])
      numSpaces = len("scheduled for publication") - len(row[3])
      for i in range(numSpaces):
        printRow += " "
      print(printRow)
    print()

def editorAssignManuscript(cursor, command):

  params = shlex.split(command)

  if len(params) != 3:
    print("error: incorrect number of params")
    return

  # check valid manuscript
  if(params[1].isdigit()):
    manid = params[1]
  else:
    print("error: bad manuscriptid")
    return

  query = "SELECT idManuscript FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: manuscript does not exist")
    return

  # check valid reviewer
  if(params[2].isdigit()):
    revid = params[2]
  else:
    print("error: bad reviewer id")
    return 

  query = "SELECT Users_idReviewer FROM Reviewer WHERE Users_idReviewer = {};".format(revid)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: reviewer does not exist")
    return

  # check reviewer covers icode
  query = "SELECT ICode_ICode FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  icode = int(cursor.fetchall()[0][0])

  query = "SELECT * FROM ReviewerGroup WHERE ICode_ICode = {}, Reviewer_Users_idReviewer = {};".format(icode, revid)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: manuscript icode not in reviewer's area of expertise")
    return

  # Assign a manuscript to a reviewer
  query = "INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript) VALUES({},{});".format(revid, manid)
  cursor.execute(query)

  # Update the manuscript status to 'under review'
  query = "UPDATE Manuscript SET ManStatus = 'under review' WHERE idManuscript = {};".format(manid)
  cursor.execute(query)

  print("\nReview assignment successful!")
  print("Manuscript " + str(manid) + " assigned to reviewer " + str(revid) + "\n")
  return


def editorUpdateManuscript(cursor, command, status):

  params = shlex.split(command)

  if len(params) != 2:
    print("error: incorrect number of params")
    return

  # valid manuscript
  if(params[1].isdigit()):
      manid = params[1]
  else:
      print("error: bad manuscriptid")
      return

  query = "SELECT idManuscript FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: manuscript does not exist")
    return

  #Ensure a mansucript has 3 completed reviews in order to accept
  if status == "accept":
    query = "SELECT Manuscript_idManuscript, Recommendation FROM Review WHERE Manuscript_idManuscript = {} AND Recommendation IS NOT NULL;".format(manid)
    cursor.execute(query)
  
    if(cursor.rowcount < 3):
      print("Manuscript must have at least 3 completed reviews")
      return

  #Update the manuscript status and status timestamp
  query = "UPDATE Manuscript SET ManStatus = '{}', StatusTimestamp = NOW() WHERE idManuscript = {};".format(status, manid)

  print("\nManuscript status successfully updated!")
  print("Manuscript " + str(manid) + " status updated to " + status + "\n")
  return 

def editorSchedule(cursor, command):
 
  params = shlex.split(command)

  if len(params) != 3:
    print("error: incorrect number of params")
    return

  # valid manuscript
  if(params[1].isdigit()):
    manid = params[1]
  else:
    print("error: bad manuscriptid")
    return

  query = "SELECT idManuscript FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: manuscript does not exist")
    return

  # validate issue
  issue = params[2]

  if len(issue) != 6:
    print("error: bad issueid")
  year, month = issue.split('-')
  if not (year.isdigit() and month.isdigit()):
    print("error: bad issueid")
  if not (issue[4] == '-'):
    print("error: bad issueid")

  query = "SELECT idIssue FROM Issue WHERE idIssue = {};".format(issue)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    query = "INSERT INTO Issue (idIssue, Journal_idJournal) VALUES ('{}', 1);".format(issue)
    cursor.execute(query)

  # check manuscript is in ready status
  query = "SELECT ManStatus FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  results = cursor.fetchall()

  if(results[0][0] != 'ready'):
    print('error: manuscript not ready')
    return

  #Check not exceeding 100 pages
  query = "SELECT NumPages FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  manuscriptLength = int(cursor.fetchall()[0][0])

  query = "SELECT NextPage FROM Issue WHERE idIssue = '{}';".format(issue)
  cursor.execute(query)
  nextPage = int(cursor.fetchall()[0][0])

  newNext = nextPage + manuscriptLength

  if (newNext - 1 > 100):
    print("error: inserting manuscript into issue would exceed max length")
    return

  #Update manuscript status to scheduled 
  query = "UPDATE Manuscript SET ManStatus = 'scheduled for publication', StatusTimestamp = NOW(), Issue_idIssue = '{}', BeginningPage = {} WHERE idManuscript = {};".format(issue, nextPage, manid)
  cursor.execute(query)

  #update issue next page
  query = "UPDATE Issue SET NextPage = {} WHERE idIssue = '{}';".format(newNext, issue)
  cursor.execute(query)

  print("\nManuscript successfully scheduled for publication!")
  print("Manuscript " + str(manid) + " assigned to issue " + issue + "\n")
  return 

def editorPublish(cursor, command):

  params = shlex.split(command)

  if len(params) != 2:
    print("error: incorrect number of params")
    return

  # validate issue
  issue = params[2]

  if len(issue) != 6:
    print("error: bad issueid")
  year, month = issue.split('-')
  if not (year.isdigit() and month.isdigit()):
    print("error: bad issueid")
  if not (issue[4] == '-'):
    print("error: bad issueid")

  query = "SELECT idIssue FROM Issue WHERE idIssue = {};".format(issue)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: issue does not exist")
    return

  # Check the issue is at least 75 pages
  query = "SELECT NextPage FROM Issue where idIssue = '{}';".format(issue)
  cursor.execute(query)
  numPages = int(cursor.fetchall()[0][0]) - 1

  if (numPages < 75):
    print("error: not enough pages to publish the issue")
    return

  query = "UPDATE Manuscript SET ManStatus = 'published', StatusTimestamp = NOW() WHERE Issue_idIssue = '{}';".format(issue)
  cursor.execute(query)

  query = "UPDATE Issue SET PublicationDate = NOW() WHERE idIssue = '{}';".format(issue)
  cursor.execute(query)
  
  print("\nIssue publication successful!")
  print("Issue " + issue + " now published\n")
  return 