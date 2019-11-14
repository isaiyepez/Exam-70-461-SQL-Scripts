--Clustered index: the table will be sorted in order of the key values.
CREATE CLUSTERED INDEX idx_tblEmployee ON [dbo].[tblEmployee]([EmployeeNumber])
DROP INDEX idx_tblEmployee ON [dbo].[tblEmployee]
-- Clustered index has not to be unique

select * FROM [dbo].[tblEmployee] WHERE EmployeeNumber = 127
--Now it will go through index seek instead a table scan
-- NOTE: A primary key is also a Clustered Index
ALTER TABLE [dbo].[tblEmployee]
ADD CONSTRAINT pk_tblEmployee PRIMARY KEY(EmployeeNumber)

-- Non clustered index creates an ordered index and it doesn't resort the main table.
-- Like clustered indexes, non-clustered indexes can have duplicated values.
CREATE NONCLUSTERED INDEX idx_tblEmployee_DateOfBirth ON [dbo].[tblEmployee]([DateOfBirth])

SELECT * FROM [dbo].[tblEmployee]
WHERE DateOfBirth >='1992-01-01' AND DateOfBirth < '1993-01-01'

-- This index will be created since you can have more than one non-clustered index in the same
-- table.
CREATE NONCLUSTERED INDEX idx_tblEmployee_DateOfBirth_Department ON [dbo].[tblEmployee]([DateOfBirth], [Department])

-- Now, if you try to execute this select, and check the execution plan, you will see that it has
-- an index seek instead of an index scan.

SELECT DateOfBirth, Department FROM [dbo].[tblEmployee]
WHERE DateOfBirth >='1992-01-01' AND DateOfBirth < '1993-01-01'

-- NOTE: be careful, do not create lots of indexes without a good reason for them. You can oveload
-- the system with too many indexes

-- Filtered indexes:
CREATE NONCLUSTERED INDEX idx_LastNameForHR
ON [dbo].[tblEmployee]([EmployeeLastName]) where [Department] = 'HR'

SELECT EmployeeLastName
FROM [dbo].[tblEmployee]
WHERE Department = 'HR'

-- Filtered indexes are a way to avoid creating too many indexes.

-- Include
-- Indexes are like trees, so in the "leaf" level you can include extra fields that won't affect 
-- database performance
CREATE NONCLUSTERED INDEX idx_LastNameForHRInclude
ON [dbo].[tblEmployee]([EmployeeNumber])
INCLUDE ([EmployeeFirstName],[EmployeeMiddleName],[EmployeeLastName])

-- Unless you have special requirements, try to use clustered indexes instead of nonclustered.
-- Clustered indexes change the table, nonclustered does not.

