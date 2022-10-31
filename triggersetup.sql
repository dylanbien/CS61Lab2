
DROP TRIGGER IF EXISTS before_manuscript_insert;
DROP TRIGGER IF EXISTS after_manuscript_insert;
DROP TRIGGER IF EXISTS after_reviewer_resigned;
DROP TRIGGER IF EXISTS before_manuscript_status_updated;

DROP VIEW IF EXISTS ICodeNumReviewers;

-- -----------------------------------------------------
-- View ICodeNumReviewers, to be used in Trigger (2)
-- -----------------------------------------------------

CREATE VIEW ICodeNumReviewers AS
  SELECT ICode_ICode, count(*) as ReviewerCount 
	FROM ICode
	JOIN ReviewerGroup on ICode.ICode = ReviewerGroup.ICode_ICode
	JOIN Reviewer on Reviewer.Users_idReviewer = ReviewerGroup.Reviewer_Users_idReviewer
	GROUP BY ICode;