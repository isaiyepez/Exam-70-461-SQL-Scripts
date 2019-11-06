--To mark a transaction, you have to name it and after that, add the 'With Mark' reserved words

BEGIN TRANSACTION MyTransaction WITH MARK 'My Transaction'

SELECT * FROM 
	[dbo].[tblEmployee]

UPDATE 
	[dbo].[tblEmployee]
SET EmployeeNumber = 122 WHERE EmployeeNumber = 123

ROLLBACK TRANSACTION MyTransaction