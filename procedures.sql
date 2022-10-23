DROP FUNCTION IF EXISTS DocumentDecision;
DELIMITER $$
CREATE FUNCTION DocumentDecision(manuscriptID integer) RETURNS VARCHAR(6)
BEGIN
    DECLARE result varchar(16);

    IF (
      select avg(AScore + CScore + MScore + EScore) as AverageTotalScore
        from Manuscript 
        INNER JOIN ReviewStatus on Manuscript.idManuscript = ReviewStatus.idManuscript
        where @manuscriptID = Manuscript.idManuscript
        group by Manuscript.idManuscript
      ) < 30
      THEN
      SET result = 'rejected';
    ELSE
    SET result = 'accepted';
    END IF;

 RETURN (lvl);
END$$
DELIMITER ;