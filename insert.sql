```

Journal ( idJournal )
Issue ( idIssue, Journal_idJournal, PublicationDate (nullable) )
ICode ( ICode, Interest )
Scope ( Journal_idJournal, ICode_ICode )
Users ( idUser, FName, LName )
Editor ( Users_idEditor )
Author ( Users_idAuthor, Email, Affiliation )
Reviewer ( Users_idReviewer, Email, Affiliation )
ReviewerGroup ( Reviewer_User_idReviewer, ICode_ICode )
Manuscript ( idManuscript, Title, Author_User_idAuthor, CoAuthors (nullable), ICode_ICode, Status, StatusTimestamp, Editor_User_idEditor (nullable), Issue_idIssue (nullable), NumPages (nullable), BeginningPage (nullable) )
Review ( Reviewer_User_idReviewer, Manuscript_idManuscript, Status, StatusTimestamp, AScore (nullable), CScore (nullable), MScore (nullable), EScore (nullable), Recommendation (nullable) )

```

INSERT INTO Journal () VALUES (null);

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
('Teletraffic engineering'),('Usability engineering'),('Web engineering'),('Systems engineering');

INSERT INTO Scope (Journal_idJournal, ICode_ICode) VALUES
(1, 1),(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7),(1, 8),(1, 9),(1, 10),(1, 11),(1, 12),(1, 13),(1, 14),(1, 15),(1, 16),
(1, 17),(1, 18),(1, 19),(1, 20),(1, 21),(1, 22),(1, 23),(1, 24),(1, 25),(1, 26),(1, 27),(1, 28),(1, 29),(1, 30),(1, 31),(1, 32),
(1, 33),(1, 34),(1, 35),(1, 36),(1, 37),(1, 38),(1, 39),(1, 40),(1, 41),(1, 42),(1, 43),(1, 44),(1, 45),(1, 46),(1, 47),(1, 48),
(1, 49),(1, 50),(1, 51),(1, 52),(1, 53),(1, 54),(1, 55),(1, 56),(1, 57),(1, 58),(1, 59),(1, 60),(1, 61),(1, 62),(1, 63),(1, 64),
(1, 65),(1, 66),(1, 67),(1, 68),(1, 69),(1, 70),(1, 71),(1, 72),(1, 73),(1, 74),(1, 75),(1, 76),(1, 77),(1, 78),(1, 79),(1, 80),
(1, 81),(1, 82),(1, 83),(1, 84),(1, 85),(1, 86),(1, 87),(1, 88),(1, 89),(1, 90),(1, 91),(1, 92),(1, 93),(1, 94),(1, 95),(1, 96),
(1, 97),(1, 98),(1, 99),(1, 100),(1, 101),(1, 102),(1, 103),(1, 104),(1, 105),(1, 106),(1, 107),(1, 108),(1, 109),(1, 110),(1, 111),(1, 112),
(1, 113),(1, 114),(1, 115),(1, 116),(1, 117),(1, 118),(1, 119),(1, 120),(1, 121),(1, 122),(1, 123),(1, 124);

INSERT INTO Users (FName, LName) VALUES
  ('Steven','Hart'),
  ('Barbara','Garrison'),
  ('Buffy','Schmidt'),
  ('Odysseus','Hutchinson'),
  ('Oscar','Newton')
  ('Amal','Vargas'),
  ('Zorita','Nguyen'),
  ('Naomi','Oneil'),
  ('Wyatt','Mann'),
  ('Roth','Stevens');

INSERT INTO Editor (Users_idEditor) VALUES
(1),(2),(3);

INSERT INTO Author (Users_idAuthor, Email, Affiliation) VALUES
(4, 'ody.hutch@dartmouth.edu', 'Dartmouth College'),
(5, 'osc.newto@dartmouth.edu', 'Dartmouth College'),
(6, 'avargas6@stanford.edu', 'Stanford University');

INSERT INTO Reviewer (Users_idReviewer, Email, Affiliation) VALUES
(7, 'zorita.nguyen@cornell.edu', 'Cornell University'),
(8, 'n.oneil@bostonu.edu', 'Boston University'),
(9, 'mannw@rpi.edu', 'Rensselaer Polytechnic Institute'),
(10, 'stevens.roth@mit.edu', 'Massachusetts Institute of Technology');