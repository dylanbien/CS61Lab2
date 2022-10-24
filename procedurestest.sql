
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

select idManuscript, Reviewer_Users_idReviewer, avg(AScore + CScore + MScore + EScore) as AverageTotalScore
	from Manuscript 
	INNER JOIN Review on Manuscript.idManuscript = Review.Manuscript_idManuscript
	where idManuscript in (2,18)
	group by idManuscript, Reviewer_Users_idReviewer;