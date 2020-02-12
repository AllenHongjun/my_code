SELECT e.NationalIDNumber,
CAST[e.HireDate as DATE] HireDate,
p.LastName,
p.FirstName,
p.MiddleName
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
WHERE CAST[e.HireDate as date] BETWEEN '1999-01-01' AND '1999-01-31'