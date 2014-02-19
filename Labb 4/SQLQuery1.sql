-- 3.a
SELECT * FROM Kategori
SELECT * FROM Kund

INSERT INTO Kund (Namn, Adress, Postnr, Ort, Rabatt, KategoriID)
	VALUES ('Danielssons Elektriska AB', 'Storgatan', '123 56', 'Stockholm', 0.03, 1)

SELECT * FROM Teltyp
SELECT * FROM Telefon
INSERT INTO Telefon (Telenr, TeltypID, KundID)
	VALUES ('08-897 02 00', 6, 6), ('070-547 02 87', 5, 6)

-- 3.b
SELECT * FROM Artikel
INSERT INTO Artikel (Artnamn, Antal, Pris, Rabatt)
	VALUES ('Bildskärm, platt 10ms', 47, 2176.00, 0), ('Tangentbord', 36, 280.00, 0), ('Nätkabel, TP kat 5', 1020, 2.50, 0)

-- 3.c
SELECT * FROM Faktura
INSERT INTO Faktura (Datum, Betvillkor, KundID)
	VALUES ('2012-04-20', 25, 6)

SELECT * FROM Faktura
SELECT * FROM Fakturarad
SELECT * FROM Moms
SELECT * FROM Artikel
INSERT INTO Fakturarad (FakturaID, ArtikelID, Antal, Pris, Rabatt, MomsID)
	VALUES (3, 5, 2, 2176.00, 0.03, 4), (3, 1, 22, 6.70, 0.03, 4)

-- 3.d
SELECT * FROM Kategori
INSERT INTO Kategori (Kategori)
	VALUES ('Standard')

-- 4.a
SELECT * FROM Kategori
SELECT * FROM Kund
UPDATE Kund
	SET KategoriID = 4
	WHERE KundID = 1

-- 4.b
SELECT * FROM Telefon
SELECT * FROM Kund
UPDATE Telefon
	SET Telenr = 0480-492239
	WHERE TelID = 4

-- 4.c
SELECT Pris FROM Artikel
UPDATE Artikel
	SET Pris = Pris * 1.08

-- 4.d
 -- Fixad i SSMS.
 
-- 4.e
SELECT * FROM Artikel
UPDATE Artikel
	SET Plats = 'HPL 25'
	WHERE Artnamn LIKE 'Bildskärm%'

-- 4.f
SELECT * FROM Artikel
UPDATE Artikel
	SET Plats = 'Förråd 10'
	WHERE Plats IS NULL
	
-- 4.g
SELECT * FROM Fakturarad
SELECT * FROM Artikel
UPDATE Fakturarad
	SET Pris = 14.58
	WHERE ArtikelID LIKE 2

-- 5.a
SELECT * FROM Kund
SELECT * FROM Teltyp
SELECT * FROM Telefon
DELETE FROM Telefon
	WHERE TeltypID LIKE 6

-- 5.b
SELECT * FROM Fakturarad
SELECT ArtikelID, Artnamn FROM Artikel
DELETE FROM Fakturarad
	WHERE ArtikelID = 4
	
-- 5.c
SELECT * FROM Kategori
DELETE FROM Kategori
	WHERE KategoriID = 4
-- Detta fungerade inte eftersom RI är satt till No Action, alltså får man inte ta bort en kategori som någon befintlig kund tillhör.