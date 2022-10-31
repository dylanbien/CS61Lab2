
-- -----------------------------------------------------
-- Testing Manuscripts
-- -----------------------------------------------------

-- Manuscript 2 has an average score of 33 and should be accepted
CALL DocumentDecision(2, @decisionAccepted);
SELECT @decisionAccepted;

-- Manuscript 18 has an average score of 13 and should be rejected
CALL DocumentDecision(18, @decisionRejected);
SELECT @decisionRejected;


-- -----------------------------------------------------
-- Query Validation
-- -----------------------------------------------------

SELECT idManuscript, Reviewer_Users_idReviewer, AVG(AScore + CScore + MScore + EScore) AS AverageTotalScore
	FROM Manuscript 
	INNER JOIN Review ON Manuscript.idManuscript = Review.Manuscript_idManuscript
	WHERE idManuscript IN (2,18)
	GROUP BY idManuscript, Reviewer_Users_idReviewer;