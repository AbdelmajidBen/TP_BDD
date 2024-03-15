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
