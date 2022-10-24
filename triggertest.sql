------------------------------------------------------
-- Test Trigger (1) after_author_deleted
-------------------------------------------------------

-- Insert a manuscript with valid Icode
-- Then query

-- Insert a manusciript with an invalid Icode

------------------------------------------------------
-- Test Trigger (2) before_manuscript_status_updated
-------------------------------------------------------

-- deletng a  User with no responose 

-- deleting a user to reverted
DELETE FROM Users WHERE idUser = 8;

-- deleting a user to rejected

------------------------------------------------------
-- Test Trigger (3) before_manuscript_status_updated
-------------------------------------------------------

-- Update a manuscript status
-- Then query

UPDATE Manuscript SET ManStatus = 'Accepted' where idManuscript = 19;

select * from Manuscript where idManuscript = 19;