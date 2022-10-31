
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