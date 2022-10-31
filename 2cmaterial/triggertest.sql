-- ----------------------------------------------------
-- Test Trigger (1) before_manuscript_insert
-- -----------------------------------------------------

-- Insert Manuscript 27. There are no reviewers assigned ICode 51.

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('quis urna. Nunc quis arcu vel quam dignissim pharetra.',5,'Charde Carlson, Noelle Beach',51,2);

-- Insert Manuscript 28. ICode 125 is not within Scope.

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('quis urna. Nunc quis arcu vel quam dignissim pharetra.',5,'Charde Carlson, Noelle Beach',125,2);

-- ----------------------------------------------------
-- Test Trigger (2) after_reviewer_resigned
-- -----------------------------------------------------

-- Manuscript 19 has three reviewers, we delete two of its reviews to put those reviwers back into the system. 

DELETE FROM Review WHERE Manuscript_idManuscript = 19 AND Reviewer_Users_idReviewer != 8;

-- Insert Manuscript 29 and corresponding Review
INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('quis urna. Nunc quis arcu vel quam dignissim pharetra.',5,'Charde Carlson, Noelle Beach',102,2);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp) VALUES
(8,29,'2020-03-04 19:26:41');

-- Once we delete Reviewer 8, Manuscript 19's status should revert to "received" since two other reviewers remain.
-- Reviewer 8 was also the sole reviewer associated with ICode 102, so Manuscript 29 now has no reviewers, and its status changes to "rejected".

DELETE FROM Users WHERE idUser = 8;

SELECT * FROM Manuscript WHERE idManuscript = 19 OR idManuscript = 29;

-- ----------------------------------------------------
-- Test Trigger (3) before_manuscript_status_updated
-- -----------------------------------------------------

-- Setting Manuscript 19's status to "accepted" should trigger it's status to auto-change to "in typesetting".

UPDATE Manuscript SET ManStatus = 'accepted' WHERE idManuscript = 19;
SELECT * FROM Manuscript WHERE idManuscript = 19;