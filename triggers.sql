
-- -----------------------------------------------------
-- View ICodeNumReviewers, to be used in Triggers (1) and (2)
-- -----------------------------------------------------

DROP VIEW IF EXISTS ICodeNumReviewers;

CREATE VIEW ICodeNumReviewers AS
  SELECT ICode_ICode, count(*) as ReviewerCount 
	FROM ICode
	JOIN ReviewerGroup on ICode.ICode = ReviewerGroup.ICode_ICode
	JOIN Reviewer on Reviewer.Users_idReviewer = ReviewerGroup.Reviewer_Users_idReviewer
	GROUP BY ICode;

-- -----------------------------------------------------
-- Trigger (1) before_manuscript_insert
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS before_manuscript_insert;

DELIMITER $$
CREATE TRIGGER before_manuscript_insert
    BEFORE INSERT ON Manuscript
    FOR EACH ROW 
    BEGIN
		IF (NEW.ICode_ICode NOT IN (SELECT ICode_ICode FROM ICodeNumReviewers)) 
			THEN
        SET NEW.ManStatus = 'rejected';
        SET @msg = concat('LAB2: No reviewers for manuscript id ', cast(idManuscript as char), ', notified author via email');
			  signal sqlstate '45000' set message_text = @msg;

    END IF;
    END$$
DELIMITER ;


-- -----------------------------------------------------
-- Trigger (2) after_reviewer_resigned
-- Rejects manuscript if no reviewer with the required ICode is available, or reverts status to received if is
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS after_reviewer_resigned;

DELIMITER $$
CREATE TRIGGER after_reviewer_resigned
    BEFORE DELETE ON Users
    FOR EACH ROW
    BEGIN
      
      UPDATE Manuscript SET ManStatus = 'received', StatusTimestamp = NOW() WHERE 
      (
        idManuscript IN (SELECT Manuscript_idManuscript FROM Review WHERE Reviewer_Users_idReviewer = OLD.idUser AND SubmittedTimestamp IS NULL)
        AND
        idManuscript NOT IN (SELECT Manuscript_idManuscript FROM Review WHERE Reviewer_Users_idReviewer != OLD.idUser)
        AND
        ICode_ICode IN (SELECT ICode_ICode FROM ICodeNumReviewers WHERE ReviewerCount > 1)
      );

      UPDATE Manuscript SET ManStatus = 'rejected', StatusTimestamp = NOW() WHERE 
      (
        idManuscript IN (SELECT Manuscript_idManuscript FROM Review WHERE Reviewer_Users_idReviewer = OLD.idUser AND SubmittedTimestamp IS NULL)
        AND
        idManuscript NOT IN (SELECT Manuscript_idManuscript FROM Review WHERE Reviewer_Users_idReviewer != OLD.idUser)
        AND
        ICode_ICode NOT IN (SELECT ICode_ICode FROM ICodeNumReviewers WHERE ReviewerCount > 1)
      );

END$$
DELIMITER ;


-- -----------------------------------------------------
-- Trigger (3) before_manuscript_status_updated
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS before_manuscript_status_updated;
DELIMITER $$
CREATE TRIGGER before_manuscript_status_updated
  BEFORE UPDATE ON Manuscript
  FOR EACH ROW 
  BEGIN
	  IF NEW.ManStatus = 'accepted' THEN
	    SET NEW.ManStatus = 'in typesetting';
	  END IF;

END$$
DELIMITER ;