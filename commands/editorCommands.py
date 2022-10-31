from mysql.connector import MySQLConnection, Error, errorcode, FieldType
import shlex

def editorStatus(cursor, command, status):

  return

def editorAssignManuscript(cursor, command,):

  params = shlex.split(command)

  if len(params) != 3:
    print("error: incorrect number of params")
    return

  if(params[1].isdigit()):
    manuscriptid = params[1]
  else:
    print("error: bad manuscriptid")
    return

  if(params[2].isdigit()):
    reviewer_id = params[2]
  else:
    print("error: bad reviewer id")
    return

  # Assign a manuscript to a reviewer
  query = "INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp) VALUES({},{},NOW());".format(reviewer_id, manuscriptid)
  cursor.execute(query)
  # Update the manuscript status to 'under revew'
  query = "UPDATE Manuscript SET ManStatus = 'under review' WHERE idManuscript = {};".format(manuscriptid)
  cursor.execute(query)

  return


def editorUpdateManuscript(cursor, command, status):

  params = shlex.split(command)

  if len(params) != 2:
    print("error: incorrect number of params")
    return

  if(params[1].isdigit()):
      manuscriptid = params[1]
  else:
      print("error: bad manuscriptid")
      return

  #Ensure a mansucript has 3 completed reviews
  query = "SELECT COUNT(*) FROM Review WHERE Manuscript_idManuscript = {} AND Recommendation IS NOT NULL;".format(manuscriptid)
  results = cursor.fetchall()

  if(int(results[0][0]) < 3):
    print("Manuscript must have at least 3 completed reviews")
    return

  #Update the manuscript status and status timestamp
  query = "UPDATE Manuscript SET ManStatus = '{}', StatusTimestamp = NOW() WHERE idManuscript = {};".format(status, manuscriptid)

  return 

def editorSchedule(cursor, command):
 
  params = shlex.split(command)

  if len(params) != 3:
    print("error: incorrect number of params")
    return

  if(params[1].isdigit()):
    manuscriptid = params[1]
  else:
    print("error: bad manuscriptid")
    return

  issue = params[2]
  
  #Check not exceeting 100 pages
  query = "select (NumPages + BeginningPage) as currentIssueLength from Manuscript where Issue_idIssue = '{}' ORDER BY BeginningPage DESC LIMIT 1;".format(issue)
  cursor.execute(query)
  results = cursor.fetchall()
  lastPage = int(results[0][0])

  query = "SELECT NumPages FROM Manuscript WHERE idManuscript = {};".format(manuscriptid)
  cursor.execute(query)
  results = cursor.fetchall()
  manuscriptLength = int(results[0][0])


  if(lastPage + manuscriptLength > 100):
    print("Unable to add Manuscript to Issue; Issue length would exceed 100")

  # check manuscript is in ready status
  query = "select ManStatus from Manuscript where idManuscript = {};".format(manuscriptid)
  cursor.execute(query)
  results = cursor.fetchall()

  if(results[0][0] != 'ready'):
    print('Manuscript must be under ready')
    return

  #Update status to scheduled 
  query = "UPDATE Manuscript SET ManStatus = 'scheduled for publication', StatusTimestamp = NOW(), Issue_idIssue = '{}', BeginningPage = {} WHERE idManuscript = 20;".format(issue, lastPage + 1)
  cursor.execute(query)

  return 

def editorPublish(cursor, command):

  params = shlex.split(command)

  if len(params) != 3:
    print("error: incorrect number of params")
    return

  issue = params[2]

  # Check at least one manuscript is assigned to the issue
  query = "SELECT COUNT(*) FROM Manuscript where Issue_IdIssue = '{}';".format(issue)
  cursor.execute(query)
  results = cursor.fetchall()

  if(int(results[0][0]) == 0):
    print('A least one manuscript must be scheduled for the issue')
    return

  query = "UPDATE Manuscript SET ManStatus = 'published', StatusTimestamp = NOW() WHERE Issue_idIssue = '{}';".format(issue)
  cursor.execute(query)
  
  return 

def editorReset():
  return