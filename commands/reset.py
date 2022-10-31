
def resetDatabase(cursor, conn):
  
  # reset tables
  f = open('tables.sql', 'r')
  file = " ".join(f.readlines())
  for query in file.split(';'):
    cursor.execute(query)

  # set views
  f = open('viewsetup.sql', 'r')
  file = " ".join(f.readlines())
  for query in file.split(';'):
    cursor.execute(query)

  # Set up triggers
  f = open('triggersetup.sql', 'r')
  file = " ".join(f.readlines())
  for query in file.split(';'):
    cursor.execute(query)

  # Create triggers
  query = """DELIMITER $$ 
    CREATE TRIGGER before_manuscript_insert 
    BEFORE INSERT ON Manuscript 
    FOR EACH ROW BEGIN 
      IF ((SELECT COUNT(*) FROM ReviewerGroup WHERE ICode_ICode = NEW.ICode_ICode) < 3) THEN 
        SET NEW.ManStatus = 'rejected'; 
      END IF; 
    END$$ DELIMITER ;"""
  cursor.execute(query, multi = True)

  query = """DELIMITER $$
    CREATE TRIGGER after_manuscript_insert
    AFTER INSERT ON Manuscript
    FOR EACH ROW BEGIN
      IF (NEW.ManStatus = 'rejected') THEN
        SET @msg = concat('LAB2: Not enough reviewers for manuscript id ', cast(NEW.idManuscript AS CHAR), ', notified author via email');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
      END IF;
    END$$
    DELIMITER ;"""
  cursor.execute(query, multi = True)

  query = """DELIMITER $$
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
    DELIMITER ;"""
  cursor.execute(query, multi = True)

  query = """DELIMITER $$
    CREATE TRIGGER before_manuscript_status_updated
    BEFORE UPDATE ON Manuscript
    FOR EACH ROW BEGIN
      IF NEW.ManStatus = 'accepted' THEN
        SET NEW.ManStatus = 'ready';
        SET NEW.NumPages = (SELECT FLOOR( RAND() * (20-5) + 5));
      END IF;
    END$$
    DELIMITER ;"""
  cursor.execute(query, multi = True)

  # insert rows
  f = open('tablesetup.sql', 'r')
  file = " ".join(f.readlines())
  for query in file.split(';'):
    cursor.execute(query)

  print("Database reset successful.")
  return 