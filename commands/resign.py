from mysql.connector import MySQLConnection, Error, errorcode, FieldType

def resignReviewer(cursor, userID):

  query = "DELETE FROM Users WHERE idUser = {};".format(userID)
  cursor.execute(query)
  
  return