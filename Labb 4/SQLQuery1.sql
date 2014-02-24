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
	SET Pris = (SELECT Pris FROM Artikel
				WHERE ArtikelID = 2)
	WHERE ArtikelID = 2

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

-- 6.a
SELECT * FROM Kund

-- 6.b
SELECT Namn, Postnr, Ort FROM Kund

-- 6.c
SELECT Namn, Postnr, Ort FROM Kund
	ORDER BY Postnr DESC

-- 6.d
SELECT Namn, Postnr + ' ' + Ort AS Postadress FROM Kund
	ORDER BY Ort ASC
	
-- 6.e
SELECT ArtikelID, Artnamn, Plats, Antal, FLOOR(Pris * Antal) AS Artikelvärde FROM Artikel
	
-- 6.f
SELECT ArtikelID AS Artikelnr, Artnamn AS Namn, Plats, Antal, '____________' AS 'Nytt antal' FROM Artikel

-- 6.g
SELECT ArtikelID, Artnamn, Plats, Antal, FLOOR(Pris * Antal) AS Artikelvärde FROM Artikel
WHERE Antal >= 22 AND Plats LIKE 'Förråd 10'

-- 6.h
SELECT TOP 5 *, FLOOR(ROUND(Pris * Antal,0)) AS Artikelvärde FROM Artikel
	ORDER BY Artikelvärde DESC
-- 7.a
SELECT Namn, Ort, Telenr FROM Kund AS K
INNER JOIN Telefon AS T
	ON K.KundID = T.KundID
	
-- 7.b
SELECT Datum, Betvillkor, Artnamn, Fr.Antal, Fr.Pris, (M.Moms * 100) AS 'Moms i %', Fr.Rabatt, ((Fr.Pris * Fr.Antal) * (1 - Fr.Rabatt)) * (1 + M.Moms) AS Summa FROM Faktura AS F
INNER JOIN Fakturarad AS Fr
	ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
	ON Fr.ArtikelID = A.ArtikelID
INNER JOIN Moms AS M
	ON Fr.MomsID = M.MomsID
-- 7.c
SELECT Datum, Betvillkor, DATEADD(DD, Betvillkor, Datum) AS Förfallodatum,Artnamn, Fr.Antal, Fr.Pris, (M.Moms * 100) AS 'Moms i %', Fr.Rabatt, ((Fr.Pris * Fr.Antal) * (1 - Fr.Rabatt)) * (1 + M.Moms) AS Summa FROM Faktura AS F
INNER JOIN Fakturarad AS Fr
	ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
	ON Fr.ArtikelID = A.ArtikelID
INNER JOIN Moms AS M
	ON Fr.MomsID = M.MomsID
	
-- 7.d
SELECT Namn, Kategori AS Kundkategori, Datum AS Fakturadatum, Betvillkor AS Betalningsvillkor FROM Kund AS K
INNER JOIN Kategori AS Ka
	ON K.KategoriID = Ka.KategoriID
INNER JOIN Faktura AS F
	ON K.KundID = F.KundID
-- 7.e
SELECT Namn, Kategori AS Kundkategori, Datum AS Fakturadatum, Betvillkor AS Betalningsvillkor FROM Kund AS K
INNER JOIN Kategori AS Ka
	ON K.KategoriID = Ka.KategoriID
INNER JOIN Faktura AS F
	ON K.KundID = F.KundID
WHERE Datum BETWEEN '2012/04/01' AND '2012/04/30'

-- 7.f
SELECT Namn, (Postnr + ' ' + Ort) AS Postadress
FROM KUND LEFT JOIN Faktura
	ON Kund.KundID = Faktura.KundID
WHERE Faktura.KundID IS NULL

-- 7.g
SELECT Artikel.ArtikelID, Artnamn AS Artikelnamn, Artikel.Pris, Artikel.Antal
FROM Artikel LEFT JOIN Fakturarad
	ON Fakturarad.ArtikelID = Artikel.ArtikelID
WHERE Fakturarad.ArtikelID IS NULL

-- 8.a
SELECT COUNT(KundID) AS 'Antal kunder' FROM Kund

-- 8.b
SELECT FLOOR(SUM(Pris * Antal)) AS 'Totala artikelvärdet i kr' FROM Artikel

-- 8.c
SELECT * FROM Artikel
SELECT SUM(Antal) AS 'Antal artiklar i lager',
	FLOOR(SUM(Lagervärde)) AS 'Totala lagervärdet i kr',
	FLOOR(MAX(Pris)) AS 'Maxvärdet',
	CEILING(MIN(Pris)) AS 'Minvärdet',
	FLOOR(AVG(Pris)) AS 'Medelvärdet'
FROM Artikel

-- 8.d
SELECT * FROM Artikel
SELECT SUM(Antal) AS 'Antal artiklar i lager',
	FLOOR(SUM(Lagervärde)) AS 'Totala lagervärdet i kr',
	FLOOR(MAX(Pris)) AS 'Maxvärdet',
	CEILING(MIN(Pris)) AS 'Minvärdet',
	FLOOR(AVG(Pris)) AS 'Medelvärdet'
FROM Artikel
WHERE Lagervärde > (SELECT AVG(Lagervärde) FROM Artikel)

-- 8.e
SELECT F.FakturaID, MAX(Datum) AS Fakturadatum, SUM((Fr.Pris * Fr.Antal) * (1 - Fr.Rabatt)) AS 'Summa exkl. moms', SUM(((Fr.Pris * Fr.Antal) * (1 - Fr.Rabatt)) * (1 + M.Moms)) AS 'Summa inkl. moms'
FROM Faktura AS F
INNER JOIN Fakturarad AS Fr
	ON	F.FakturaID = Fr.FakturaID
INNER JOIN Moms AS M
	ON	Fr.MomsID = M.MomsID
GROUP BY F.FakturaID

-- 9.a
SELECT CONVERT(VARCHAR(10), Datum, 120) Betvillkor, CONVERT(VARCHAR(10), DATEADD(DD, Betvillkor, Datum), 120) AS Förfallodatum,Artnamn, Fr.Antal, Fr.Pris, (M.Moms * 100) AS 'Moms i %', Fr.Rabatt, ((Fr.Pris * Fr.Antal) * (1 - Fr.Rabatt)) * (1 + M.Moms) AS Summa FROM Faktura AS F
INNER JOIN Fakturarad AS Fr
	ON F.FakturaID = Fr.FakturaID
INNER JOIN Artikel AS A
	ON Fr.ArtikelID = A.ArtikelID
INNER JOIN Moms AS M
	ON Fr.MomsID = M.MomsID

-- 9.b
SELECT *, LEFT (Postnr, 3) AS Region FROM Kund

-- 9.c
SELECT (Artnamn + ' ' ++ ' ' + CAST((Antal * Pris) AS VARCHAR(10))) AS Artikellista FROM Artikel

-- 9.d
SELECT
DATEDIFF(DAY,GETDATE(), '2014-12-31') AS 'Dagar till nästa år',
DATEDIFF(DAY,GETDATE(), '2015-02-01') AS 'Dagar till nästa år',
DATEPART(DW, '2015-02-01') AS 'Födelsedagsveckan'