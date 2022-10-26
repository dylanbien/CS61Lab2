from atexit import register
from dbconfig import read_db_config
import getpass
from commands.register import registerUser
from commands.login import loginUser
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
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print("Unexpected error")
            print(err)
            sys.exit(1)


    while True:
        command = input("Welcome. What would you like to do?: ")

        userID = None

        if(command.split(' ')[0] == 'register'):
            registerUser(mycursor, command)
        elif(command.split(' ')[0] == 'login'):
            loginUser(mycursor, command)
       ## elif(command.split(' ')[0] == 'resign'):
       ##     loginUser(mycursor, command)
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
