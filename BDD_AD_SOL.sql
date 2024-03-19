-- Exercice Number 1 ;

CREATE PROCEDURE dbo.Ex1_Done
(
    @nombre INT
)
AS
BEGIN

    CREATE TABLE #Resultats
    (
        Entier INT,
        ChiffresPairs INT,
        ChiffresImpairs INT
    );

    DECLARE @i INT = 1;

    WHILE @i < @nombre
    BEGIN
        DECLARE @chaine VARCHAR(10) = CAST(@i AS VARCHAR(10));
        DECLARE @longueur INT = LEN(@chaine);
        DECLARE @j INT = 1;
        DECLARE @somme INT = 0;
        DECLARE @pairs INT = 0;
        DECLARE @impairs INT = 0;
        WHILE @j <= @longueur
        BEGIN
            DECLARE @chiffre INT = CAST(SUBSTRING(@chaine, @j, 1) AS INT);
            SET @somme = @somme + @chiffre;

            IF @chiffre % 2 = 0
                SET @pairs = @pairs + 1;
            ELSE
                SET @impairs = @impairs + 1;

            SET @j = @j + 1;
        END
        IF @somme = 6
            INSERT INTO #Resultats (Entier, ChiffresPairs, ChiffresImpairs)
            VALUES (@i, @pairs, @impairs);

        SET @i = @i + 1;
    END
    SELECT * FROM #Resultats;
    DROP TABLE #Resultats;
END
GO

EXEC Ex1_Done @nombre = 100;
GO

--Ex 2

CREATE FUNCTION Ex2
(
    @input INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @binaryString NVARCHAR(MAX) = '';
    DECLARE @remainder INT;
    
    IF @input = 0
        RETURN '0';
    
    WHILE @input > 0
    BEGIN
        SET @remainder = @input % 2;
        SET @binaryString = CONVERT(NVARCHAR(1), @remainder) + @binaryString;
        SET @input = @input / 2;
    END

    RETURN @binaryString;
END
GO

SELECT dbo.Ex2(122) AS Ex2;

-- EX3
GO
CREATE FUNCTION IsPalindrome(@str VARCHAR(255)) RETURNS BIT
AS
BEGIN
    DECLARE @len INT;
    DECLARE @i INT;
    DECLARE @isPal BIT;

    SET @len = LEN(@str);
    SET @i = 1;
    SET @isPal = 1;

    WHILE @i <= @len / 2
    BEGIN
        IF SUBSTRING(@str, @i, 1) != SUBSTRING(@str, @len - @i + 1, 1)
        BEGIN
            SET @isPal = 0;
            BREAK;
        END;

        SET @i = @i + 1;
    END;

    RETURN @isPal;
END;
GO
SELECT dbo.IsPalindrome('TOTOT');

--EX 4 
GO 
CREATE FUNCTION CompterMots(@chaine VARCHAR(MAX)) RETURNS INT
AS
BEGIN
    DECLARE @nombreMots INT = 0;
    DECLARE @position INT = 1;
    DECLARE @longueur INT = LEN(@chaine);
    DECLARE @caracterePrecedent CHAR(1);

    WHILE @position <= @longueur
    BEGIN
        IF @caracterePrecedent IS NULL OR @caracterePrecedent IN (' ', CHAR(9), CHAR(10), CHAR(13))
        BEGIN
            IF SUBSTRING(@chaine, @position, 1) NOT IN (' ', CHAR(9), CHAR(10), CHAR(13))
            BEGIN
                SET @nombreMots = @nombreMots + 1;
            END;
        END;
        
        SET @caracterePrecedent = SUBSTRING(@chaine, @position, 1);
        SET @position = @position + 1;
    END;

    RETURN @nombreMots;
END;
GO 
SELECT dbo.CompterMots('Master intelligence artificielle et data science');

--EX 5 
GO
CREATE FUNCTION CompterOccurences(@chaine VARCHAR(MAX), @motCherche VARCHAR(MAX)) RETURNS INT
AS
BEGIN
    DECLARE @index INT = 1;
    DECLARE @count INT = 0;
    DECLARE @lenChaine INT = LEN(@chaine);
    DECLARE @lenMot INT = LEN(@motCherche);

    WHILE @index <= @lenChaine - @lenMot + 1
    BEGIN
        IF SUBSTRING(@chaine, @index, @lenMot) = @motCherche
        BEGIN
            SET @count = @count + 1;
            SET @index = @index + @lenMot - 1;
        END;
        SET @index = @index + 1;
    END;

    RETURN @count;
END;
GO
SELECT dbo.CompterOccurences('abdelmajidabd', 'abd');
--Ex 6
GO 
CREATE FUNCTION FindLongestWord(@inputString VARCHAR(MAX)) RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @longestWord VARCHAR(MAX) = '';
    DECLARE @words TABLE (word VARCHAR(MAX));

    INSERT INTO @words (word)
    SELECT value
    FROM STRING_SPLIT(@inputString, ' ');

    SELECT TOP 1 @longestWord = word
    FROM @words
    ORDER BY LEN(word) DESC;

    RETURN @longestWord;
END;
GO 
SELECT dbo.FindLongestWord('Master Artificial intellignce and data science');
GO

--EX 7
GO
CREATE PROCEDURE DisplayMinutesX
    @minutes INT
AS
BEGIN
    DECLARE @years INT, @months INT, @days INT, @hours INT;

    SET @years = @minutes / (60 * 24 * 365);
    SET @minutes = @minutes % (60 * 24 * 365);

    SET @months = @minutes / (60 * 24 * 30);
    SET @minutes = @minutes % (60 * 24 * 30);

    SET @days = @minutes / (60 * 24);
    SET @minutes = @minutes % (60 * 24);

    SET @hours = @minutes / 60;
    SET @minutes = @minutes % 60;

    PRINT CAST(@years AS VARCHAR(5)) + ' Années ' + 
          CAST(@months AS VARCHAR(5)) + ' Mois ' + 
          CAST(@days AS VARCHAR(5)) + ' Jours ' + 
          CAST(@hours AS VARCHAR(5)) + ' Heures ' + 
          CAST(@minutes AS VARCHAR(5)) + ' Minutes';
END;
EXEC DisplayMinutesX @minutes = 2000000;

--Ex 8
GO
CREATE PROCEDURE CreateVolsTable
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('Vols', 'U') IS NOT NULL
    BEGIN
        PRINT 'The Vols table already exists.';
        RETURN;
    END

    CREATE TABLE Vols (
        Num_Vol INT PRIMARY KEY,
        Date_Depart DATE,
        Heure_Depart TIME,
        Ville_Depart VARCHAR(100),
        Ville_Arrivee VARCHAR(100),
        Code_Avion INT,
        Code_Pilote INT,
        Prix_Vol DECIMAL(10, 2),
        CONSTRAINT FK_Avion FOREIGN KEY (Code_Avion) REFERENCES Avions(Num_Avion),
        CONSTRAINT FK_Pilote FOREIGN KEY (Code_Pilote) REFERENCES Pilotes(Num_Pilote)
    );

    PRINT 'The Vols table has been created successfully.';
END;
GO 
--Ex 9 

GO
CREATE PROCEDURE DisplayNonValidatedReservations
    @targetDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Reservations
    WHERE Date_Validation IS NULL
    AND Date_Reservation = @targetDate;
END;
EXEC DisplayNonValidatedReservations @targetDate = '2024-03-15';

--EX 10
GO
CREATE PROCEDURE DisplayFlightInformation
    @flightNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Vols
    WHERE Num_Vol = @flightNumber;
END;
GO
EXEC DisplayFlightInformation @flightNumber = 123;



--ex 11
GO
CREATE PROCEDURE DisplayFlightInformation
    @flightNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT V.Num_Vol, 
           V.Date_Depart, 
           V.Heure_Depart, 
           V.Ville_Depart, 
           V.Ville_Arrivee,
           PD.Nom_Pilote AS Nom_Pilote_Depart,
           PD.Prenom_Pilote AS Prenom_Pilote_Depart,
           PA.Nom_Pilote AS Nom_Pilote_Arrivee,
           PA.Prenom_Pilote AS Prenom_Pilote_Arrivee,
           E.Ville AS Ville_Escale,
           E.Heure_Arrivee AS Heure_Arrivee_Escale,
           E.Duree_Escale
    FROM Vols V
    LEFT JOIN Pilotes PD ON V.Code_Pilote = PD.Num_Pilote
    LEFT JOIN Pilotes PA ON V.Code_Pilote = PA.Num_Pilote
    LEFT JOIN Escales E ON V.Num_Vol = E.Num_Vol
    WHERE V.Num_Vol = @flightNumber;
END;
GO
EXEC DisplayFlightInformation @flightNumber = 123;

-- ex 12
GO
CREATE PROCEDURE DisplayValidatedReservation
    @reservationNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT R.Num_Reservation, 
           R.Date_Reservation, 
           R.Date_Validation, 
           R.Etat_Reservation,
           P.Code_Passager,
           P.Nom_Passager,
           P.Pre_Passager,
           P.Num_Passport,
           P.Categorie,
           P.Num_Tel
    FROM Reservations R
    INNER JOIN Passagers P ON R.Code_Passager = P.Code_Passager
    WHERE R.Num_Reservation = @reservationNumber
          AND R.Date_Validation IS NOT NULL;
END;

EXEC DisplayValidatedReservation @reservationNumber = 123;

--Ex 13
GO
CREATE PROCEDURE DisplayNumberOfFlightsPerAirplane
AS
BEGIN
    SET NOCOUNT ON;

    SELECT V.Code_Avion, COUNT(*) AS NumberOfFlights
    FROM Vols V
    GROUP BY V.Code_Avion
    ORDER BY NumberOfFlights DESC;
END;
EXEC DisplayNumberOfFlightsPerAirplane;

--ex 14
GO
CREATE FUNCTION CalculateNumberOfTripsForPassenger1
(
    @passengerCode INT
)
RETURNS INT
AS
BEGIN
    DECLARE @numberOfTrips INT;

    SELECT @numberOfTrips = COUNT(*)
    FROM voyages 
    WHERE Code_Passager = @passengerCode;

    RETURN @numberOfTrips;
END;

GO
DECLARE @passengerCode INT = 123; 

SELECT dbo.CalculateNumberOfTripsForPassenger1(@passengerCode) AS NumberOfTrips;




--ex 15
GO
CREATE FUNCTION CalculateFlightCost1
(
    @flightNumber INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @cost DECIMAL(10, 2);

    -- Calculate cost based on airplane
    DECLARE @airplaneCost DECIMAL(10, 2);
    SELECT @airplaneCost = AVG(Prix_Vol) FROM Vols WHERE Num_Vol = @flightNumber;
    RETURN @airplaneCost;
END;

GO
DECLARE @flightNumber INT = 1; 
DECLARE @flightCost DECIMAL(10, 2);

SELECT @flightCost = dbo.CalculateFlightCost1(@flightNumber);

PRINT 'The estimated cost of flight ' + CAST(@flightNumber AS VARCHAR(10)) + ' is $' + CAST(@flightCost AS VARCHAR(20));

--ex 16
GO
CREATE PROCEDURE DeleteUnvalidatedReservations
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete unvalidated reservations
    DELETE FROM Reservations
    WHERE Etat_Reservation <> 'Validated';
END;

EXEC DeleteUnvalidatedReservations;

--ex 17
GO
CREATE PROCEDURE InsertVoyageRecord
    @Code_Passager INT,
    @Num_Billet INT,
    @Num_Vol INT,
    @Num_Place INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Voyages WHERE Code_Passager = @Code_Passager AND Num_Billet = @Num_Billet AND Num_Vol = @Num_Vol)
    BEGIN
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Billets WHERE Num_Billet = @Num_Billet AND Code_Passager = @Code_Passager AND EXISTS (SELECT 1 FROM Ligne_Reservation WHERE Num_Billet = @Num_Billet AND Num_Vol = @Num_Vol))
    BEGIN
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM Voyages WHERE Num_Place = @Num_Place)
    BEGIN
        RETURN;
    END;

    INSERT INTO Voyages (Code_Passager, Num_Billet, Num_Vol, Num_Place)
    VALUES (@Code_Passager, @Num_Billet, @Num_Vol, @Num_Place);
END;
EXEC InsertVoyageRecord @Code_Passager = 1, @Num_Billet = 1, @Num_Vol = 1, @Num_Place = 1;


--ex 18
GO
CREATE PROCEDURE InsertLigneReservationRecord
    @Num_Ligne INT OUTPUT,
    @Num_Order INT,
    @Num_Vol INT,
    @Num_Reservation INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Ligne_Reservation WHERE Num_Ligne = @Num_Ligne)
    BEGIN
        RETURN;
    END;

    IF @Num_Order <> (SELECT ISNULL(MAX(Num_Order), 0) + 1 FROM Ligne_Reservation WHERE Num_Reservation = @Num_Reservation)
    BEGIN
        RETURN;
    END;

    IF (SELECT COUNT(*) FROM Ligne_Reservation WHERE Num_Reservation = @Num_Reservation) > 0
    BEGIN
        DECLARE @PreviousArrivalCity VARCHAR(50);
        SELECT @PreviousArrivalCity = V.Ville_Arrivee
        FROM Vols V
        JOIN Ligne_Reservation LR ON V.Num_Vol = LR.Num_Vol
        WHERE LR.Num_Reservation = @Num_Reservation
        ORDER BY LR.Num_Order DESC;

        DECLARE @NewDepartureCity VARCHAR(50);
        SELECT @NewDepartureCity = Ville_Depart
        FROM Vols
        WHERE Num_Vol = @Num_Vol;

        IF @PreviousArrivalCity <> @NewDepartureCity
        BEGIN
            RETURN;
        END;
    END;

    DECLARE @AvailableSeats INT;
    SELECT @AvailableSeats = A.Nbr_Place - ISNULL(COUNT(*), 0)
    FROM Voyages V
    JOIN Vols VL ON V.Num_Vol = VL.Num_Vol
    JOIN Avions A ON VL.Code_Avion = A.Num_Avion
    WHERE VL.Num_Vol = @Num_Vol
    GROUP BY A.Nbr_Place;

    IF @AvailableSeats <= 0
    BEGIN
        RETURN;
    END;

    INSERT INTO Ligne_Reservation (Num_Order, Num_Vol, Num_Reservation)
    VALUES (@Num_Order, @Num_Vol, @Num_Reservation);

    SELECT @Num_Ligne = SCOPE_IDENTITY();
END;

DECLARE @Num_LigneResult INT;
EXEC InsertLigneReservationRecord @Num_Ligne = @Num_LigneResult OUTPUT, @Num_Order = 1, @Num_Vol = 1, @Num_Reservation = 1;
-- ex 19
GO
CREATE PROCEDURE AddColumnsToVols
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SqlStatement NVARCHAR(MAX);
    SET @SqlStatement = '
        ALTER TABLE Vols
        ADD Nbr_Res INT DEFAULT 0,
            Nbr_Att INT DEFAULT 0;
    ';

    EXEC sp_executesql @SqlStatement;
END;
EXEC AddColumnsToVols;

--ex 20
GO
CREATE PROCEDURE UpdateSeatsCountForFlight
    @Num_Vol INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Vols
    SET Nbr_Res = (SELECT COUNT(*) FROM Ligne_Reservation WHERE Num_Vol = @Num_Vol),
        Nbr_Att = (SELECT COUNT(*) FROM Voyages WHERE Num_Vol = @Num_Vol);

END;

EXEC UpdateSeatsCountForFlight @Num_Vol = 123; 


--ex 21

GO
CREATE PROCEDURE CalculatePassengerCategory
    @Code_Passager INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Category VARCHAR(20);

    SELECT @Category = 
        CASE
            WHEN (SELECT COUNT(*) FROM Voyages WHERE Code_Passager = @Code_Passager) > 20 
                 AND (SELECT SUM(Prix_Total) FROM Reservations WHERE Code_Passager = @Code_Passager) > 200000 
                 THEN 'Très Actif'
            WHEN (SELECT COUNT(*) FROM Voyages WHERE Code_Passager = @Code_Passager) > 20 
                 THEN 'Actif'
            ELSE 'Moyen'
        END;

    UPDATE Passagers
    SET Categorie = @Category
    WHERE Code_Passager = @Code_Passager;
    
END;

EXEC CalculatePassengerCategory @Code_Passager = 123; -- Replace 123 with the desired passenger code

--ex 22
GO
CREATE PROCEDURE CalculateNumberOfTripsPerPassenger
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Code_Passager, COUNT(*) AS NumberOfTrips
    FROM Voyages
    GROUP BY Code_Passager;
END;

EXEC CalculateNumberOfTripsPerPassenger;

--ex 23
GO
CREATE PROCEDURE CalculateCostOfFlights
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Vols
    SET Cost = (SELECT SUM(Prix_Vol) FROM Vols AS v WHERE v.Num_Vol = Vols.Num_Vol);
END;

EXEC CalculateCostOfFlights;

--ex 25
GO
CREATE PROCEDURE GetPilotsExceedingPercentage
    @Percentage DECIMAL(5, 2)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT P.Num_Pilote, P.Nom_Pilote, P.Prenom_Pilote
    FROM Pilotes P
    INNER JOIN (
        SELECT Code_Pilote, COUNT(*) AS Num_Avions
        FROM Vols
        GROUP BY Code_Pilote
    ) AS A ON P.Num_Pilote = A.Code_Pilote
    CROSS JOIN (
        SELECT COUNT(*) AS Total_Avions
        FROM Avions
    ) AS T
    WHERE (CONVERT(DECIMAL(5, 2), A.Num_Avions) / CONVERT(DECIMAL(5, 2), T.Total_Avions)) > @Percentage / 100;
END;

EXEC GetPilotsExceedingPercentage @Percentage = 20;

--ex 26
GO
CREATE PROCEDURE AddInitializePilotColumns
AS
BEGIN
    SET NOCOUNT ON;

    -- Add new columns
    ALTER TABLE Pilotes
    ADD NbrAvions INT,
        NbrVoyages INT,
        Statut VARCHAR(20);

    -- Initialize NbrVoyages
    UPDATE Pilotes
    SET NbrVoyages = (SELECT COUNT(*) FROM Voyages WHERE Voyages.Code_Pilote = Pilotes.Num_Pilote);

    -- Initialize NbrAvions
    UPDATE Pilotes
    SET NbrAvions = (SELECT COUNT(*) FROM Vols WHERE Vols.Code_Pilote = Pilotes.Num_Pilote);

    -- Initialize Statut
    UPDATE Pilotes
    SET Statut = 
        CASE 
            WHEN NbrAvions > 0 AND (NbrAvions / (SELECT COUNT(*) FROM Avions) * 100) > 50 THEN 'Expert'
            WHEN NbrAvions > 0 AND (NbrAvions / (SELECT COUNT(*) FROM Avions) * 100) <= 50 AND (NbrAvions / (SELECT COUNT(*) FROM Avions) * 100) >= 5 THEN 'Qualifie'
            ELSE 'Débiteur'
        END;
END;


EXEC AddInitializePilotColumns;


--ex 27
GO
CREATE PROCEDURE GetAvailableTickets
    @DepartureCity VARCHAR(100),
    @ArrivalCity VARCHAR(100),
    @NumStops INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT B.Num_Billet, B.Num_Reservation, R.Prix_Total
    FROM Billets B
    INNER JOIN Reservations R ON B.Num_Reservation = R.Num_Reservation
    INNER JOIN Ligne_Reservation LR ON R.Num_Reservation = LR.Num_Reservation
    INNER JOIN Vols V ON LR.Num_Vol = V.Num_Vol
    WHERE V.Ville_Depart = @DepartureCity
        AND V.Ville_Arrivee = @ArrivalCity
        AND V.NumStops = @NumStops
    ORDER BY R.Prix_Total DESC;
END;
EXEC GetAvailableTickets @DepartureCity = 'Tanger', @ArrivalCity = 'Oujda', @NumStops = 1; 

--ex 28

GO
CREATE TRIGGER CheckSeatAvailability
ON Voyages
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NumVol INT, @CodePassager INT, @NumPlace INT;

    SELECT @NumVol = Num_Vol, @CodePassager = Code_Passager, @NumPlace = Num_place
    FROM inserted;

    IF NOT (dbo.Complet(@NumVol) = 1 AND dbo.Occuper(@NumVol, @NumPlace) = 0)
    BEGIN
        DECLARE @NewPlace INT;
        SET @NewPlace = dbo.GetAvailableSeat(@NumVol);
        
        PRINT 'Seat ' + CAST(@NumPlace AS VARCHAR) + ' is occupied. Suggested seat: ' + CAST(@NewPlace AS VARCHAR);
    END;
END;


--ex 29

GO
CREATE TRIGGER UpperCasePassengerNames
ON Passagers
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Temporary table to hold uppercase values
    CREATE TABLE #TempPassengers (
        Code_Passager INT PRIMARY KEY,
        Nom_Passager NVARCHAR(50),
        Pre_Passager NVARCHAR(50),
        Num_Passport NVARCHAR(50),
        Categorie NVARCHAR(50),
        Num_Tel NVARCHAR(50)
    );

    -- Insert uppercase values into the temporary table
    INSERT INTO #TempPassengers (Code_Passager, Nom_Passager, Pre_Passager, Num_Passport, Categorie, Num_Tel)
    SELECT Code_Passager, UPPER(Nom_Passager), UPPER(Pre_Passager), Num_Passport, Categorie, Num_Tel
    FROM inserted;

    -- Check uniqueness of key
    IF NOT EXISTS (
        SELECT 1
        FROM Passagers p
        INNER JOIN #TempPassengers t ON p.Code_Passager = t.Code_Passager
    )
    BEGIN
        -- Insert into Passagers table from temporary table
        INSERT INTO Passagers (Code_Passager, Nom_Passager, Pre_Passager, Num_Passport, Categorie, Num_Tel)
        SELECT Code_Passager, Nom_Passager, Pre_Passager, Num_Passport, Categorie, Num_Tel
        FROM #TempPassengers;
    END
    ELSE
    BEGIN
        PRINT 'Error: Duplicate key detected. Insertion aborted.';
    END;

    DROP TABLE #TempPassengers;
END;
--ex 30

GO 
CREATE TRIGGER ControlInsertVoyage
ON Voyages
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Vol INT, @Code_Passager INT, @Num_Billet INT;

    SELECT @Num_Vol = Num_Vol, @Code_Passager = Code_Passager, @Num_Billet = Num_Billet
    FROM inserted;

    -- Check if the flight exists in the flights table
    IF NOT EXISTS (SELECT 1 FROM Vols WHERE Num_Vol = @Num_Vol)
    BEGIN
        PRINT 'Error: The flight does not exist. Insertion aborted.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Check if the passenger has the reserved ticket
    IF NOT EXISTS (SELECT 1 FROM Billets WHERE Num_Billet = @Num_Billet AND Code_Passager = @Code_Passager)
    BEGIN
        PRINT 'Error: The passenger does not have the reserved ticket. Insertion aborted.';
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Insertion successful
    PRINT 'Voyage inserted successfully.';
END;


--ex31
GO
CREATE TRIGGER UpdatePilotStatsOnVoyageInsert
ON Voyages
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Pilote INT;

    SELECT @Num_Pilote = v.Code_Pilote
    FROM inserted v;
    UPDATE Pilotes
    SET 
        Statut = CASE 
                    WHEN NbrAvions > 0 AND NbrVoyages > 0 THEN 'Expert'
                    WHEN NbrAvions BETWEEN 0.5 * (SELECT COUNT(*) FROM Avions) AND 0.05 * (SELECT COUNT(*) FROM Avions) THEN 'Qualifie'
                    ELSE 'Debiteur'
                END,
        NbrAvions = (SELECT COUNT(DISTINCT v.Code_Avion) FROM Voyages v WHERE v.Code_Pilote = @Num_Pilote),
        NbrVoyages = (SELECT COUNT(*) FROM Voyages WHERE Code_Pilote = @Num_Pilote)
    WHERE Num_Pilote = @Num_Pilote;
END;


--Ex 32
GO
CREATE TRIGGER CheckSeatCapacityOnVoyageInsert
ON Voyages
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Vol INT, @Num_Avion INT, @Num_Place INT, @Capacity INT;

    SELECT @Num_Vol = Num_Vol, @Num_Avion = Code_Avion, @Num_Place = Num_Place
    FROM inserted;
    SELECT @Capacity = Nbr_Place
    FROM Avions
    WHERE Num_Avion = @Num_Avion;
    IF @Num_Place > @Capacity
    BEGIN
        RAISEERROR('Error: Number of allocated seats exceeds the capacity of the airplane.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
--ex 33
GO
CREATE TRIGGER UpdatePilotStatsOnVoyageInsert
ON Voyages
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Num_Pilote INT, @NbrVoyages INT, @NbrAvions INT, @Statut VARCHAR(20);

    SELECT TOP 1 @Num_Pilote = Code_Pilote
    FROM inserted;

    -- Calculate the number of flights for the pilot
    SELECT @NbrVoyages = COUNT(*)
    FROM Voyages
    WHERE Code_Pilote = @Num_Pilote;

    -- Calculate the number of airplanes for the pilot
    SELECT @NbrAvions = COUNT(DISTINCT Code_Avion)
    FROM Voyages
    WHERE Code_Pilote = @Num_Pilote;

    -- Determine the status of the pilot
    IF @NbrAvions > 0
        SET @Statut = CASE
                        WHEN @NbrAvions > 0.5 * (SELECT COUNT(DISTINCT Num_Avion) FROM Avions) THEN 'Expert'
                        WHEN @NbrAvions BETWEEN 0.05 * (SELECT COUNT(DISTINCT Num_Avion) FROM Avions) AND 0.5 * (SELECT COUNT(DISTINCT Num_Avion) FROM Avions) THEN 'Qualifie'
                        ELSE 'Débiteur'
                      END;
    ELSE
        SET @Statut = 'Débiteur';

    -- Update the pilot stats
    UPDATE Pilotes
    SET NbrVoyages = @NbrVoyages,
        NbrAvions = @NbrAvions,
        Statut = @Statut
    WHERE Num_Pilote = @Num_Pilote;
END;

--ex34
GO
CREATE TRIGGER CascadeDeletePassenger
ON Passagers
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedPassenger INT;
    SELECT @DeletedPassenger = Code_Passager FROM deleted;

    -- Delete related records from Reservations table
    DELETE FROM Reservations WHERE Code_Passager = @DeletedPassenger;

    -- Delete related records from Ligne_Reservation table
    DELETE FROM Ligne_Reservation WHERE Num_Reservation IN (SELECT Num_Reservation FROM deleted);

    -- Delete related records from Billets table
    DELETE FROM Billets WHERE Num_Reservation IN (SELECT Num_Reservation FROM deleted);

    -- Delete related records from Voyages table
    DELETE FROM Voyages WHERE Code_Passager = @DeletedPassenger;

    -- Perform the actual deletion of the passenger
    DELETE FROM Passagers WHERE Code_Passager = @DeletedPassenger;
END;

--ex35
GO
CREATE TRIGGER CascadeDeletePassenger
ON Passagers
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedPassenger INT;
    SELECT @DeletedPassenger = Code_Passager FROM deleted;

    DELETE FROM Reservations WHERE Code_Passager = @DeletedPassenger;
    DELETE FROM Ligne_Reservation WHERE Num_Reservation IN (SELECT Num_Reservation FROM deleted);
    DELETE FROM Billets WHERE Num_Reservation IN (SELECT Num_Reservation FROM deleted);
    DELETE FROM Voyages WHERE Code_Passager = @DeletedPassenger;

    DELETE FROM Passagers WHERE Code_Passager = @DeletedPassenger;
END;
GO 
--Ex 36

CREATE TRIGGER CorrectPhoneNumber
ON Passagers
AFTER INSERT, UPDATE
AS
BEGIN

    UPDATE Passagers
    SET Num_Tel = REPLACE(REPLACE(Num_Tel, '-', '.'), 'O', '0')
    WHERE EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Code_Passager = Passagers.Code_Passager
    );
END;

--EX 37
GO

CREATE TRIGGER ValidateDateInput
ON Vols
AFTER INSERT, UPDATE
AS
BEGIN

    UPDATE Vols
    SET Date_Depart = REPLACE(REPLACE(Date_Depart, 'O', '0'), 'Q', '0'),
        Date_Arrivee = REPLACE(REPLACE(Date_Arrivee, 'O', '0'), 'Q', '0')
    WHERE (LEN(Date_Depart) <= 10 AND Date_Depart NOT LIKE '%[^0-9/]%' 
        AND CHARINDEX('/', REPLACE(REPLACE(Date_Depart, 'O', '0'), 'Q', '0')) <= 2)
        AND (LEN(Date_Arrivee) <= 10 AND Date_Arrivee NOT LIKE '%[^0-9/]%' 
        AND CHARINDEX('/', REPLACE(REPLACE(Date_Arrivee, 'O', '0'), 'Q', '0')) <= 2);
END;

--EX 38
GO
CREATE TABLE Voyages_Archive (
    Code_Passager INT,
    Num_Billet INT,
    Num_Vol INT,
    Num_Place INT,
    Date_Archive DATETIME
);
GO
CREATE TRIGGER ArchiveVoyagesDeletion
ON Voyages
AFTER DELETE
AS
BEGIN
    INSERT INTO Voyages_Archive (Code_Passager, Num_Billet, Num_Vol, Num_Place, Date_Archive)
    SELECT Code_Passager, Num_Billet, Num_Vol, Num_Place, GETDATE()
    FROM deleted;
END;

--EX 39
GO
CREATE TABLE Reservations_Archive (
    Num_Reservation INT,
    Date_Archive DATETIME,
    Action NVARCHAR(50)
);
GO
CREATE TRIGGER ArchiveReservationsDeletion
ON Reservations
AFTER DELETE
AS
BEGIN
    INSERT INTO Reservations_Archive (Num_Reservation, Date_Archive, Action)
    SELECT Num_Reservation, GETDATE(), 
           CASE 
                WHEN d.Etat_Reservation = 'Annulée' THEN 'Cancelled'
                WHEN d.Etat_Reservation = 'Validée' AND d.Date_Validation <= DATEADD(day, -10, GETDATE()) THEN 'Validated'
           END
    FROM deleted d;
END;

--EX 40
GO
CREATE VIEW ReservationValidees AS
SELECT idzone, type, caract, dist
FROM reservations
WHERE Code_Agence = '001' AND Etat_Reservation = 'Validée';

