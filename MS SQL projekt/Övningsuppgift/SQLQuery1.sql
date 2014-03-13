SELECT Enamn, Fnamn
FROM Person
ORDER BY Enamn

SELECT Fnamn, Enamn, Ort
FROM Person
ORDER BY Fnamn

SELECT Fnamn, Enamn, Telnr 
FROM Person 
INNER JOIN Telefon 
ON Person.PID=telefon.PID

SELECT Fnamn, Enamn, Telnr
FROM Person
LEFT OUTER JOIN Telefon
ON Person.PID=Telefon.PID

SELECT Fnamn, Enamn, Telnr
FROM Person
RIGHT OUTER JOIN Telefon
ON Person.PID=Telefon.PID

SELECT Enamn, Fnamn
FROM Person
WHERE Enamn='Karlberg'