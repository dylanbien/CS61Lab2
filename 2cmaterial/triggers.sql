
-- -----------------------------------------------------
-- Trigger (1) before_manuscript_insert and after_manuscript_insert
-- -----------------------------------------------------

DELIMITER $$
CREATE TRIGGER before_manuscript_insert
BEFORE INSERT ON Manuscript
FOR EACH ROW BEGIN
	IF ((SELECT COUNT(*) FROM ReviewerGroup WHERE ICode_ICode = NEW.ICode_ICode) < 3) THEN
    SET NEW.ManStatus = 'rejected';
  END IF;
END$$

CREATE TRIGGER after_manuscript_insert
AFTER INSERT ON Manuscript
FOR EACH ROW BEGIN
	IF (NEW.ManStatus = 'rejected') THEN
    SET @msg = concat('LAB2: Not enough reviewers for manuscript id ', cast(NEW.idManuscript AS CHAR), ', notified author via email');
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
  END IF;
END$$


-- -----------------------------------------------------
-- Trigger (2) after_reviewer_resigned
-- Rejects manuscript if no reviewer with the required ICode is available, or reverts status to received if is
-- -----------------------------------------------------

CREATE TRIGGER after_reviewer_resigned
BEFORE DELETE ON Users
FOR EACH ROW BEGIN
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

-- -----------------------------------------------------
-- Trigger (3) before_manuscript_status_updated
-- -----------------------------------------------------

CREATE TRIGGER before_manuscript_status_updated
BEFORE UPDATE ON Manuscript
FOR EACH ROW BEGIN
	IF NEW.ManStatus = 'accepted' THEN
	  SET NEW.ManStatus = 'in typesetting';
	END IF;
END$$