from mysql.connector import MySQLConnection, Error, errorcode, FieldType
from commands.authorCommands import authorStatus
from commands.editorCommands import editorStatus
from commands.reviewerCommands import reviewerStatus

def loginUser(cursor, command):
  
  params = command.split(' ')

  if len(params) != 2:
    print("error: incorrect number of params")
    return None, None
  
  if(params[1].isdigit()):
      userId = params[1]
  else:
    print("error: bad userId")
    return None, None

  query = "SELECT * FROM Users WHERE idUser = {};".format(userId)
  cursor.execute(query)
  results = cursor.fetchall()

  if(len(results) != 1):
    print("error: user not registered")
    return None, None

  fname = results[0][1]
  lname = results[0][2]

  query = "SELECT * FROM Author WHERE Users_idAuthor = {};".format(userId)             # check if author
  cursor.execute(query)
  results = cursor.fetchall()

  if(len(results) == 1):

    email = results[0][1]
    
    print("\nAuthor login successful!")
    print("User " + userId + ": " + fname + " " + lname + ", " + email + "\n")

  else: ## not author

    query = "SELECT * FROM Editor WHERE Users_idEditor = {};".format(userId)          # check if editor
    cursor.execute(query)
    results = cursor.fetchall()

    if (len(results) == 1):

      print("\nEditor login successful!")
      print("User " + userId + ": " + fname + " " + lname + "\n")
    
    else: ## must be reviewer
      
      query = "SELECT * FROM Reviewer WHERE Users_idReviewer = {};".format(userId)    # check if reviewer
      cursor.execute(query)
      results = cursor.fetchall()
      
      if (len(results) != 1):
        print("error: user not registered")
        return None, None

      print("\nReviewer login successful!")
      print("User " + userId + ": " + fname + " " + lname + "\n")

  return userId

## IF userId NOT IN (SELECT idUser FROM Users) THEN print("error: unregistered userId")
## IF userId IN (SELECT Users_idAuthor FROM Author) THEN 
#       print SELECT FName, LName, Email FROM Users JOIN Author ON idUser = Users_idAuthor WHERE idUser = userId
#       print SELECT * FROM LeadAuthorManuscripts WHERE Users_idAuthor = UserId
## IF userId IN (SELECT Users_idReviewer FROM Reviewer)
#       print SELECT FName, LName FROM Users WHERE idUser = userId
#       print SELECT idManuscript, Title, ManStatus FROM Manuscript JOIN Review WHERE Reviewer_Users_idReviewer = userId SORT BY ManStatus
## IF userId IN (SELECT Users_idEditor FROM Editor)
#       print SELECT FName, LName FROM Users WHERE idUser = userId
#       print SELECT * FROM AnyAuthorManuscripts SORT BY ManStatus, idManuscript