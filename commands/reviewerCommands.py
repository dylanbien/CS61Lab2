from mysql.connector import MySQLConnection, Error, errorcode, FieldType
import shlex

def reviewerStatus(cursor, userID):
    query = "SELECT idManuscript, Title, ManStatus FROM Manuscript JOIN Review ON Manuscript.idManuscript = Review.Manuscript_idManuscript WHERE Reviewer_Users_idReviewer = {} ORDER BY ManStatus, idManuscript;".format(userID)
    cursor.execute(query)
    results = cursor.fetchall()
    
    maxLength = 0

    for row in results:
      titleLength = len(row[1])
      if titleLength > maxLength:
        maxLength = titleLength

    header = "\nManuscript ID\tTitle"
    numSpaces = maxLength - len("Title")
    for i in range(numSpaces):
      header += " "
    header += "\tStatus"
    print(header)
    breakline = ""
    for i in range(len(header.expandtabs()) + len("scheduled for publication") - len("Status")):
      breakline += "-"
    print(breakline)
    
    for row in results:
      printRow = str(row[0]) + "\t\t" + row[1]
      numSpaces = maxLength - len(row[1])
      for i in range(numSpaces):
        printRow += " "
      printRow += "\t" + row[2]
      print(printRow)
    print()

def reviewerUpdateManuscript(cursor, command, userID, status):

  params = shlex.split(command)

  if len(params) != 6:
    print("error: Incorrect number of params")
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

  if(params[2].isdigit() and params[3].isdigit() and params[4].isdigit() and params[5].isdigit()):
      ascore = int(params[2])
      cscore = int(params[3])
      mscore = int(params[4])
      escore = int(params[5])
  else:
    print("error: bad score")
    return

  if not (1 <= ascore <= 10 and 1 <= cscore <= 10 and 1 <= mscore <= 10 and 1 <= escore <= 10):
    print("error: scores out of range")
    return

  # check manuscript is in reviewing status
  query = "SELECT ManStatus FROM Manuscript WHERE idManuscript = {};".format(manid)
  cursor.execute(query)
  results = cursor.fetchall()

  print(results[0][0])
  if(results[0][0] != 'under review'):
    print('error: manuscript not under review')
    return

  # check manuscript is assigned to reviewer
  query = "SELECT * FROM Review WHERE Reviewer_Users_idReviewer = {} AND Manuscript_idManuscript = {};".format(userID, manid)
  cursor.execute(query)
  if(cursor.rowcount == 0):
      print('error: manuscript not assigned to reviewer')
      return

  query = "UPDATE Review SET Recommendation = '{}', AScore = {}, CScore = {}, MScore = {} , EScore = {}, SubmittedTimestamp = NOW() WHERE Reviewer_Users_idReviewer = {} AND Manuscript_idManuscript = {};".format(status, ascore, cscore, mscore, escore, userID, manid)
  cursor.execute(query)
  
  print("\nReview submission successful!")
  print("Manuscript " + str(manid) + " recommended '" + status + "' by reviewer" + str(userID) + "\n")
  return

def reviewerResign(cursor, userID):

  query = "DELETE FROM Users WHERE idUser = {};".format(userID)
  cursor.execute(query)
  
  print("\nReviewer " + userID + " resignation successful!")
  print("Thank you for your service.\n")
  return