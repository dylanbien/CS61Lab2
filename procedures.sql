SET @reject_score = 30;

DROP PROCEDURE IF EXISTS DocumentDecision;
DELIMITER $$
CREATE PROCEDURE DocumentDecision(IN manuscriptID int, OUT result varchar(10))
	BEGIN

    IF 
      (select avg(AScore + CScore + MScore + EScore) as AverageScore
        from Manuscript 
        INNER JOIN Review on Manuscript.idManuscript = Review.Manuscript_idManuscript
        where manuscriptID = Manuscript.idManuscript
        group by Manuscript.idManuscript
      ) < @reject_score
    THEN
      SET result = 'rejected';
    ELSE
      SET result = 'accepted';
    END IF;
  END$$
DELIMITER ;