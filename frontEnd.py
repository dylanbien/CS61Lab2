from atexit import register
from dbconfig import read_db_config
import getpass
from commands.register import registerUser
from commands.login import loginUser
from commands.resign import resignReviewer
from commands.authorCommands import authorStatus, submit
from commands.reviewerCommand import revewerUpdateManuscript
from commands.editorCommands import editorStatus, editorAssignManuscript, editorUpdateManuscript, editorSchedule, editorPublish, editorReset
from mysql.connector import MySQLConnection, Error, errorcode, FieldType
## from commands.resign import resignUser

def frontend():


    dbconfig = read_db_config()
    if dbconfig['password'] == "":  
        dbconfig['password'] = getpass.getpass("database password ? :")
    
    print(dbconfig)
    
    # Connect to the database
    try:
        print('Connecting to MySQL database...')
        conn = MySQLConnection(**dbconfig)
 
        if conn.is_connected():
            print('connection established.')
            mycursor = conn.cursor(buffered=True)
        else:
            print('connection failed.')

    except mysql.connector.Error as err:
        print('connection failed somehow')
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your username or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print("Unexpected error")
            print(err)
            sys.exit(1)

    user = None
    userID = None

    while True:
        if userID is None:
            command = input("Welcome. What would you like to do?: ")

            if(command.split(' ')[0] == 'register'):
                name,user,userID = registerUser(mycursor, command)
            elif(command.split(' ')[0] == 'login'):
                name,user,userID = loginUser(mycursor, command)
            elif(command == 'done'):
                break
            else:
                print("Unknown command. Try again!")

        else:
            command = input("Welcome " + name + ". What would you like to do?: " )

            if (user == "author"):
                if (command == "status"):
                    authorStatus(mycursor, userID)
                elif (command.split(' ')[0] == 'submit'):
                    submit(mycursor, userID, command)
                elif (command == "done"):
                    break
                else:
                    print("Unknown command. Try again!")

            elif (user == "editor"):
                if (command == "status"):
                    editorStatus(mycursor)
                elif (command.split(' ')[0] == 'assign'):
                    editorAssignManuscript(mycursor, command)
                elif (command.split(' ')[0] == 'reject'):
                    editorUpdateManuscript(mycursor, command, 'reject')
                elif (command.split(' ')[0] == 'accept'):
                    editorUpdateManuscript(mycursor, command, 'accept')
                elif (command.split(' ')[0] == 'schedule'):
                    editorSchedule(mycursor, command)
                elif (command.split(' ')[0] == 'publish'):
                  editorPublish(mycursor, command)
                elif (command == "done"):
                    break
                else:
                    print("Unknown command. Try again!")
        
            elif (user == "reviewer"):
                if (command.split(' ')[0] == 'reject'):
                  revewerUpdateManuscript(mycursor, command, userID, 'reject')
                elif (command.split(' ')[0] == 'accept'):
                  revewerUpdateManuscript(mycursor, command, userID, 'accept')
                elif (command == "resign"):
                  resignReviewer(mycursor, userID)
                  user, userID = None, None
                  print("Thank you for your service.")
                elif command == 'done':
                    break
                else:
                    print("Unknown command. Try again!")
            
            

    mycursor.close()
    conn.cmd_reset_connection()
    conn.close()
    print("\nDONE")


if __name__ == '__main__':
    frontend()
