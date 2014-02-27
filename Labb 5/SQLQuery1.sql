/*
-- 2.a - 1
ALTER PROCEDURE usp_ArticleAdd
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(2,2),
@Plats char(10)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Artikel (Artnamn, Antal, Pris, Rabatt, Plats)
		VALUES (@Artnamn, @Antal, @Pris, @Rabatt, @Plats)
	END TRY
	BEGIN CATCH
		RAISERROR('Ett fel inträffade! Försök igen', 16, 1)
	END CATCH
END

EXEC usp_ArticleAdd 'USB-Minne', 30, 200.50, 0.00, 'Förråd 10'

-- 2.a - 2
ALTER PROCEDURE usp_ArticleUpdate
@ArtikelID int = 0,
@Artnamn varchar(30),
@Antal smallint,
@Pris decimal(6,2),
@Rabatt decimal(6,2),
@Plats char(10)
AS
BEGIN
	IF EXISTS(SELECT ArtikelID FROM Artikel WHERE ArtikelID = @ArtikelID)
		BEGIN
			BEGIN TRY
				UPDATE Artikel
				SET Artnamn = @Artnamn,
				Antal = @Antal,
				Pris = @Pris,
				Rabatt = @Rabatt,
				Plats = @Plats
				WHERE Artikel.ArtikelID = @ArtikelID
			END TRY
			BEGIN CATCH
				RAISERROR('Ett fel inträffade! Försök igen.', 16, 1)
			END CATCH
		END
	ELSE
		BEGIN
			RAISERROR('Det valda ArtikelID:t finns inte! Försök igen.', 16, 1)
		END
END

EXEC usp_ArticleUpdate 4, 'Hårddisk', 20, 130.79, 0.00, 'Förråd 10'

-- 2.a - 3
ALTER PROCEDURE usp_ArticleDelete
@ArtikelID int = 0
AS
BEGIN
	IF EXISTS(SELECT ArtikelID FROM Artikel WHERE ArtikelID = @ArtikelID)
		BEGIN
			DELETE Artikel
			WHERE Artikel.ArtikelID = @ArtikelID
		END
	ELSE
		BEGIN
			RAISERROR('Det valda ArtikelID:t finns inte! Försök igen.', 16, 1)
		END
END

EXEC usp_ArticleDelete 7

-- 2.b
ALTER PROCEDURE usp_ArticleList
@ArtikelID int = 0
AS
BEGIN
	IF EXISTS(SELECT ArtikelID FROM Artikel WHERE ArtikelID = @ArtikelID)
		BEGIN
			SELECT ArtikelID, Artnamn, Antal, Pris, (Antal*Pris) AS Lagervärde
			FROM Artikel
			WHERE ArtikelID = @ArtikelID
		END
	ELSE
		BEGIN
			IF (@ArtikelID = 0)
				SELECT ArtikelID, Artnamn, Antal, Pris, (Antal*Pris) AS Lagervärde
				FROM Artikel
				ORDER BY Artnamn ASC
			ELSE
				RAISERROR('Det valda ArtikelID:t finns inte! Försök igen.', 16, 1)
		END
END

EXEC usp_ArticleList

-- 2.c
ALTER PROCEDURE usp_TelephoneList
@KundID int = 0
AS
BEGIN
	CREATE TABLE #Temp
	(
		Namn varchar(40) NOT NULL,
		Ort varchar(25) NOT NULL,
		Telefon varchar(15) NOT NULL,
		Telefontyp varchar(10) NOT NULL
	)
	IF EXISTS(SELECT KundID FROM Kund WHERE KundID = @KundID)
		BEGIN
			INSERT INTO #Temp (Namn, Ort, Telefon, Telefontyp)
			SELECT k.Namn, k.Ort, t.Telenr, tt.Teltyp
			FROM Kund AS k INNER JOIN Telefon AS t ON k.KundID=t.KundID INNER JOIN Teltyp as tt ON t.TeltypID=tt.TelTypID
			WHERE k.KundID = @KundID
			ORDER BY tt.Teltyp ASC
		END
	ELSE
		BEGIN
			IF (@KundID = 0)
				INSERT INTO #Temp (Namn, Ort, Telefon, Telefontyp)
				SELECT k.Namn, k.Ort, t.Telenr, tt.Teltyp
				FROM Kund AS k INNER JOIN Telefon AS t ON k.KundID=t.KundID INNER JOIN Teltyp as tt ON t.TeltypID=tt.TelTypID
				ORDER BY k.Namn, tt.Teltyp ASC
			ELSE
				RAISERROR('Det valda KundID:t finns inte! Försök igen.', 16, 1)
		END
	SELECT * FROM #Temp
	DROP TABLE #Temp
END

EXEC usp_TelephoneList 1

-- 2.d
ALTER PROCEDURE usp_SalesList
@StartDate Date,
@EndDate Date
AS
BEGIN
	IF (@StartDate > @EndDate)
		RAISERROR('Startdatumet måste vara lägre än slutdatumet.', 16, 1)
	ELSE
		SELECT Fr.ArtikelID, Artnamn, Datum, Fr.Antal, Fr.Pris, Lagervärde
		FROM Faktura AS F
		INNER JOIN Fakturarad AS Fr ON F.FakturaID = Fr.FakturaID
		INNER JOIN Artikel AS A ON Fr.ArtikelID = A.ArtikelID
		WHERE Datum BETWEEN @StartDate AND @EndDate
		ORDER BY Artnamn ASC

END

EXEC usp_SalesList '2010-01-01', '2015-01-01'

-- 3.a
ALTER PROCEDURE usp_SaleStatistics
@FakturaID int = 0,
@ArtikelID int,
@Antal smallint,
@Rabatt decimal(2,2),
@MomsID int
AS
BEGIN
	IF EXISTS(SELECT ArtikelID FROM Artikel WHERE ArtikelID = @ArtikelID)
		BEGIN
			BEGIN TRY
				DECLARE @Pris decimal(6,2), @SetMsg varchar(40)
				SET @Pris = (SELECT Pris FROM Artikel WHERE ArtikelID = @ArtikelID);
				
				BEGIN TRAN
					
					SET @SetMsg = 'Det gick inte att skapa en ny fakturarad!'
					INSERT INTO Fakturarad (FakturaID, ArtikelID, Antal, Pris, Rabatt, MomsID)
					VALUES (@FakturaID, @ArtikelID, @Antal, @Pris, @Rabatt, @MomsID);
					
					SET @SetMsg = 'Uppdatering av artikel fungerar inte!'
					UPDATE Artikel SET Antal = Antal - @Antal
					WHERE ArtikelID = @ArtikelID;
					
				COMMIT TRAN
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				RAISERROR(@SetMsg, 16, 1)
			END CATCH
		END
	ELSE
		BEGIN
			RAISERROR('Artikeln finns inte! Försök igen.', 16, 1)
		END
END

EXEC usp_SaleStatistics 1, 4, 5, 0.00, 4

-- 3.b
ALTER PROCEDURE usp_AddCustomer
@Namn varchar(40), 
@Adress varchar(30),
@Postnr varchar(6),
@Ort varchar(25),
@Rabatt decimal(2,2),
@KategoriID int,
@Telnr varchar(15),
@TeltypID int
AS
BEGIN
	BEGIN TRY
		DECLARE @SetMsg varchar(40)
		
		BEGIN TRAN
		
			SET @SetMsg = 'Kunden kunde inte läggas till!'
			INSERT INTO Kund (Namn, Adress, Postnr, Ort, Rabatt, KategoriID)
			VALUES (@Namn, @Adress, @Postnr, @Ort, @Rabatt, @KategoriID);
			
			SET @SetMsg = 'Telefonen kunde inte läggas till!'
			EXEC usp_AddPhone @@IDENTITY, @Telnr, @TeltypID
			
		COMMIT TRAN
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RAISERROR(@SetMsg, 16, 1)
	END CATCH
END

EXEC usp_AddCustomer 'Karls Kebab', 'Torpgränd 1', '392 32', 'Kalmar', 0.00, 1, '43210', 1

ALTER PROCEDURE usp_AddPhone
@KundID int = @@IDENTITY,
@Telnr varchar(15),
@TeltypID int
AS
BEGIN
	BEGIN TRY
		INSERT INTO Telefon (KundID, Telenr, TeltypID)
		VALUES (@KundID, @Telnr, @TeltypID)
	END TRY
	BEGIN CATCH
		RAISERROR('Ett fel inträffade med telefonnummer/telefontyp! Försök igen', 16, 1)
	END CATCH
END

-- 3.c
ALTER PROCEDURE usp_FakturaDelete
@FakturaID int = 0
AS
BEGIN
	IF EXISTS(SELECT FakturaID FROM Faktura WHERE FakturaID = @FakturaID)
		BEGIN
			BEGIN TRY
				DECLARE @SetMsg varchar(40)
				
				BEGIN TRAN
				
					SET @SetMsg = 'Det gick inte att ta bort artikeln!'
					DECLARE @ArtikelID int, @Antal int
					DECLARE myCursor INSENSITIVE CURSOR
					FOR SELECT ArtikelID, Antal
					FROM Fakturarad;
					
					OPEN myCursor
					FETCH myCursor INTO @ArtikelID, @Antal
					WHILE @@FETCH_STATUS = 0
						BEGIN
							UPDATE Artikel
							SET Antal = Antal + @Antal
							WHERE ArtikelID = @ArtikelID;
							FETCH myCursor INTO @ArtikelID, @Antal
						END
					CLOSE myCursor
					DEALLOCATE myCursor;
					
					SET @SetMsg = 'Det gick inte att ta bort fakturaraden!'
					DELETE FROM Fakturarad
					WHERE FakturaID = @FakturaID
					
					SET @SetMsg = 'Det gick inte att ta bort fakturan!'
					DELETE Faktura
					WHERE FakturaID = @FakturaID
				
				COMMIT TRAN
				
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN
				RAISERROR(@SetMsg, 16, 1)
			END CATCH
		END
	ELSE
		BEGIN
			RAISERROR('Fakturan finns inte! Försök igen.', 16, 1)
		END
END



EXEC usp_FakturaDelete 3

-- 4.a
	--Tabell Skapad.

-- 4.b
ALTER TRIGGER ut_Artikel ON Artikel
AFTER UPDATE
AS
BEGIN
	IF UPDATE (Artnamn)
		BEGIN
			INSERT INTO Logging (tblID, tbl, kol, Old, New, Datum, Usr)
			SELECT
			i.ArtikelID,
			'Artikel',
			'Artnamn',
			d.Artnamn,
			i.Artnamn,
			GETDATE(),
			SYSTEM_USER
			FROM inserted as i INNER JOIN deleted as d
				ON i.ArtikelID = d.ArtikelID;
		END
END

SELECT * FROM Logging
*/