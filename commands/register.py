from queue import Empty
from mysql.connector import MySQLConnection, Error, errorcode, FieldType
import shlex

def registerUser(cursor, command):

  params = shlex.split(command)
  if len(params) < 4:
    print("error: not enough params")
    return None, None, None

  fname = params[2]
  lname = params[3]

  if(params[1] == 'author'):
    
    if len(params) < 6: 
      print("error: not enough params")
      return None, None, None

    email = params[4]
    affiliation = params[5]

    query = "INSERT INTO Users (FName, LName) VALUES ('{}','{}');".format(fname, lname)
    cursor.execute(query)

    query = "SELECT LAST_INSERT_ID();"
    cursor.execute(query)
    userID = int(cursor.fetchall()[0][0])

    query = "INSERT INTO Author (Users_idAuthor, Email, Affiliation) VALUES ({},'{}','{}');".format(userID, email, affiliation)
    cursor.execute(query)
  
  elif(params[1] == 'reviewer'):
    
    if len(params) < 5:
      print("error: not enough params")
      return None, None, None
  
    if len(params) > 7:
      print("error: too many params")
      return None, None, None

    icodes = []

    for i in range (4, 7):
      if i >= len(params):
        break
      if(params[i].isdigit()):
        icodes.append(int(params[i]))
      else:
        print("error: invalid icode")

    for code in icodes:
      query = "SELECT ICode FROM ICode WHERE ICode = {};".format(code)
      cursor.execute(query)
      if (cursor.rowcount == 0):
        print("error: icode does not exist")
        return None, None, None

    query = "INSERT INTO Users (FName, LName) VALUES ('{}','{}');".format(fname, lname)
    cursor.execute(query)

    query = "SELECT LAST_INSERT_ID();"
    cursor.execute(query)
    userID = int(cursor.fetchall()[0][0])

    query = "INSERT INTO Reviewer (Users_idReviewer) VALUES ({});".format(userID)
    cursor.execute(query)

    for code in icodes:
      query = "INSERT INTO ReviewerGroup (Reviewer_Users_idReviewer, ICode_ICode) VALUES ('{}','{}');".format(userID, code)
      cursor.execute(query)

  elif(params[1] != 'editor'):
    print("error: bad user type")
    return None, None, None
  
  query = "INSERT INTO Users (FName, LName) VALUES ('{}','{}');".format(fname, lname)
  cursor.execute(query)

  query = "SELECT LAST_INSERT_ID();"
  cursor.execute(query)
  userID = int(cursor.fetchall()[0][0])

  query = "INSERT INTO Editor (Users_idEditor) VALUES ({});".format(userID)
  cursor.execute(query)
  
  name = fname + " " + lname
  return name, params[1], userID