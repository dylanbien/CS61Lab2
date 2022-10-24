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
- **Editors**
- **Authors**
- **Reviewers**
- **ReviewerGroup**, a helper table that links Reviewers to ICodes
- **Manuscripts**
- **Reviews**

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
- **ReviewStatus** which displays all reviews assigned to a given reviewer that have not yet been "submitted".

Note: For all relevant tables, we took "increasing timestamp" to mean most recent timestamp first.

We referenced the following website in the **ReviewQueue** view: https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows

### triggersetup.sql

This file is blank, as all necessary setup is done by running the **insert.sql** file.

### triggers.sql

SQL code that creates the following triggers:

1. **before_manuscript_insert** which sets a manuscript's status to "rejected" if there are no reviewers associated with its ICode.
2. **after_reviewer_resigned** which sets a manuscript's status to "rejected" if its sole possible reviewer resigns, or reverts its status to "received" if its sole reviewer resigns, but there are other reviewers available associated with its ICode.
3. **before_manuscript_status_updated** which automatically sets a manuscript's status to "in typesetting" once it has been "accepted".

### triggertest.sql

SQL code that tests the above triggers. NOTE: Must run **insert.sql** before running **triggertest.sql**.

### procedures.sql

SQL code for setting up the procedure to accept/reject based on average review score.

### procedurestest.sql

SQL code that tests the above procedures (both an acceptance and a rejection).