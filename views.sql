/*
select the schema
*/
use F003WX1_db;

-- -----------------------------------------------------
-- View LeadAuthorManuscripts (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS LeadAuthorManuscripts;

CREATE VIEW LeadAuthorManuscripts AS
    SELECT LName, idUser, idManuscript, ManStatus, StatusTimestamp
    FROM Users
    INNER JOIN Author ON Users.idUser = Author.Users_idAuthor
    INNER JOIN Manuscript on Author.Users_idAuthor = Manuscript.Author_Users_idAuthor
    ORDER BY LName, idUser, StatusTimestamp DESC;
    
-- -----------------------------------------------------
-- View AnyAuthorManuscripts (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS AnyAuthorManuscripts;

CREATE VIEW AnyAuthorManuscripts AS
	SELECT CONCAT(FName, ' ', LName) AS AuthorName, idUser, idManuscript, ManStatus
		FROM Users
		JOIN Author ON Users.idUser = Author.Users_idAuthor
		JOIN Manuscript ON Author.Users_idAuthor = Manuscript.Author_Users_idAuthor
      
	UNION
      
	SELECT CoAuthor AS AuthorName, idUser, idManuscript, ManStatus
		FROM Users
		JOIN Author ON Users.idUser = Author.Users_idAuthor
		RIGHT JOIN (
			SELECT idManuscript, Author_Users_idAuthor, CoAuthors.CoAuthor, ManStatus, StatusTimestamp
			FROM Manuscript 
			INNER JOIN JSON_TABLE(
				REPLACE(CONCAT('["', CoAuthors, '"]'),  ', ', '","'), '$[*]' COLUMNS (CoAuthor VARCHAR(50) PATH '$')
			) AS CoAuthors
		) AS Pivoted 
        ON Pivoted.CoAuthor LIKE CONCAT('%', FName, ' ', LName,'%') 
  
  ORDER BY SUBSTRING_INDEX(AuthorName, " ", 1);


-- -----------------------------------------------------
-- View PublishedIssues (DONE)
-- -----------------------------------------------------
DROP VIEW IF EXISTS PublishedIssues;

CREATE VIEW PublishedIssues AS
  SELECT SUBSTRING(idIssue, 1, 4) AS issueYear, SUBSTRING(idIssue, 6, 1) AS issueNumber, Title, BeginningPage
  FROM Issue 
  LEFT JOIN Manuscript ON Issue.idIssue = Manuscript.Issue_idIssue
  ORDER BY SUBSTRING(idIssue, 1, 4), SUBSTRING(idIssue, 6, 1), BeginningPage ASC;

-- -----------------------------------------------------
-- View ReviewQueue (DONE)
-- -----------------------------------------------------

DROP VIEW IF EXISTS ReviewQueue;

CREATE VIEW ReviewQueue AS
  Select CONCAT(FName, ' ', LName) AS PrimaryAuthor, idUser, idManuscript, AllReviewers.Reviewers
  FROM Users
  INNER JOIN Author ON Users.idUser = Author.Users_idAuthor
  INNER JOIN Manuscript ON Author.Users_idAuthor = Manuscript.Author_Users_idAuthor 
  LEFT JOIN 
    ( -- Combine reviewers for a single manuscript
        SELECT Manuscript_idManuscript, GROUP_CONCAT(FName, ' ', LName SEPARATOR ', ') AS Reviewers
          FROM Users
          INNER JOIN Reviewer ON Users.idUser = Reviewer.Users_idReviewer
          INNER JOIN Review ON Review.Reviewer_Users_idReviewer = Reviewer.Users_idReviewer
          GROUP BY Manuscript_idManuscript 
    ) AS AllReviewers ON Manuscript.idManuscript = AllReviewers.Manuscript_idManuscript
  WHERE ManStatus = 'under review'
  ORDER BY StatusTimestamp DESC;


-- -----------------------------------------------------
-- View WhatsLeft
-- -----------------------------------------------------

CREATE VIEW WhatsLeft AS
  SELECT idManuscript, ManStatus, StatusTimestamp
  FROM Manuscript
  WHERE ManStatus != 'rejected' AND ManStatus != 'published';


-- -----------------------------------------------------
-- View ReviewStatus
-- -----------------------------------------------------

DROP FUNCTION IF EXISTS ViewRevId;
DELIMITER $$
CREATE FUNCTION ViewRevId() RETURNS integer
    DETERMINISTIC
BEGIN
 RETURN (@rev_id);
END$$
DELIMITER ;

SET @rev_id = 7;

DROP VIEW IF EXISTS ReviewStatus;
CREATE VIEW ReviewStatus AS
  SELECT AssignedTimestamp, Manuscript.idManuscript, Title, AScore, CScore, MScore, EScore, Recommendation
  FROM Manuscript
  INNER JOIN Review ON Review.Manuscript_idManuscript = Manuscript.idManuscript
  WHERE Reviewer_Users_idReviewer = ViewRevId() AND Manuscript.idManuscript NOT IN ( SELECT idManuscript from ReviewQueue )
  ORDER BY SubmittedTimestamp DESC;