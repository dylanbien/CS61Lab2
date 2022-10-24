-- ----------------------------------------------------
-- Test Trigger (1) before_manuscript_insert
-- -----------------------------------------------------

-- Only one reviewer is assigned ICode 102.
INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('quis urna. Nunc quis arcu vel quam dignissim pharetra.',5,'Charde Carlson, Noelle Beach',102,2);
SELECT * FROM Manuscript WHERE idManuscript = 27;

-- ICode 125 is not within Scope

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('augue ut lacus. Nulla tincidunt, neque',5,'Bianca Conway',125,1);
SELECT * FROM Manuscript WHERE idManuscript = 28;

-- ----------------------------------------------------
-- Test Trigger (2) after_reviewer_resigned
-- -----------------------------------------------------

-- Manuscript 19 has three reviewers, we delete two of its reviews, then delete its last reviewer. 
-- Its status should revert to "received" since two other reviewers remain.

DELETE FROM Review WHERE Manuscript_idManuscript = 19 AND Reviewer_Users_idReviewer != 8;
DELETE FROM Users WHERE idUser = 8;

-- Reviewer 8 was also the sole reviewer associated with ICode 102, so Manuscript 27 now has no reviewers.
-- Its status should change to "rejected".

SELECT * FROM Manuscript WHERE idManuscript = 19 OR idManuscript = 28;

-- ----------------------------------------------------
-- Test Trigger (3) before_manuscript_status_updated
-- -----------------------------------------------------

-- Setting Manuscript 19's status to "accepted" should trigger it's status to auto-change to "in typesetting".

UPDATE Manuscript SET ManStatus = 'accepted' WHERE idManuscript = 19;
SELECT * FROM Manuscript WHERE idManuscript = 19;