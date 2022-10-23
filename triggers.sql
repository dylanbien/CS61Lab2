-- -----------------------------------------------------
-- View IcodeNumReviewers 
-- -----------------------------------------------------

DROP VIEW IF EXISTS IcodeNumReviewers;

CREATE VIEW IcodeNumReviewers AS
    Select  ICode, count(*) as reviewerCount 
	FROM ICode
	JOIN ReviewerGroup on ICode.ICode = ReviewerGroup.ICode_ICode
	JOIN Reviewer on Reviewer.Users_idReviewer = ReviewerGroup.Reviewer_Users_idReviewer
	GROUP BY ICode;

-- -----------------------------------------------------
-- Trigger after_new_manuscript_submitted 
-- -----------------------------------------------------

CREATE TRIGGER before_manuscript_submit
    BEFORE INSERT ON Manuscript
    FOR EACH ROW 
		IF (ICodeId NOT IN (select ICode from IcodeNumReviewers)) 
			THEN
             set @msg = concat('LAB2: No reviewers for manuscript id ', cast(idManuscript as char));
			 signal sqlstate '45000' set message_text = @msg;

    END IF$$
DELIMITER ;

-- -----------------------------------------------------
-- Trigger after_author_deleted
-- Rejects manuscript and throws errors if no reviewer with the required ICode is available
-- -----------------------------------------------------

--get manuscript to number of reviewers iwth same icode

DELIMITER $$

DROP TRIGGER IF EXISTS after_author_deleted;

CREATE TRIGGER after_author_deleted
    AFTER DELETE ON Author
    FOR EACH ROW BEGIN

    INSERT INTO players_audit
    SET action = 'delete',
     pID = OLD.pID,
        pName = OLD.pName,
        changed_on = NOW();
END$$
DELIMITER ;


-- -----------------------------------------------------
-- Trigger after_manuscript_updated
-- -----------------------------------------------------

DROP TRIGGER IF EXISTS before_manuscript_updated;
DELIMITER $$
CREATE TRIGGER before_manuscript_updated
  BEFORE UPDATE ON Manuscript
  FOR EACH ROW 
  BEGIN
	  IF NEW.ManStatus = 'Accepted' THEN
	    SET NEW.ManStatus = 'TypeSetting';
	  END IF;
	END$$
DELIMITER ;