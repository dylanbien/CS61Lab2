from mysql.connector import MySQLConnection, Error, errorcode, FieldType
import shlex

def updateManuscript(cursor, command, userID, status):

  params = shlex.split(command)

  if len(params) != 6:
    print("error: Incorrect number of params")
    return

  if(params[1].isdigit()):
      manuscriptid = params[1]
  else:
    print("error: bad manuscriptid")
    return

  if(params[2].isdigit() and params[3].isdigit() and params[4].isdigit() and params[5].isdigit()):
      ascore = params[2]
      cscore = params[3]
      mscore = params[4]
      escore = params[5]
  else:
    print("error: bad score")
    return

  # check manuscript is in reviewing status
  query = "select ManStatus from Manuscript where idManuscript = {};".format(manuscriptid)
  cursor.execute(query)
  results = cursor.fetchall()

  print(results[0][0])
  if(results[0][0] != 'under review'):
    print('Manuscript must be under review')
    return

  # check manuscript is assigned to reviewer
  query = "select * from Review where Reviewer_Users_idReviewer = {} AND Manuscript_idManuscript = {};".format(userID, manuscriptid)
  cursor.execute(query)
  results = cursor.fetchall()

  if(results == None):
      print('Manuscript must be assigned to the reviewer')
      return

  query = "UPDATE Review SET Recommendation = '{}', AScore = {}, CScore = {}, MScore = {} , EScore = {}, SubmittedTimestamp = NOW() WHERE Reviewer_Users_idReviewer = {} AND Manuscript_idManuscript = {};".format(status, ascore, cscore, mscore, escore, userID, manuscriptid)
  cursor.execute(query)
  
  return


