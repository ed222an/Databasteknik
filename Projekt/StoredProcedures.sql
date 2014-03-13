-- Visar alla medlemmar i listan, sorterar på efternamnet.
ALTER PROCEDURE appSchema.usp_GetMembers
AS
BEGIN
	SELECT MedID, Fnamn, Enamn, PersNR, BefID, Address, PostNr, Ort
	FROM Medlem
	ORDER BY Enamn ASC
END
GO

EXEC appSchema.usp_GetMembers

-- Visar detaljerad information om enskild medlem.
ALTER PROCEDURE appSchema.usp_GetMember
@MedID int = 0
AS
BEGIN
	IF EXISTS(SELECT MedID FROM Medlem WHERE MedID = @MedID)
		BEGIN
			SELECT Fnamn, Enamn, PersNR, Address, PostNr, Ort
			FROM Medlem
			WHERE MedID = @MedID
		END
	ELSE
		BEGIN
			RAISERROR('Den valda medlemmen finns inte! Försök igen.', 16, 1)
		END
END
GO

EXEC appSchema.usp_GetMember 6

-- Lägger till en ny medlem.
ALTER PROCEDURE appSchema.usp_AddMember
@Fnamn varchar(20),
@Enamn varchar(20),
@PersNR char(11),
@Address varchar(30),
@PostNR varchar(6),
@Ort varchar(25)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Medlem (Fnamn, Enamn, PersNR, Address, PostNr, Ort)
		VALUES (@Fnamn, @Enamn, @PersNR, @Address, @PostNR, @Ort)
	END TRY
	BEGIN CATCH
		RAISERROR('Ett fel inträffade! Försök igen', 16, 1)
	END CATCH
END
GO

--EXEC appSchema.usp_AddMember 'Himla', 'Dunsson', '950629-3325', 'Kolhuggargränd 5', '39230', 'Kalmar'

-- Tar bort vald medlem.
ALTER PROCEDURE appSchema.usp_DeleteMember
@MedID int = 0
AS
BEGIN
	IF EXISTS(SELECT MedID FROM Medlem WHERE MedID = @MedID)
		BEGIN
			DELETE Medlem
			WHERE Medlem.MedID = @MedID
		END
	ELSE
		BEGIN
			RAISERROR('Den valda medlemmen finns inte! Försök igen.', 16, 1)
		END
END
GO

--EXEC appSchema.usp_DeleteMember 4

-- Lägger till en aktivitet till en medlem.
ALTER PROCEDURE appSchema.usp_AddMemberActivity
@MedID int = 0,
@AktID int = 0
AS
BEGIN
	IF EXISTS(SELECT MedID FROM Medlem WHERE MedID = @MedID)
		AND EXISTS(SELECT AktID FROM Aktivitet WHERE AktID = @AktID)
		BEGIN
			BEGIN TRY
				INSERT INTO Medlemsaktivitet (AktID, MedID)
				VALUES (@AktID, @MedID)
			END TRY
			BEGIN CATCH
				RAISERROR('Ett oväntat fel inträffade! Försök igen.', 16, 1)
			END CATCH
		END
	ELSE
		BEGIN
			RAISERROR('Den valda medlemmen/aktiviteten finns inte! Försök igen.', 16, 1)
		END
END
GO

--EXEC appSchema.usp_AddMemberActivity 0, 1

-- Uppdaterar vald medlem.
ALTER PROCEDURE appSchema.usp_UpdateMember
@MedID int = 0,
@Fnamn varchar(20),
@Enamn varchar(20),
@PersNR char(11),
@Address varchar(30),
@PostNR varchar(6),
@Ort varchar(25)
AS
BEGIN
	IF EXISTS(SELECT MedID FROM Medlem WHERE MedID = @MedID)
		BEGIN
			BEGIN TRY
				UPDATE Medlem
				SET Fnamn = @Fnamn,
				Enamn = @Enamn,
				PersNR = @PersNR,
				Address = @Address,
				PostNr = @PostNR,
				Ort = @Ort
				WHERE MedID = @MedID
			END TRY
			BEGIN CATCH
				RAISERROR('Ett oväntat fel inträffade! Försök igen.', 16, 1)
			END CATCH
		END
	ELSE
		BEGIN
			RAISERROR('Den valda medlemmen finns inte! Försök igen.', 16, 1)
		END
END
GO

--EXEC appSchema.usp_UpdateMember 6, 'Orvar', 'Karlsson', '950629-3325', 'Halleband 2', '32213', 'Strömsund'