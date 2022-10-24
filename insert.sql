
-- -------------------------
-- JOURNAL, ISSUES, & ICODES
-- -------------------------

INSERT INTO Journal () VALUES (null);

INSERT INTO Issue (idIssue, Journal_idJournal) VALUES ('2023-2', 1), ('2023-3', 1);

INSERT INTO ICode (Interest) VALUES
('Agricultural engineering'),('Biochemical engineering'),('Biomechanical engineering'),('Ergonomics'),
('Food engineering'),('Bioprocess engineering'),('Genetic engineering'),('Human genetic engineering'),
('Metabolic engineering'),('Molecular engineering'),('Neural engineering'),('Protein engineering'),
('Rehabilitation engineering'),('Tissue engineering'),('Aquatic and environmental engineering'),('Architectural engineering'),
('Civionic engineering'),('Construction engineering'),('Earthquake engineering'),('Earth systems engineering and management'),
('Ecological engineering'),('Environmental engineering'),('Geomatics engineering'),('Geotechnical engineering'),
('Highway engineering'),('Hydraulic engineering'),('Landscape engineering'),('Land development engineering'),
('Pavement engineering'),('Railway systems engineering'),('River engineering'),('Sanitary engineering'),
('Sewage engineering'),('Structural engineering'),('Surveying'),('Traffic engineering'),
('Transportation engineering'),('Urban engineering'),('Irrigation and agriculture engineering'),('Explosives engineering'),
('Biomolecular engineering'),('Ceramics engineering'),('Broadcast engineering'),('Building engineering'),
('Signal Processing'),('Computer engineering'),('Power systems engineering'),('Control engineering'),
('Telecommunications engineering'),('Electronic engineering'),('Instrumentation engineering'),('Network engineering'),
('Neuromorphic engineering'),('Engineering Technology'),('Integrated engineering'),('Value engineering'),
('Cost engineering'),('Fire protection engineering'),('Domain engineering'),('Engineering economics'),
('Engineering management'),('Engineering psychology'),('Ergonomics'),('Facilities Engineering'),
('Logistic engineering'),('Model-driven engineering'),('Performance engineering'),('Process engineering'),
('Product Family Engineering'),('Quality engineering'),('Reliability engineering'),('Safety engineering'),
('Security engineering'),('Support engineering'),('Systems engineering'),('Metallurgical Engineering'),
('Surface Engineering'),('Biomaterials Engineering'),('Crystal Engineering'),('Amorphous Metals'),
('Metal Forming'),('Ceramic Engineering'),('Plastics Engineering'),('Forensic Materials Engineering'),
('Composite Materials'),('Casting'),('Electronic Materials'),('Nano materials'),
('Corrosion Engineering'),('Vitreous Materials'),('Welding'),('Acoustical engineering'),
('Aerospace engineering'),('Audio engineering'),('Automotive engineering'),('Building services engineering'),
('Earthquake engineering'),('Forensic engineering'),('Marine engineering'),('Mechatronics'),
('Nanoengineering'),('Naval architecture'),('Sports engineering'),('Structural engineering'),
('Vacuum engineering'),('Military engineering'),('Combat engineering'),('Offshore engineering'),
('Optical engineering'),('Geophysical engineering'),('Mineral engineering'),('Mining engineering'),
('Reservoir engineering'),('Climate engineering'),('Computer-aided engineering'),('Cryptographic engineering'),
('Information engineering'),('Knowledge engineering'),('Language engineering'),('Release engineering'),
('Teletraffic engineering'),('Usability engineering'),('Web engineering'),('Systems engineering'),('Baking');


-- All ICodes are within Scope of the Journal, except (125, 'Baking') -- 

INSERT INTO Scope (Journal_idJournal, ICode_ICode) VALUES
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),(1, 11),(1, 12),(1, 13),(1, 14),(1, 15),(1, 16),
(1, 17),(1, 18),(1, 19),(1, 20),(1, 21),(1, 22),(1, 23),(1, 24),(1, 25),(1, 26),(1, 27),(1, 28),(1, 29),(1, 30),(1, 31),(1, 32),
(1, 33),(1, 34),(1, 35),(1, 36),(1, 37),(1, 38),(1, 39),(1, 40),(1, 41),(1, 42),(1, 43),(1, 44),(1, 45),(1, 46),(1, 47),(1, 48),
(1, 49),(1, 50),(1, 51),(1, 52),(1, 53),(1, 54),(1, 55),(1, 56),(1, 57),(1, 58),(1, 59),(1, 60),(1, 61),(1, 62),(1, 63),(1, 64),
(1, 65),(1, 66),(1, 67),(1, 68),(1, 69),(1, 70),(1, 71),(1, 72),(1, 73),(1, 74),(1, 75),(1, 76),(1, 77),(1, 78),(1, 79),(1, 80),
(1, 81),(1, 82),(1, 83),(1, 84),(1, 85),(1, 86),(1, 87),(1, 88),(1, 89),(1, 90),(1, 91),(1, 92),(1, 93),(1, 94),(1, 95),(1, 96),
(1, 97),(1, 98),(1, 99),(1, 100),(1, 101),(1, 102),(1, 103),(1, 104),(1, 105),(1, 106),(1, 107),(1, 108),(1, 109),(1, 110),(1, 111),(1, 112),
(1, 113),(1, 114),(1, 115),(1, 116),(1, 117),(1, 118),(1, 119),(1, 120),(1, 121),(1, 122),(1, 123),(1, 124);



-- -----
-- USERS
-- -----

INSERT INTO Users (FName, LName) VALUES
  ('Steven','Hart'),
  ('Barbara','Garrison'),
  ('Buffy','Schmidt'),
  ('Odysseus','Hutchinson'),
  ('Oscar','Newton'),
  ('Amal','Vargas'),
  ('Zorita','Nguyen'),
  ('Naomi','Oneil'),
  ('Wyatt','Mann'),
  ('Roth','Stevens');


-- Editors -- 

INSERT INTO Editor (Users_idEditor) VALUES
(1),(2),(3);


-- Authors -- 

INSERT INTO Author (Users_idAuthor, Email, Affiliation) VALUES
(4, 'ody.hutch@dartmouth.edu', 'Dartmouth College'),
(5, 'osc.newto@dartmouth.edu', 'Dartmouth College'),
(6, 'avargas6@stanford.edu', 'Stanford University');


-- Reviewers -- 

INSERT INTO Reviewer (Users_idReviewer, Email, Affiliation) VALUES
(7, 'zorita.nguyen@cornell.edu', 'Cornell University'),
(8, 'n.oneil@bostonu.edu', 'Boston University'),
(9, 'mannw@rpi.edu', 'Rensselaer Polytechnic Institute'),
(10, 'stevens.roth@mit.edu', 'Massachusetts Institute of Technology');


-- Each Reviewer has three ICodes, only ICodes 44, 50, 81 have three Reviewers -- 

INSERT INTO ReviewerGroup (Reviewer_Users_idReviewer, ICode_ICode) VALUES
(7, 44), (7, 81), (7, 50), 
(8, 50), (8, 102), (8, 81), 
(9, 67), (9, 50), (9, 44), 
(10, 44), (10, 81), (10, 74);



-- -----------
-- MANUSCRIPTS
-- ----------- 

-- published issue 2023-2 -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor, Issue_idIssue, NumPages, BeginningPage) VALUES
('eget massa. Suspendisse eleifend.',5,null,50,'published','2023-04-30 00:11:42',3,'2023-2',29,1),
('dignissim pharetra.',4,'Victor Kramer, Marshall Mcconnell, Nelle Hewitt',81,'published','2023-04-30 00:11:42',2,'2023-2',23,30),
('massa non',5,'Adam Savage',44,'published','2023-04-30 00:11:42',1,'2023-2',20,54),
('imperdiet non, vestibulum nec, euismod in, dolor.',4,null,50,'published','2023-04-30 00:11:42',3,'2023-2',14,75);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,1,'2021-11-10 05:08:13','2022-12-27 17:59:38',10,8,8,9,'accept'),(8,1,'2021-11-10 05:08:13','2022-05-04 16:47:37',7,7,10,7,'accept'),(9,1,'2021-11-10 05:08:13','2022-12-09 09:47:04',10,8,8,9,'accept'),
(7,2,'2021-12-13 16:16:33','2022-10-04 22:25:39',9,9,10,8,'accept'),(8,2,'2021-12-13 16:16:33','2022-12-02 01:22:01',8,8,8,9,'accept'),(10,2,'2021-12-13 16:16:33','2022-09-23 18:22:53',7,8,8,9,'accept'),
(7,3,'2021-12-18 07:32:31','2022-11-28 02:49:10',7,9,8,7,'accept'),(9,3,'2021-12-18 07:32:31','2022-08-04 21:10:39',10,8,10,8,'accept'),(10,3,'2021-12-18 07:32:31','2022-11-18 04:10:03',8,8,10,9,'accept'),
(7,4,'2022-06-26 01:54:36','2023-07-27 13:33:08',7,8,8,9,'accept'),(8,4,'2022-06-26 01:54:36','2023-03-06 10:44:16',9,9,9,7,'accept'),(9,4,'2022-06-26 01:54:36','2022-08-12 02:01:01',9,9,9,10,'accept');


-- scheduled for publication issue 2023-3 -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor, Issue_idIssue, NumPages, BeginningPage) VALUES
('libero. Morbi accumsan laoreet ipsum. Curabitur',4,'Francesca Mathews, Jamalia Ratliff',50,'scheduled for publication','2023-01-23 02:16:17',2,'2023-3',16,1),
('lorem, eget',4,'Oscar Newton, Jamalia Ratliff',50,'scheduled for publication','2023-01-23 02:16:17',1,'2023-3',10,17),
('habitant morbi tristique',5,'Charde Carlson',44,'scheduled for publication','2023-01-23 02:16:17',2,'2023-3',11,28),
('sapien, cursus in, hendrerit consectetuer,',6,'Dalton Combs, Odysseus Hutchinson, Price Lopez',81,'scheduled for publication','2023-01-23 02:16:17',2,'2023-3',20,40),
('ipsum cursus',5,'Eagan Zamora, Noelle Beach',81,'scheduled for publication','2023-01-23 02:16:17',2,'2023-3',7,61),
('amet massa. Quisque',6,'Adria Garrsion, Orla Norman',81,'scheduled for publication','2023-01-23 02:16:17',3,'2023-3',13,68);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,5,'2022-01-28 15:15:05','2022-07-07 02:51:22',7,9,10,7,'accept'),(8,5,'2022-03-09 01:36:07','2022-03-12 00:36:38',10,7,10,7,'accept'),(9,5,'2022-08-08 02:14:31','2022-11-15 20:53:03',7,7,8,9,'accept'),
(7,6,'2021-02-07 16:19:34','2022-10-13 17:08:59',8,9,10,8,'accept'),(8,6,'2022-11-13 01:40:23','2022-11-19 16:52:59',9,9,9,7,'accept'),(9,6,'2020-12-24 13:51:33','2022-06-07 17:14:36',7,7,8,7,'accept'),
(7,7,'2022-02-09 04:56:08','2022-02-09 06:43:22',9,9,9,7,'accept'),(9,7,'2022-06-04 04:19:00','2020-12-26 00:50:43',8,8,8,9,'accept'),(10,7,'2022-10-02 20:40:45','2022-10-26 04:36:05',9,10,8,8,'accept'),
(7,8,'2020-12-16 14:00:02','2022-11-09 11:18:33',7,9,10,9,'accept'),(8,8,'2020-12-06 16:07:56','2021-12-23 10:06:51',10,8,8,8,'accept'),(10,8,'2022-01-10 09:59:13','2022-07-10 11:55:26',8,9,10,9,'accept'),
(7,9,'2022-04-09 10:23:09','2023-01-03 23:02:36',9,9,9,9,'accept'),(8,9,'2021-05-28 12:13:55','2022-04-08 11:21:03',9,8,8,7,'accept'),(10,9,'2021-07-14 12:53:26','2022-05-12 09:49:24',8,8,10,9,'accept'),
(7,10,'2021-10-26 11:01:14','2022-12-04 19:19:00',9,9,9,8,'accept'),(8,10,'2021-01-12 12:55:57','2022-10-01 15:39:08',8,10,9,9,'accept'),(10,10,'2022-06-26 01:39:05','2022-08-06 12:13:23',9,8,9,9,'accept');


-- ready manuscripts not scheduled -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor, NumPages) VALUES
('Donec at arcu.',5,'Noelle Beach',81,'ready','2023-08-01 02:48:58',2,22),
('In mi pede, nonummy',4,'Oscar Newton, Jamalia Ratliff',50,'ready','2023-08-16 05:57:28',1,9);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,11,'2022-08-11 04:10:04','2022-08-11 09:13:51',9,9,9,8,'accept'),(8,11,'2021-09-28 04:13:40','2023-01-15 08:47:43',8,8,9,9,'accept'),(10,11,'2022-09-17 22:23:43','2022-12-22 13:31:22',8,7,8,7,'accept'),
(7,12,'2021-02-21 10:09:35','2022-11-06 17:43:53',10,7,8,8,'accept'),(8,12,'2022-03-17 17:44:38','2023-01-23 03:54:33',8,9,9,9,'accept'),(9,12,'2021-09-22 10:32:41','2021-12-26 14:14:24',9,10,8,9,'accept');


-- manuscripts in typesetting -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor) VALUES 
('tellus lorem eu',6,'Oscar Newton, Orla Norman',81,'in typesetting','2023-03-12 18:18:55',3),
('lectus sit amet',4,null,50,'in typesetting','2022-12-17 12:34:11',2);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,13,'2021-07-29 02:21:33','2021-12-31 10:13:12',8,9,9,10,'accept'),(9,13,'2020-12-17 09:15:04','2021-12-27 17:12:45',7,7,10,8,'accept'),(10,13,'2022-02-03 19:56:17','2022-06-11 01:36:40',8,10,8,9,'accept'),
(7,14,'2020-11-28 17:50:32','2022-12-23 10:56:42',9,9,7,9,'accept'),(8,14,'2020-11-15 03:56:16','2021-12-22 16:52:44',8,9,8,10,'accept'),(9,14,'2022-02-06 13:07:11','2022-02-11 07:10:17',7,8,10,8,'accept');


-- accepted manuscripts to be typeset -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor) VALUES 
('non, vestibulum nec, euismod in, dolor. Fusce feugiat',5,'Stuart Ortega',44,'accepted','2022-09-29 07:04:15',3),
('risus. Nunc ac sem ut dolor',5,'Charde Carlson, Odysseus Hutchinson, Bianca Conway',44,'accepted','2021-10-27 14:31:28',1);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,15,'2020-02-17 11:24:20','2021-04-05 05:53:18',7,8,10,9,'accept'),(9,15,'2020-12-31 15:06:08','2021-02-28 06:57:38',7,10,10,8,'accept'),(10,15,'2020-12-01 11:49:57','2022-09-29 07:04:15',10,9,7,9,'accept'),
(7,16,'2020-11-03 11:31:53','2021-10-18 18:28:41',9,10,8,8,'accept'),(9,16,'2020-11-20 07:08:34','2021-05-23 08:57:50',7,8,8,8,'accept'),(10,16,'2021-02-04 14:13:43','2021-10-27 14:31:28',8,7,8,8,'accept');


-- reviewed manuscripts rejected -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor) VALUES 
('massa non',5,'Stuart Ortega',44,'rejected','2023-04-10 19:45:26',1),
('imperdiet non, vestibulum nec, euismod in, dolor.',4,null,81,'rejected','2022-09-09 15:42:27',3);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp, SubmittedTimestamp, AScore, CScore, MScore, EScore, Recommendation) VALUES
(7,17,'2020-03-04 19:26:41','2021-05-08 09:14:33',3,1,5,2,'reject'),(9,17,'2021-04-13 19:24:36','2021-06-21 04:44:04',5,4,3,1,'reject'),(10,17,'2021-07-06 07:31:27','2023-04-10 19:45:26',6,1,4,2,'reject'),
(7,18,'2020-03-16 04:37:21','2021-08-26 04:17:49',3,4,6,2,'reject'),(8,18,'2021-04-07 01:56:12','2021-10-21 20:20:54',3,2,3,2,'reject'),(10,18,'2021-07-24 20:51:10','2022-09-09 15:42:27',4,2,5,4,'reject');


-- manuscripts under review -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor) VALUES 
('Quisque nonummy',5,'Odysseus Hutchinson',81,'under review','2023-05-01 05:20:15',2),
('Nam ligula elit, pretium et, rutrum',5,'Amal Vargas, Eagan Zamora',44,'under review','2022-05-02 12:05:50',1);

INSERT INTO Review (Reviewer_Users_idReviewer, Manuscript_idManuscript, AssignedTimestamp) VALUES
(7,19,'2023-05-01 05:20:15'),(8,19,'2023-05-01 05:20:15'),(10,19,'2023-05-01 05:20:15'),
(7,20,'2022-05-02 12:05:50'),(9,20,'2022-05-02 12:05:50'),(10,20,'2022-05-02 12:05:50');


-- auto-rejected manuscripts (ICode does not have enough Reviewers, ICode outside Scope) -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, ManStatus, StatusTimestamp, Editor_Users_idEditor) VALUES 
('risus. Nunc ac sem ut dolor dapibus gravida',5,'Eagan Zamora, Charde Carlson, Bianca Conway, Noelle Beach, Amal Vargas',23,'rejected','2023-01-01 00:56:19',1),
('amet diam eu dolor egestas rhoncus. Proin nisl sem,',6,'Dalton Combs, Price Lopez',125,'rejected','2022-11-17 05:50:31',2);


-- manuscripts to be assigned -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('Phasellus elit pede, malesuada vel',4,'Francesca Mathews, Jamalia Ratliff',50,3),
('ligula tortor, dictum eu, placerat',6,'Adria Garrison',81,null);


-- manuscripts to be auto-rejected (ICode does not have enough Reviewers, ICode outside Scope) -- 

INSERT INTO Manuscript (Title, Author_Users_idAuthor, CoAuthors, ICode_ICode, Editor_Users_idEditor) VALUES 
('quis urna. Nunc quis arcu vel quam dignissim pharetra.',5,'Charde Carlson, Noelle Beach',53,2),
('augue ut lacus. Nulla tincidunt, neque',5,'Bianca Conway',125,1);