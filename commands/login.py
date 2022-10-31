from mysql.connector import MySQLConnection, Error, errorcode, FieldType
from commands.reviewerCommand import reviewerStatus
import shlex

def loginUser(cursor, command):
  
  params = shlex.split(command)

  if len(params) != 2:
    print("error: incorrect number of params")
    return None, None, None
  
  if(params[1].isdigit()):
      userId = params[1]
  else:
    print("error: bad userId")
    return None, None, None

  query = "SELECT * FROM Users WHERE idUser = {};".format(userId)
  cursor.execute(query)
  results = cursor.fetchall()

  if(len(results) != 1):
    print("error: user not registered")
    return None, None, None

  name = results[0][1] + " " + results[0][2]
  
  query = "SELECT * FROM Author WHERE Users_idAuthor = {};".format(userId)             # check if author
  cursor.execute(query)
  results = cursor.fetchall()

  if(len(results) == 1):

    user = "author"

    email = results[0][1]
    affiliation = results[0][2]
    
    print("\nAuthor login successful!")
    print("User " + userId + ": " + name + ", " + email + ", " + affiliation + "\n")

  else: ## not author

    query = "SELECT * FROM Editor WHERE Users_idEditor = {};".format(userId)          # check if editor
    cursor.execute(query)
    results = cursor.fetchall()

    if (len(results) == 1):

      user = "editor"

      print("\nEditor login successful!")
      print("User " + userId + ": " + name + "\n")
    
    else: ## must be reviewer
      
      query = "SELECT * FROM Reviewer WHERE Users_idReviewer = {};".format(userId)    # check if reviewer
      cursor.execute(query)
      results = cursor.fetchall()
      
      if (len(results) != 1):
        print("error: user not registered")
        return None, None, None

      user = "reviewer"

      print("\nReviewer login successful!")
      print("User " + userId + ": " + name + "\n")

      reviewerStatus(cursor, userId)

  return name, user, userId