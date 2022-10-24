
-- -----------------------------------------------------
-- View ICodeNumReviewers 
-- -----------------------------------------------------

DROP VIEW IF EXISTS ICodeNumReviewers;

CREATE VIEW ICodeNumReviewers AS
  SELECT ICode_ICode, count(*) as ReviewerCount 
	FROM ICode
	JOIN ReviewerGroup on ICode.ICode = ReviewerGroup.ICode_ICode
	JOIN Reviewer on Reviewer.Users_idReviewer = ReviewerGroup.Reviewer_Users_idReviewer
	GROUP BY ICode;

-- -----------------------------------------------------
-- Trigger after_manuscript_insert
-- -----------------------------------------------------

CREATE TRIGGER after_manuscript_insert
    AFTER INSERT ON Manuscript
    FOR EACH ROW 
    BEGIN
		IF (NEW.ICode_ICode NOT IN (SELECT ICode_ICode FROM ICodeNumReviewers)) 
			THEN
        SET NEW.ManStatus = 'rejected';
        SET @msg = concat('LAB2: No reviewers for manuscript id ', cast(idManuscript as char), ', notified author via email');
			  signal sqlstate '45000' set message_text = @msg;

    END IF$$
DELIMITER ;


-- -----------------------------------------------------
-- Trigger after_reviewer_resigned
-- Rejects manuscript and throws errors if no reviewer with the required ICode is available
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS after_status_updated;
DROP TRIGGER IF EXISTS after_reviewer_resigned;

DELIMITER $$
CREATE TRIGGER after_status_updated
    AFTER UPDATE ON Manuscript
    FOR EACH ROW 
    BEGIN
		IF (NEW.ManStatus = 'rejected') 
		THEN
			SET @msg = concat('LAB2: No reviewers for manuscript id ', cast(NEW.idManuscript as char), ', notified author via email');
			signal sqlstate '45000' set message_text = @msg;
		END IF;
     
		IF (NEW.ManStatus = 'received') 
		THEN
			SET @msg = concat('LAB2: Reviewer for manuscript id ', cast(NEW.idManuscript as char), ' resigned, status reverted to received');
			signal sqlstate '45000' set message_text = @msg;
		END IF;
    END$$
DELIMITER $$;

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
-- Trigger before_manuscript_status_updated
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