# CS61Lab2

For part 2C of Lab 2, we have submitted the following files:

- tables.sql
- insert.sql
- views.sql
- procedures.sql
- procedurestest.sql
- triggersetup.sql
- triggers.sql
- triggertest.sql

A brief description of each file can be found below.

### tables.sql

SQL code for creating the following tables in the MySQL database:

- **Journal**
- **Issue**
- **ICode**
- **Scope**
- **Users**
- **Editor**
- **Author**
- **Reviewer**
- **ReviewerGroup**, a helper table that links Reviewers to ICodes
- **Manuscript**, which has the check constraint that ManStatus is valid, among "received", "under review", "accepted", "rejected", "in typesetting", "ready", "scheduled for publication", "published", and that the issue containing the manuscript has no more than 100 pages.
- **Review**, which has the check constraints that A-, C-, M-, and E-Scores are between 1 and 10, and that Recommendation is either "accept" or "reject".

Note:
- There are several places within the domain and problem statement where the default manuscript status is referred to as "received", and other places where it is referred to as "submitted". We've taken these terms to represent equivalent states and made the choice to use only "received" for consistency purposes.

### insert.sql

SQL code that contains insert statements for the following test data:

- A single **Journal** that will represent the Journal Of Competitive Kinesiology.
- Two **Issues** of the journal.
- 125 **ICodes**. The first 124 are provided, along with one additional ICode for "Baking". Each of the first 124 ICodes are within the **Scope** of the Journal.
- Ten **Users**. The first three users are **Editors**. The next three users are **Authors**. The remaining four are **Reviewers**.
- Assignments of each reviewer to three ICodes through the **ReviewerGroup** table.
- Four **Manuscripts** and twelve corresponding **Reviews** that make up a *published* issue of the journal.
- Six **Manuscripts** and 18 corresponding **Reviews** that make up a *scheduled for publication* issue of the journal.
- Two **Manuscripts** and six corresponding **Reviews** that are *ready* to be published.
- Two **Manuscripts** and six corresponding **Reviews** that are *in typesetting*.
- Two **Manuscripts** and six corresponding **Reviews** that have been *accepted*.
- Two **Manuscripts** and six corresponding **Reviews** that have been *rejected*.
- Two **Manuscripts** that have been *rejected* for having ICodes that are out of scope or have no available reviewers.
- Two **Manuscripts** that have been *received* and must be assigned to reviewers.
- Two **Manuscripts** that have been *received* and must be auto-rejected for having ICodes that are out of scope or have no available reviewers.

### views.sql

SQL code that creates the following views:

- **LeadAuthorManuscripts** which displays all manuscripts associated with each primary author.
- **AnyAuthorManuscripts** which displays all manuscripts associated with all authors (primary or co-authors).
- **PublishedIssues** which displays the manuscripts in all published issues of the journal.
- **ReviewQueue** which displays all manuscripts with an "under review" status.
- **WhatsLeft** which displays all manuscripts that have not been "published" or "rejected".
- **ReviewStatus** which displays all reviews assigned to a given reviewer that have been "submitted".

Notes: 
- For all relevant tables, we took "increasing timestamp" to mean most recent timestamp first.
- We referenced the following website in the **AnyAuthorManuscripts** view: https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows
- It is unclear where the **ReviewQueue** would be needed in the **ReviewStatus** view. To filter out any unsubmitted reviews by a given reviewer, we checked for a NULL SubmissionTimestamp. This question was asked but not answered in Slack, hence we interpreted this as we saw fit.
- We have introduced a variable @rev_id to represent the reviewer's ID which is being queried for the **ReviewStatus** view. We have hard-coded this value to be 8, but any of the IDs among {7, 8, 9, 10} represent reviewers from our *insert.sql* file and may be tested accordingly.

### triggersetup.sql

This file is blank, as all necessary setup is done by running the **insert.sql** file.

### triggers.sql

SQL code that creates the following triggers:

1. **before_manuscript_insert** which sets a manuscript's status to "rejected" if there are no reviewers associated with its ICode, and **after_manuscript_insert** which raises an exception and notifies the author if the manuscript has been auto-rejected. This exception prevents the manuscript from being inserted into the table.
2. **after_reviewer_resigned** which sets a manuscript's status to "rejected" if its sole possible reviewer resigns, or reverts its status to "received" if its sole reviewer resigns, but there are other reviewers available associated with its ICode. 
3. **before_manuscript_status_updated** which automatically sets a manuscript's status to "in typesetting" once it has been "accepted".

Notes: 
- For a Reviewer to resign, their ID must be removed from the **Users** table, which will cause the user to be deleted from the **Reviewer** table (as well as any associated rows in the **Review** and **ReviewerGroup** tables) via ON DELETE CASCADE. We borrowed this tactic from the following site: https://www.sqlshack.com/delete-cascade-and-update-cascade-in-sql-server-foreign-key/.

### triggertest.sql

SQL code that tests the above triggers. 

Notes: 
- Must run **insert.sql** before running **triggertest.sql**.
- **triggertest.sql** should be run line-by-line, since some of the tests cause exceptions, or check the "Continue SQL script execution on errors (by default)" box under the SQL Execution tab in MySQLWorkbench preferences.
- Line 33, which deletes a row from the *Users* table, required us to uncheck the "Safe Updates" box under the SQL Editor tab in MySQLWorkbench preferences. 

### procedures.sql

SQL code for setting up the procedure to output an accept/reject decision based on a manuscript's average review score.

### procedurestest.sql

SQL code that tests the above procedures (both an acceptance and a rejection).