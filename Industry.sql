--Create database

CREATE DATABASE INDUSTRY

--2. Create a table called Director with following columns: FirstName, LastName, Nationality and Birthdate. Insert 5 rows into it.
CREATE TABLE Director (

ID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Nationality VARCHAR(20),
Birthdate DATETIME

);

INSERT INTO Director VALUES ('Andrei','Popescu','Romanian','2008-11-11');

INSERT INTO Director VALUES ('Maria','Ionescu','Romanian','2003-03-04');
																	   
INSERT INTO Director VALUES ('Ioana','Dumitru','Romanian','2005-04-10');
																	   
INSERT INTO Director VALUES ('Mircea','Sandu','Romanian','1992-06-05') ;
																	   
INSERT INTO Director VALUES ('Iulian','Pop','Romanian','1975-04-17')   ;
																	   
--3. Delete the director with id = 3

DELETE FROM Director WHERE ID=3 ;

--4. Create a table called Movie with following columns: DirectorId, Title, ReleaseDate, Rating and Duration. Each movie has a director. Insert some rows into it

CREATE TABLE Movie (

ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
DirectorID INT CONSTRAINT fk_DirectorID REFERENCES Director(ID),
Title VARCHAR(100) NOT NULL,
ReleaseDate DATETIME,
Rating INT CHECK (Rating>=0 AND Rating<=10),
DURATION DECIMAL(9,3)

);

INSERT INTO Movie(DirectorID, Title, ReleaseDate, Rating, Duration) VALUES (1,'Godzilla','2014-02-04',7,122);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (2,'Avatar','2013-04-13',9,160);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (4,'Fast & Furios','2010-03-15',5,110);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (2,'Taken','2015-10-27',6,96);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (2,'Godzilla 2','2019-02-04',7,112);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (5,'Avatar 2','2016-04-13',4,140);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (4,'Fast & Furios 2','2015-03-15',10,123);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (4,'Taken 2','2016-04-20',9,90);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (2,'Fast & Furios 3','2019-05-15',10,100);
INSERT INTO Movie(DirectorId, Title, ReleaseDate, Rating, Duration) VALUES (5,'Taken 3','2019-12-27',9,95);

SELECT * FROM Movie



--5. Update all movies that have a rating lower than 10.
UPDATE Movie SET Title='Updated' WHERE Rating<10;
SELECT * FROM Movie;

--6. Create a table called Actor with following columns: FirstName, LastName, Nationality, Birth date and PopularityRating. Insert some rows into it.
CREATE TABLE Actor(

ID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Nationality VARCHAR(30),
BirthDate DATETIME,
Popularity INT CHECK (Popularity>=0 AND Popularity<=10)

);


INSERT INTO Actor VALUES('Brad','Pitt','American','1963-02-06',8.0);
INSERT INTO Actor VALUES('Tom','Cruise','American','1965-04-02',8);
INSERT INTO Actor VALUES('Angelina','Jolie','American','1968-11-23',10);
INSERT INTO Actor VALUES('Jason','Statham','British','1967-07-24',9);
INSERT INTO Actor VALUES('Angel','Paul','American','1982-11-21',10);
INSERT INTO Actor VALUES('Andrew','Bond','British','1967-07-24',7);

SELECT * FROM Actor;

--7. Which is the movie with the lowest rating?

SELECT Title,Rating FROM Movie WHERE Rating=(SELECT MIN(Rating) FROM Movie);


--8. Which director has the most movies directed?

SELECT DirectorId, COUNT(Id) AS TotalMovies FROM Movie
GROUP BY DirectorID
ORDER BY TotalMovies


--9. Display all movies ordered by director's LastName in ascending order, then by birth date descending.

SELECT * FROM Movie m INNER JOIN Director D ON m.DirectorID=d.ID
ORDER BY d.LastName,d.Birthdate DESC

--12. Create a stored procedure that will increment the rating by 1 for a given movie id.

CREATE PROCEDURE [dbo.NameProcedure]
@Title VARCHAR
AS
BEGIN TRANSACTION
UPDATE Movie SET Title='God' WHERE Title=@Title

COMMIT TRANSACTION

EXEC [dbo.NameProcedure] @Title='Godzilla';
SELECT * FROM Movie WHERE Title='Godzilla';





--15. Implement many to many relationship between Movie and Actor

CREATE TABLE MovieActor(

MovieId INT CONSTRAINT fk_movie REFERENCES Movie(Id),
ActorId INT CONSTRAINT fk_actor REFERENCES Actor(Id) 

);

INSERT INTO MovieActor(MovieId,ActorId) VALUES(1,5)
SELECT * FROM MovieActor



--16. Implement many to many relationship between Movie and Genre

CREATE TABLE Genre(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(MAX) NOT NULL
);

CREATE TABLE MovieGenre(
	MovieId int CONSTRAINT fk_movieId REFERENCES Movie(Id),
	GenreId int CONSTRAINT fk_genreId REFERENCES Genre(Id)
);

INSERT INTO Genre(Name) VALUES('Drama');
INSERT INTO Genre(Name) VALUES('Thriller');
SELECT * FROM Genre;

INSERT INTO MovieGenre(MovieId,GenreId) VALUES(2,1);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(5,2);
INSERT INTO MovieGenre(MovieId,GenreId) VALUES(1,2);

--17. Which actor has worked with the most distinct movie directors?
SELECT A.Id, COUNT(d.Id) AS NoOfDirs
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId 
INNER JOIN Movie m ON ma.MovieId =m.Id 
INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY A.Id
HAVING COUNT(d.Id) >= (SELECT COUNT(d.Id) AS NoOfDirs
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId 
INNER JOIN Movie m ON ma.MovieId =m.Id 
INNER JOIN Director d ON m.DirectorId=d.Id
GROUP BY A.Id)

--18. Which is the preferred genre of each actor?
SELECT A.FirstName, A.LastName,g.Name
FROM Actor A INNER JOIN MovieActor ma ON A.Id=ma.ActorId 
INNER JOIN Movie m ON ma.MovieId =m.Id 
INNER JOIN MovieGenre mg ON m.Id=mg.MovieId 
INNER JOIN Genre g ON mg.GenreId=g.Id

