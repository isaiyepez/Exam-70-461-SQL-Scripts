--Clustered index: the table will be sorted in order of the key values.
CREATE CLUSTERED INDEX idx_tblEmployee ON [dbo].[tblEmployee]([EmployeeNumber])
DROP INDEX idx_tblEmployee ON [dbo].[tblEmployee]
-- Clustered index has not to be unique

select * FROM [dbo].[tblEmployee] WHERE EmployeeNumber = 127
--Now it will go through index seek instead a table scan
-- NOTE: A primary key is also a Clustered Index
ALTER TABLE [dbo].[tblEmployee]
ADD CONSTRAINT pk_tblEmployee PRIMARY KEY(EmployeeNumber)
