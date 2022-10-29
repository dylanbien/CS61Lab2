
def authorStatus(cursor, userId):
    print("Manuscript ID\tStatus\t\t\t\tStatus Timestamp")
    print("-------------------------------------------------------------------")
    query = "SELECT idManuscript, ManStatus, StatusTimestamp FROM LeadAuthorManuscripts WHERE idUser = {};".format(userId)
    cursor.execute(query)
    results = cursor.fetchall()
    for row in results:
      printRow = str(row[0]) + "\t\t" + row[1]
      numSpaces = len("scheduled for publication") - len(row[1])
      for i in range(numSpaces):
        printRow += " "
      printRow += "\t" + str(row[2])
      print(printRow)