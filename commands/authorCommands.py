import shlex

def authorStatus(cursor, userId):

    query = "SELECT idManuscript, ManStatus, StatusTimestamp FROM LeadAuthorManuscripts WHERE idUser = {};".format(userId)
    cursor.execute(query)
    results = cursor.fetchall()

    print("\nManuscript ID\tStatus\t\t\t\tStatus Timestamp")
    print("-------------------------------------------------------------------")

    for row in results:
      printRow = str(row[0]) + "\t\t" + row[1]
      numSpaces = len("scheduled for publication") - len(row[1])
      for i in range(numSpaces):
        printRow += " "
      printRow += "\t" + str(row[2])
      print(printRow)
    print()

def submit(cursor, userId, command):

  params = shlex.split(command)
  if len(params) < 5:
    print("error: not enough params")
    return

  title = params[1]
  affiliation = params[2]

  if params[3].isdigit():
    icode = params[3]
  else:
    print("error: bad icode")
    return

  # check valid icode
  query = "SELECT ICode FROM ICode WHERE ICode = {};".format(icode)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: icode does not exist")
    return

  query = "SELECT ICode_ICode FROM Scope WHERE Journal_idJournal = 1 AND ICode_ICode = {};".format(icode)
  cursor.execute(query)
  if (cursor.rowcount == 0):
    print("error: icode not within scope of journal")
    return

  filename = params[-1]
  
  coauthors = "'"
  for i in range(4, len(params) - 1):
    coauthors += params[i] + ", "
  if (len(coauthors) == 1):
    coauthors = "null"
  else:
    coauthors = coauthors[:-2] + "'"

  # insert manuscript
  query = "INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode) VALUES ('{}',{},{},{});".format(title, userId, coauthors, icode)
  cursor.execute(query)
  query = "SELECT LAST_INSERT_ID();"
  cursor.execute(query)
  manID = int(cursor.fetchall()[0][0])

  # update primary author affiliation
  query = "UPDATE Author SET Affiliation = '{}' WHERE Users_idAuthor = {};".format(affiliation, userId)
  cursor.execute(query)

  print("\nManuscript submission successful!")
  print("Manuscript " + str(manID) + ": " + title + "\n")
  