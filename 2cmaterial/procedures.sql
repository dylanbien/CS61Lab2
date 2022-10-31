SET @reject_score = 30;

DROP PROCEDURE IF EXISTS DocumentDecision;
DELIMITER $$
CREATE PROCEDURE DocumentDecision(IN manuscriptID INT, OUT result VARCHAR(10))
	BEGIN

    IF 
      (SELECT AVG(AScore + CScore + MScore + EScore) AS AverageScore
        FROM Manuscript 
        INNER JOIN Review ON Manuscript.idManuscript = Review.Manuscript_idManuscript
        WHERE manuscriptID = Manuscript.idManuscript
        GROUP BY Manuscript.idManuscript
      ) < @reject_score
    THEN
      SET result = 'rejected';
    ELSE
      SET result = 'accepted';
    END IF;
  END$$
DELIMITER ;