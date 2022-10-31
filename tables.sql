/*
select the database
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
  NextPage INT UNSIGNED NOT NULL DEFAULT 1,
  PublicationDate DATETIME NULL,
  PRIMARY KEY (idIssue),
  FOREIGN KEY (Journal_idJournal) REFERENCES Journal (idJournal)
);

-- -----------------------------------------------------
-- Table ICODE
-- -----------------------------------------------------
CREATE TABLE ICode (
  ICode INT NOT NULL AUTO_INCREMENT,
  Interest VARCHAR(64) NOT NULL,
  PRIMARY KEY (ICode)
);

-- -----------------------------------------------------
-- Table SCOPE
-- -----------------------------------------------------
CREATE TABLE Scope (
  Journal_idJournal INT UNSIGNED NOT NULL,
  ICode_ICode INT NOT NULL,
  PRIMARY KEY (Journal_idJournal, ICode_ICode),
  FOREIGN KEY (Journal_idJournal) REFERENCES Journal (idJournal),
  FOREIGN KEY (ICode_ICode) REFERENCES ICode (ICode)
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
  Users_idEditor INT UNSIGNED NOT NULL,
  PRIMARY KEY (Users_idEditor),
  FOREIGN KEY (Users_idEditor) REFERENCES Users (idUser) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table AUTHOR
-- -----------------------------------------------------
CREATE TABLE Author (
  Users_idAuthor INT UNSIGNED NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Affiliation VARCHAR(45) NOT NULL,
  PRIMARY KEY (Users_idAuthor),
  FOREIGN KEY (Users_idAuthor) REFERENCES Users(idUser) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table REVIEWER
-- -----------------------------------------------------
CREATE TABLE Reviewer (
  Users_idReviewer INT UNSIGNED NOT NULL,
  Email VARCHAR(100) NULL,
  Affiliation VARCHAR(45) NULL,
  PRIMARY KEY (Users_idReviewer),
  FOREIGN KEY (Users_idReviewer) REFERENCES Users (idUser) ON DELETE CASCADE
  );

-- -----------------------------------------------------
-- Table REVIEWERGROUP
-- -----------------------------------------------------
CREATE TABLE ReviewerGroup (
  Reviewer_Users_idReviewer INT UNSIGNED NOT NULL,
  ICode_ICode INT NOT NULL,
  PRIMARY KEY (Reviewer_Users_idReviewer, ICode_ICode),
  FOREIGN KEY (ICode_ICode) REFERENCES ICode (ICode),
  FOREIGN KEY (Reviewer_Users_idReviewer) REFERENCES Reviewer (Users_idReviewer) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table MANUSCRIPT
-- -----------------------------------------------------
CREATE TABLE Manuscript (
  idManuscript INT NOT NULL AUTO_INCREMENT,
  Title VARCHAR(180) NOT NULL,
  Author_Users_idAuthor INT UNSIGNED NOT NULL,
  CoAuthors VARCHAR(280) NULL,
  ICode_ICode INT NOT NULL,
  ManStatus VARCHAR(45) NOT NULL DEFAULT 'received',
  StatusTimestamp DATETIME NOT NULL DEFAULT (NOW()),
  Editor_Users_idEditor INT UNSIGNED NULL,
  Issue_idIssue VARCHAR(6) NULL,
  NumPages INT UNSIGNED NULL,
  BeginningPage INT UNSIGNED NULL,
  CONSTRAINT ManStatus_Valid CHECK (ManStatus IN ('received', 'under review', 'accepted', 'rejected', 'in typesetting', 'ready', 'scheduled for publication', 'published')),
  CONSTRAINT PageLimit CHECK (NumPages + BeginningPage - 1 <= 100),
  PRIMARY KEY (idManuscript),
  FOREIGN KEY (ICode_ICode) REFERENCES ICode (ICode),
  FOREIGN KEY (Issue_idIssue) REFERENCES Issue (idIssue),
  FOREIGN KEY (Editor_Users_idEditor) REFERENCES Editor (Users_idEditor),
  FOREIGN KEY (Author_Users_idAuthor) REFERENCES Author (Users_idAuthor)
);

-- -----------------------------------------------------
-- Table REVIEW
-- -----------------------------------------------------
CREATE TABLE Review (
  Reviewer_Users_idReviewer INT UNSIGNED NOT NULL,
  Manuscript_idManuscript INT NOT NULL,
  AssignedTimestamp DATETIME NOT NULL DEFAULT (NOW()),
  SubmittedTimestamp DATETIME NULL,
  AScore INT UNSIGNED NULL,
  CScore INT UNSIGNED NULL,
  MScore INT UNSIGNED NULL,
  EScore INT UNSIGNED NULL,
  Recommendation VARCHAR(45) NULL,
  CONSTRAINT AScore_Range CHECK (AScore >= 1 AND AScore <= 10),
  CONSTRAINT CScore_Range CHECK (CScore >= 1 AND CScore <= 10),
  CONSTRAINT MScore_Range CHECK (MScore >= 1 AND MScore <= 10),
  CONSTRAINT EScore_Range CHECK (EScore >= 1 AND EScore <= 10),
  CONSTRAINT Recommendation_Valid CHECK (Recommendation IN ('accept', 'reject')),
  PRIMARY KEY (Reviewer_Users_idReviewer, Manuscript_idManuscript),
  FOREIGN KEY (Manuscript_idManuscript) REFERENCES Manuscript (idManuscript),
  FOREIGN KEY (Reviewer_Users_idReviewer) REFERENCES Reviewer (Users_idReviewer) ON DELETE CASCADE
);