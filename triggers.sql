-- -----------------------------------------------------
-- Trigger after_new_manuscript_submitted 
-- -----------------------------------------------------

DELIMITER $$

DROP TRIGGER IF EXISTS after_new_manuscript_submitted;

CREATE TRIGGER after_new_manuscript_submitted
    AFTER INSERT ON Manuscript
    FOR EACH ROW 
    BEGIN

    END$$
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

DELIMITER $$

DROP TRIGGER IF EXISTS after_manuscript_updated;

CREATE TRIGGER after_manuscript_updated
  BEFORE UPDATE ON Manuscript
  FOR EACH ROW 
  BEGIN
	  IF new.idManuscript = old.idManuscript && old.status = 'Accepted' THEN
		  SET NEW.Status = 'TypeSetting';
		END IF;
	END$$
DELIMITER ;

