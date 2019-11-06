-- If you have an inner transaction inside an outer transaction, and then you
-- try to roll back the inner one, even if the outer transaction is marked as 
-- commit, it will fail. Roll back affects all transactions.

--E. G:
SELECT * FROM [dbo].[tblEmployee]
BEGIN TRAN
	SELECT @@TRANCOUNT
	BEGIN TRAN
		UPDATE 
			[dbo].[tblEmployee]
		SET EmployeeNumber = 122 WHERE EmployeeNumber = 123
		SELECT @@TRANCOUNT
	COMMIT TRAN
	SELECT @@TRANCOUNT
COMMIT TRAN

SELECT * FROM [dbo].[tblEmployee]