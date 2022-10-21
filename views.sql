-- -----------------------------------------------------
-- View LeadAuthorManuscripts (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS LeadAuthorManuscripts;

CREATE VIEW LeadAuthorManuscripts AS
    SELECT LName, idUser, idManuscript, Status, StatusTimestamp
    FROM Users
    INNER JOIN Author ON Users.idUser = Author.User_idAuthor
    INNER JOIN Manuscript on Author.User_idAuthor = Manuscript.Author_User_idAuthor
    ORDER BY LName, idUser, StatusTimestamp DESC;

-- -----------------------------------------------------
-- View AnyAuthorManuscripts (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS AnyAuthorManuscripts;

CREATE VIEW AnyAuthorManuscripts AS
  SELECT (FName + '' + LName) as AuthorName, idUser, idManuscript, Status
      FROM Users
      INNER JOIN Author ON Users.idUser = Author.User_idAuthor
      LEFT JOIN Manuscript ON 
        Author.User_idAuthor = Manuscript.Author_User_idAuthor OR Manuscript.CoAuthors LIKE ('%' + FName + ' ' +  LName + '%') 
      ORDER BY LName, StatusTimestamp DESC;

-- -----------------------------------------------------
-- View PublishedIssues (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS PublishedIssues;

CREATE VIEW PublishedIssues AS
  SELECT SUBSTRING(idIssue, 1, 4)  as issueYear, SUBSTRING(idIssue, 6, 1) as issueNumber, Title, BeginningPage
    from Issue 
    LEFT JOIN Manuscript ON Issue.idIssue = Manuscript.Issue_idIssue
    ORDER BY SUBSTRING(idIssue, 1, 4), SUBSTRING(idIssue, 6, 1), BeginningPage;

-- -----------------------------------------------------
-- View ReviewQueue (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS ReviewQueue;

CREATE VIEW ReviewQueue AS
  Select (FName + ' ' + LName) as PrimaryAuthor, idUser, idManuscript, AllReviewers.Reviewers
  FROM Users
  INNER JOIN Author ON Users.idUser = Author.User_idAuthor
  INNER JOIN Manuscript on Author.User_idAuthor = Manuscript.Author_User_idAuthor 
  LEFT JOIN 
    ( -- Combine reviewers for a single manuscript
        SELECT Manuscript_idManuscript, GROUP_CONCAT(FName, ' ', LName) as Reviewers
          FROM Users
          INNER JOIN Reviewer ON Users.idUser = Reviewer.User_idReviewer
          INNER JOIN Review ON Review.Reviewer_User_idReviewer1 = Reviewer.User_idReviewer
          GROUP BY Manuscript_idManuscript 
    ) AS AllReviewers ON Manuscript.idManuscript = AllReviewers.Manuscript_idManuscript
  WHERE STATUS = 'UnderReview'
  ORDER BY StatusTimestamp DESC;


-- -----------------------------------------------------
-- View WhatsLeft
-- -----------------------------------------------------
DROP VIEW IF EXISTS WhatsLeft;

CREATE VIEW WhatsLeft AS
  SELECT idManuscript, Status, StatusTimestamp
  FROM Manuscript;


-- -----------------------------------------------------
-- View ReviewStatus
-- -----------------------------------------------------
DROP FUNCTION IF EXISTS ViewRevId;
DELIMITER $$
CREATE FUNCTION ViewRevId(rev_id integer) RETURNS integer
    DETERMINISTIC
BEGIN
 RETURN (rev_id);
END$$
DELIMITER ;


DROP VIEW IF EXISTS ReviewStatus;


CREATE VIEW ReviewStatus AS
  SELECT AssignedTimestamp,Manuscript.idManuscript, Title, AScore, CScore, MScore, EScore, Recommendation
  FROM Manuscript
  LEFT JOIN Review on Review.Manuscript_idManuscript = Manuscript.idManuscript
  LEFT JOIN ReviewQueue ON Manuscript.idManuscript = ReviewQueue.idManuscript
  WHERE Reviewers LIKE 
    (
      Select ('%' + FName + ' ' +  LName + '%')
          FROM Users 
          INNER JOIN Reviewer ON Users.idUser = Reviewer.User_idReviewer
          WHERE Users.idUser = @rev_id
      )
  ORDER BY SubmittedTimestamp;