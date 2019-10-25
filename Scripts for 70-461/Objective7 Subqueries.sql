USE [70-461]
GO


SELECT * FROM tblTransaction AS T
INNER JOIN tblEmployee AS E
ON E.EmployeeNumber = T.EmployeeNumber
WHERE E.EmployeeLastName LIKE 'Y%'
ORDER BY T.EmployeeNumber

---------ALTERNATIVE--------------
SELECT * FROM tblTransaction AS T
WHERE EmployeeNumber IN(126,127,128,129)
ORDER BY EmployeeNumber

----------SUBQUERY-----------------
SELECT * FROM tblTransaction AS T
WHERE EmployeeNumber IN
(SELECT EmployeeNumber FROM tblEmployee WHERE EmployeeLastName NOT LIKE 'Y%')
ORDER BY EmployeeNumber-- Must be in tblEmployee AND tblTransaction, and not 126-129 Employee numbers (INNER JOIN)

SELECT * FROM tblTransaction AS T
WHERE EmployeeNumber NOT IN
(SELECT EmployeeNumber FROM tblEmployee WHERE EmployeeLastName LIKE 'Y%')
ORDER BY EmployeeNumber -- Must be in tblTransaction, and not 126-129 (LEFT JOIN)

SELECT * FROM tblTransaction AS T WHERE EmployeeNumber = ANY 
	(SELECT EmployeeNumber FROM tblEmployee WHERE EmployeeLastName LIKE 'Y%')
ORDER BY EmployeeNumber

SELECT * FROM tblTransaction AS T WHERE EmployeeNumber <> ANY 
	(SELECT EmployeeNumber FROM tblEmployee WHERE EmployeeLastName LIKE 'Y%')
ORDER BY EmployeeNumber -- Is kind of an "OR". If at least one element of the list is true, the query will output "true". 
--So, it will review each EmployeeNumber against this list (126,127,128,129) -employees with Y%, and since one is false (it will be a match), but the others are true,
--it will consider "true" as output.

SELECT * FROM tblTransaction AS T WHERE EmployeeNumber <> ALL 
	(SELECT EmployeeNumber FROM tblEmployee WHERE EmployeeLastName LIKE 'Y%')
ORDER BY EmployeeNumber --In this case, is kind of "AND"

--ANY/SOME = OR
--ALL = AND

--------------------------------- WHERE -----------------------------------
SELECT * FROM tblTransaction AS T
INNER JOIN (SELECT * FROM tblEmployee 
	WHERE EmployeeLastName LIKE 'y%') AS E
ON E.EmployeeNumber = T.EmployeeNumber
ORDER BY T.EmployeeNumber

SELECT * FROM tblTransaction AS T
INNER JOIN tblEmployee AS E
ON E.EmployeeNumber = T.EmployeeNumber
	WHERE E.EmployeeLastName LIKE 'Y%'
ORDER BY T.EmployeeNumber

SELECT * FROM tblTransaction AS T
LEFT JOIN (SELECT * FROM tblEmployee 
	WHERE EmployeeLastName LIKE 'y%') AS E
ON E.EmployeeNumber = T.EmployeeNumber
ORDER BY T.EmployeeNumber

SELECT * FROM tblTransaction AS T
LEFT JOIN tblEmployee AS E
ON E.EmployeeNumber = T.EmployeeNumber
	WHERE E.EmployeeLastName LIKE 'Y%'
ORDER BY T.EmployeeNumber

SELECT * FROM tblTransaction AS T
LEFT JOIN tblEmployee AS E
ON E.EmployeeNumber = T.EmployeeNumber
	AND E.EmployeeLastName LIKE 'Y%'
ORDER BY T.EmployeeNumber

-----------------SELECT--------------------------------
SELECT 
	E.EmployeeNumber, 
	E.EmployeeFirstName, 
	E.EmployeeLastName, 
	COUNT(T.EmployeeNumber) AS NumTransactions
FROM tblTransaction AS T
	INNER JOIN tblEmployee AS E
	ON E.EmployeeNumber = T.EmployeeNumber
WHERE E.EmployeeLastName LIKE 'Y%'
GROUP BY 
	E.EmployeeNumber, 
	E.EmployeeFirstName, 
	E.EmployeeLastName
ORDER BY 
	E.EmployeeNumber

SELECT EmployeeNumber, EmployeeFirstName, EmployeeLastName, (SELECT COUNT(T.EmployeeNumber)
	FROM tblTransaction AS T
	WHERE T.EmployeeNumber = E.EmployeeNumber) AS NumTransactions
FROM tblEmployee AS E
WHERE E.EmployeeLastName LIKE 'y%' --Correlated subquery

--------------------------------WHERE---------------------------------------------------
SELECT 
	EmployeeNumber, 
	EmployeeFirstName, 
	EmployeeLastName, 
	(SELECT COUNT(T.EmployeeNumber)
		FROM tblTransaction AS T
	WHERE T.EmployeeNumber = E.EmployeeNumber) 
		AS NumTransactions,
	(SELECT SUM(T.Amount)
		FROM tblTransaction AS T
	WHERE T.EmployeeNumber = E.EmployeeNumber) 
		AS TotalAmount
FROM 
	tblEmployee AS E
WHERE 
	E.EmployeeLastName LIKE 'y%' 

SELECT
	*
FROM
	tblTransaction AS T
WHERE
	EXISTS
	(
		SELECT 
			EmployeeNumber 
		FROM 
			tblEmployee AS E 
		WHERE 
			EmployeeLastName 
				LIKE 'Y%' 
				AND T.EmployeeNumber = E.EmployeeNumber)
ORDER BY EmployeeNumber
--------------TOP 5 FROM VARIOUS CATEGORIES----------------------------------
SELECT * FROM
(SELECT
	D.Department, 
	EmployeeNumber, 
	EmployeeFirstName, 
	EmployeeLastName,
	RANK() OVER(PARTITION BY D.Department ORDER BY E.EmployeeNumber) AS TheRank
FROM
	tblDepartment AS D
JOIN
	tblEmployee AS E
ON
	D.Department = E.Department) AS MyTable
WHERE TheRank <= 5
ORDER BY
	Department,
	EmployeeNumber

-----------------------------WITH STATEMENT---------------------------------------------
WITH tblWithRanking AS
(SELECT D.Department, EmployeeNumber, EmployeeFirstName, EmployeeLastName,
RANK() OVER(PARTITION BY D.Department ORDER BY E.EmployeeNumber) AS TheRank
FROM tblDepartment AS D
JOIN tblEmployee AS E ON D.Department = E.Department),
Transaction2014 AS
(SELECT * FROM tblTransaction WHERE DateOfTransaction < '2015-01-01')

SELECT * FROM tblWithRanking -- Notice that even when it looks almost the same, it is more understandable than the previous query
LEFT JOIN
	Transaction2014
ON tblWithRanking.EmployeeNumber = Transaction2014.EmployeeNumber

WHERE TheRank <= 5
ORDER BY Department, tblwithRanking.EmployeeNumber

-----------------------------GENERATING LIST OF NUMBERS---------------------------------

SELECT E.EmployeeNumber FROM tblEmployee AS E
LEFT JOIN tblTransaction AS T
ON E.EmployeeNumber = T.EmployeeNumber
WHERE T.EmployeeNumber IS NULL
ORDER BY E.EmployeeNumber

SELECT * FROM tblTransaction
ORDER BY EmployeeNumber ASC

WITH Numbers AS (
	SELECT TOP(SELECT MAX(EmployeeNumber) FROM tblTransaction) ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNumber
	FROM tblTransaction AS U)

SELECT U.RowNumber FROM Numbers AS U
	LEFT JOIN tblTransaction AS T
	ON U.RowNumber = T.EmployeeNumber
WHERE T.EmployeeNumber IS NULL
ORDER BY U.RowNumber 
------------------------------GROUPING NUMBERS--------------------------------------------

WITH Numbers AS (
	SELECT TOP(SELECT MAX(EmployeeNumber) FROM tblTransaction) ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNumber
	FROM tblTransaction AS U),
Transactions2014 AS (
	SELECT * FROM tblTransaction WHERE DateOfTransaction >= '2014-01-01' AND DateOfTransaction < '2015-01-01'),

tblGap AS (
	SELECT U.RowNumber,
		RowNumber - LAG(RowNumber) OVER(ORDER BY RowNumber) AS PreviousRowNumber,
		LEAD(RowNumber) OVER(ORDER BY RowNumber) - RowNumber AS NextRowNumber,
		CASE WHEN
		RowNumber - LAG(RowNumber) OVER(ORDER BY RowNumber) = 1 THEN 0 ELSE 1 END AS GroupGap
		FROM Numbers AS U
		LEFT JOIN tblTransaction AS T
	ON U.RowNumber = T.EmployeeNumber
WHERE T.EmployeeNumber IS NULL),
tblGroup AS(
SELECT *, SUM(GroupGap) OVER (ORDER BY RowNumber) 
	AS TheGroup 
FROM tblGap)
SELECT TheGroup, MIN(RowNumber) AS StartingEmployeeNumber, MAX(RowNumber) AS EndingEmployeeNumber 
FROM tblGroup
GROUP BY TheGroup
ORDER BY RowNumber