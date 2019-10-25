-----------------------------------SELF JOIN------------------------------------------

BEGIN TRAN

ALTER TABLE tblEmployee
ADD Manager INT
GO

UPDATE tblEmployee
SET Manager = ((EmployeeNumber - 123)/10) + 123
WHERE EmployeeNumber > 123

SELECT E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, E.Manager, M.EmployeeFirstName, M.EmployeeLastName
FROM tblEmployee AS E
JOIN tblEmployee AS M
ON E.Manager = M.EmployeeNumber

ROLLBACK TRAN

-----------------------------------RECURSIVE CTE-------------------------------------
BEGIN TRAN

ALTER TABLE tblEmployee
ADD Manager INT
GO

UPDATE tblEmployee
SET Manager = ((EmployeeNumber - 123)/10) + 123
WHERE EmployeeNumber > 123;

WITH myTable AS
(SELECT EmployeeNumber, EmployeeFirstName, EmployeeLastName, 0 AS BossLevel -- This code is called
	FROM tblEmployee														-- "The Anchor" 
 WHERE Manager IS NULL
 UNION ALL
 SELECT E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, myTable.BossLevel + 1
 FROM tblEmployee AS E
 JOIN myTable ON E.Manager = myTable.EmployeeNumber
)

SELECT * FROM myTable
ROLLBACK TRAN

