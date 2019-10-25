SELECT * FROM tblEmployee WHERE EmployeeNumber = 129
GO

DECLARE @command AS VARCHAR(255);
SET @command = 'SELECT * FROM tblEmployee WHERE EmployeeNumber = 129;'
EXECUTE @command
GO

DECLARE @command AS VARCHAR(255), @param AS VARCHAR(50);
SET @command = 'SELECT * FROM tblEmployee WHERE EmployeeNumber = '
SET @param = '129 Or 1=1'
EXECUTE (@command + @param); --SQL Injection
GO

--MUCH SAFER:
DECLARE @command AS NVARCHAR(255), @param AS NVARCHAR(50);
SET @command = N'SELECT * FROM tblEmployee WHERE EmployeeNumber = @productID'
SET @param = N'129' --Not the same variable name, to avoid SQL Injections
EXECUTE sys.sp_executesql @statement = @command, @params = N'@ProductID int', @ProductID = @param;