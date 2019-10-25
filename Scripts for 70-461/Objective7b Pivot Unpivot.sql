WITH MyTable AS
(SELECT YEAR(DateOfTransaction) AS TheYear, MONTH(DateOfTransaction) AS TheMonth, Amount FROM tblTransaction)

--Whatever remains, will be the rows going down
SELECT TheYear,
	ISNULL([1],0) AS [1],
	ISNULL([2],0) AS [2],
	ISNULL([3],0) AS [3],
	ISNULL([4],0) AS [4],
	ISNULL([5],0) AS [5],
	ISNULL([6],0) AS [6],
	ISNULL([7],0) AS [7],
	ISNULL([8],0) AS [8],
	ISNULL([9],0) AS [9],
	ISNULL([10],0) AS [10],
	ISNULL([11],0) AS [11],
	ISNULL([12],0) AS [12]
FROM MyTable
PIVOT (SUM(Amount) FOR TheMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS myPvt
ORDER BY TheYear

--------------------------------------UNPIVOT----------------------------------------------------

WITH MyTable AS
(SELECT YEAR(DateOfTransaction) AS TheYear, MONTH(DateOfTransaction) AS TheMonth, Amount FROM tblTransaction)

--Whatever remains, will be the rows going down
SELECT TheYear,
	ISNULL([1],0) AS [1],
	ISNULL([2],0) AS [2],
	ISNULL([3],0) AS [3],
	ISNULL([4],0) AS [4],
	ISNULL([5],0) AS [5],
	ISNULL([6],0) AS [6],
	ISNULL([7],0) AS [7],
	ISNULL([8],0) AS [8],
	ISNULL([9],0) AS [9],
	ISNULL([10],0) AS [10],
	ISNULL([11],0) AS [11],
	ISNULL([12],0) AS [12]
INTO tblPivot
FROM MyTable
	PIVOT (SUM(Amount) FOR TheMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS myPvt
ORDER BY TheYear

SELECT *
  FROM [70-461].[dbo].[tblPivot]
UNPIVOT (Amount FOR Month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS tblUnpivot
WHERE Amount <> 0


with myTable as (
select [EmployeeNumber]/100 as EmployeeHundreds, Department
, 1 as EmployeeCount
from dbo.tblEmployee)
select * from myTable

