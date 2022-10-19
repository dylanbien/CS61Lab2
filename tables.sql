/*
select the schema
*/
use F003WX1_db;

/*
Drop existing tables
*/
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Manuscript;
DROP TABLE IF EXISTS Issue;
DROP TABLE IF EXISTS ReviewerGroup;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Scope;
DROP TABLE IF EXISTS Journal;
DROP TABLE IF EXISTS ICode;
DROP TABLE IF EXISTS Editor;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Users;

-- -----------------------------------------------------
-- Table JOURNAL
-- -----------------------------------------------------
CREATE TABLE Journal (
  idJournal INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (idJournal)
  );

-- -----------------------------------------------------
-- Table ISSUE
-- -----------------------------------------------------
CREATE TABLE Issue (
  idIssue VARCHAR(6) NOT NULL,
  Journal_idJournal INT UNSIGNED NOT NULL,
  PublicationDate DATETIME NOT NULL,
  PRIMARY KEY (idIssue),
  FOREIGN KEY (Journal_idJournal) REFERENCES Journal (idJournal)
);

-- -----------------------------------------------------
-- Table ICODE
-- -----------------------------------------------------
CREATE TABLE ICode (
  Code INT NOT NULL AUTO_INCREMENT,
  Interest VARCHAR(64) NOT NULL,
  PRIMARY KEY (Code)
);

-- -----------------------------------------------------
-- Table SCOPE
-- -----------------------------------------------------
CREATE TABLE Scope (
  Journal_idJournal INT UNSIGNED NOT NULL,
  ICode_Code INT NOT NULL,
  PRIMARY KEY (Journal_idJournal, ICode_Code),
  FOREIGN KEY (Journal_idJournal) REFERENCES Journal (idJournal),
  FOREIGN KEY (ICode_Code) REFERENCES ICode (Code)
);

-- -----------------------------------------------------
-- Table USERS
-- -----------------------------------------------------
CREATE TABLE Users (
  idUser INT UNSIGNED NOT NULL AUTO_INCREMENT,
  FName VARCHAR(45) NOT NULL,
  LName VARCHAR(45) NOT NULL,
  PRIMARY KEY (idUser)
);

-- -----------------------------------------------------
-- Table EDITOR
-- -----------------------------------------------------
CREATE TABLE Editor (
  User_idEditor INT UNSIGNED NOT NULL,
  PRIMARY KEY (User_idEditor),
  FOREIGN KEY (User_idEditor) REFERENCES Users (idUser)
);

-- -----------------------------------------------------
-- Table AUTHOR
-- -----------------------------------------------------
CREATE TABLE Author (
  User_idAuthor INT UNSIGNED NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Affiliation VARCHAR(45) NOT NULL,
  PRIMARY KEY (User_idAuthor),
  FOREIGN KEY (User_idAuthor) REFERENCES Users(idUser)
);

-- -----------------------------------------------------
-- Table REVIEWER
-- -----------------------------------------------------
CREATE TABLE Reviewer (
  User_idReviewer INT UNSIGNED NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Affiliation VARCHAR(45) NOT NULL,
  PRIMARY KEY (User_idReviewer),
  FOREIGN KEY (User_idReviewer) REFERENCES Users (idUser)
  );


-- -----------------------------------------------------
-- Table REVIEWERGROUP
-- -----------------------------------------------------
CREATE TABLE ReviewerGroup (
  Reviewer_User_idReviewer1 INT UNSIGNED NOT NULL,
  ICode_Code INT NOT NULL,
  PRIMARY KEY (Reviewer_User_idReviewer1, ICode_Code),
  FOREIGN KEY (ICode_Code) REFERENCES ICode (Code),
  FOREIGN KEY (Reviewer_User_idReviewer1) REFERENCES Reviewer (User_idReviewer)
);

-- -----------------------------------------------------
-- Table MANUSCRIPT
-- -----------------------------------------------------
CREATE TABLE Manuscript (
  idManuscript INT NOT NULL,
  Title VARCHAR(180) NOT NULL,
  Author_User_idAuthor INT UNSIGNED NOT NULL,
  CoAuthors VARCHAR(280) NULL,
  ICode_Code INT NOT NULL,
  Status VARCHAR(45) NOT NULL DEFAULT 'Received',
  StatusTimestamp DATETIME NOT NULL,
  Editor_User_idEditor INT UNSIGNED NULL,
  Issue_idIssue VARCHAR(6) NULL,
  NumPages INT UNSIGNED NULL,
  BeginningPage INT UNSIGNED NULL,
  PRIMARY KEY (idManuscript),
  FOREIGN KEY (ICode_Code) REFERENCES ICode (Code),
  FOREIGN KEY (Issue_idIssue) REFERENCES Issue (idIssue),
  FOREIGN KEY (Editor_User_idEditor) REFERENCES Editor (User_idEditor),
  FOREIGN KEY (Author_User_idAuthor) REFERENCES Author (User_idAuthor)
);


-- -----------------------------------------------------
-- Table REVIEW
-- -----------------------------------------------------
CREATE TABLE Review (
  Reviewer_User_idReviewer1 INT UNSIGNED NOT NULL,
  Manuscript_idManuscript INT NOT NULL,
  AssignedTimestamp DATETIME NOT NULL,
  SubmittedTimestamp DATETIME NULL,
  AScore INT UNSIGNED NULL,
  CScore INT UNSIGNED NULL,
  MScore INT UNSIGNED NULL,
  EScore INT UNSIGNED NULL,
  Recommendation VARCHAR(45) NULL,
  PRIMARY KEY (Reviewer_User_idReviewer1, Manuscript_idManuscript),
  FOREIGN KEY (Manuscript_idManuscript) REFERENCES Manuscript (idManuscript),
  FOREIGN KEY (Reviewer_User_idReviewer1) REFERENCES Reviewer (User_idReviewer)
);