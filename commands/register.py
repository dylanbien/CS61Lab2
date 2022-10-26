from mysql.connector import MySQLConnection, Error, errorcode, FieldType

## assumes fname, lname, email each contain no spaces

def registerUser(cursor, command):

  params = command.split(' ')
  if len(params) < 4:
    print("error: not enough params")
    return

  fname = params[2]
  lname = params[3]

  if(params[1] == 'author'):
    
    if len(params) < 6: 
      print("error: not enough params")
      return

    email = params[4]
    affiliation = ""
    for i in range(5, len(params)):
      affiliation += params[i] + " "
    affiliation = affiliation[:-1]
  
  elif(params[1] == 'reviewer'):
    
    if len(params) < 5:
      print("error: not enough params")
      return

    icodes = []

    for i in range (4, 7):
      if i >= len(params):
        break
      if(params[i].isdigit()):
        icodes.append(int(params[i]))
      else:
        print("error: bad icode")

  elif(params[1] != 'editor'):
    print("error: bad user type")
    return

  
  query = "INSERT INTO `{}` (`fname`,`lname`) VALUES ('{}','{}');".format(params[1], fname, lname)

  ## cursor.execute(query)
