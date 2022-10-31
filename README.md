# CS61Lab2

To run the front-end application, ensure that you are in a python environment for databases (as described in Lab 0) and that the environment has been activated. From there, run `python3 frontEnd.py` to load the application, and enter inputs via the command line as prompted.

For part D of Lab 2, we have submitted the following files:

- dbconfig.py
- Team23Lab2.ini
- frontEnd.py
- tables.sql
- tablesetup.sql
- viewsetup.sql
- triggersetup.sql
- A folder *commands*, containing the following files:
    - register.py
    - login.py
    - reset.py
    - authorCommands.py
    - editorCommands.py
    - reviewerCommands.py

A brief description of each file can be found below:

#### dbconfig.py

- A python file which reads the config information and returns it in a dictionary

#### Team23Lab2.ini

- A file containing the host, database, user, and password to be used 

#### frontEnd.py

- A python file that 
    - connects to the mysql database
    - resets the database
    - prompts the user to input requests relating to editors, reviewers, and authors per the lab's specs

#### tables.sql
SQL code for creating the following tables in the MySQL database:

- **Journal**
- **Issue**
- **ICode**
- **Scope**
- **Users**
- **Editor**
- **Author**
- **Reviewer**
- **ReviewerGroup**
- **Manuscript**
- **Review**

This file is largely identical to the *tables.sql* file submitted for part 2C, with minor changes to attributes to account for new requirements that arose during implementation of the front-end application.

#### tablesetup.sql

SQL code that contains "CREATE" statements for the following data in order to set up the database:

- Insert an initial Journal into the database
- Insert existing ICodes as provided by the lab description
- Insert those Icodes into the scope of the journal

#### viewsetup.sql

SQL code that contains "CREATE" statements for the *LeadAuthorManuscripts* and *AnyAuthorManuscripts* views as submitted in part 2C. These statements are executed by the **resetDatabase** function provided in the *reset.py* file and called by *frontEnd.py*

#### triggersetup.sql

SQL code that drops any existing triggers and creates the *ICodeNumReviewers* view used by triggers.

## Commands

#### register.py

A python file that allows a user of type **author**, **editor**, or **reviewer** to register.

#### login.py

A python file that allows a user to login, identifying which type of user and outputting the requested information.

#### reset.py

- Resets the database by dropping and recreating the tables, views, triggers and inserting required information
- Table creation, view creation, trigger setup, and inserts are handled in the *tables.sql*, *viewsetup.sql*, *triggersetup.sql* and *tablesetup.sql* files, respectively, which are read in and executed.
- Trigger creation and function creation are hard-coded due to limitations caused by delimiters.

#### authorCommands.py

Implements the author commands **submit** and **status**, per the lab specs.

#### editorCommands.py

Implements the editor commands **status**, **assign**, **reject**, **accept**, **schedule**, **publish**,and **reset**, per the lab specs.

#### reviewerCommands.py

Implements the reviewer commands **reject**, **accept**, and **resign**, per the lab specs.