-- -----------------------------------------------------
-- View LeadAuthorManuscripts
-- -----------------------------------------------------

DROP VIEW IF EXISTS LeadAuthorManuscripts;

CREATE VIEW LeadAuthorManuscripts AS
    SELECT LName, idUser, idManuscript, ManStatus, StatusTimestamp
    FROM Users
    INNER JOIN Author ON Users.idUser = Author.Users_idAuthor
    INNER JOIN Manuscript on Author.Users_idAuthor = Manuscript.Author_Users_idAuthor
    ORDER BY LName, idUser, StatusTimestamp DESC;
    
-- -----------------------------------------------------
-- View AnyAuthorManuscripts
-- -----------------------------------------------------

DROP VIEW IF EXISTS AnyAuthorManuscripts;

CREATE VIEW AnyAuthorManuscripts AS
SELECT AuthorName, idUser, idManuscript, ManStatus FROM (
	SELECT CONCAT(FName, ' ', LName) COLLATE utf8mb4_0900_ai_ci AS AuthorName, idUser, idManuscript, ManStatus, StatusTimestamp
		FROM Users
		JOIN Author ON Users.idUser = Author.Users_idAuthor
		JOIN Manuscript ON Author.Users_idAuthor = Manuscript.Author_Users_idAuthor

	UNION
      
	SELECT CoAuthor AS AuthorName, idUser, idManuscript, ManStatus, StatusTimestamp
		FROM Users
		JOIN Author ON Users.idUser = Author.Users_idAuthor
		RIGHT JOIN (
			SELECT idManuscript, Author_Users_idAuthor, CoAuthors.CoAuthor, ManStatus, StatusTimestamp
			FROM Manuscript 
			INNER JOIN JSON_TABLE(
				REPLACE(CONCAT('["', CoAuthors, '"]'),  ', ', '","'), '$[*]' COLUMNS (CoAuthor VARCHAR(50) PATH '$')
			) AS CoAuthors
		) AS Pivoted 
        ON Pivoted.CoAuthor COLLATE utf8mb4_0900_ai_ci LIKE CONCAT('%', FName, ' ', LName,'%')
  
	ORDER BY SUBSTRING_INDEX(AuthorName, ' ', -1), StatusTimestamp DESC
) AnyAuthorManuscripts;