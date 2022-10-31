from mysql.connector import MySQLConnection, Error, errorcode, FieldType

def updateManuscript(cursor, command, userID):

  params = shlex.split(command)

  if len(params) != 6:
    print("error: Incorrect number of params")
    return

  if params[0] == 'accept' or params[0] == 'reject':
    status = params[0]
  else:
    print("error: Incorrect status passed")


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

  query = """
          UPDATE Review 
          SET ManStatus = '{}', AScore = {}, CScore = {}, MScore = {} , EScore = {}
          WHERE Reviewer_Users_idReviewer = {} AND Manuscript_idManuscript = {}
          """.format(status, ascore, cscore, mscore, escore, userID, manuscriptid)


  # check manuscript is assigned to reviewer
  # check manuscript is in reviewing status

  return


