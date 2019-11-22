-- CURSOR
-- It is kind of a while, it will check every row in a given dataset.


-- DECLARE cursor_name CURSOR FOR SELECT statement FROM table
-- OPEN cursor_name
-- FETCH cursor_name INTO
-- CLOSE cursor_name

-- FETCH_STATUS (if is 0 is still retreiving data, if is < 0 then an error ocurred)
DECLARE @EmployeeID INT

DECLARE csr CURSOR FOR
SELECT [EmployeeNumber] FROM [dbo].[tblEmployee]
WHERE EmployeeNumber BETWEEN 120 AND 299

OPEN csr
FETCH NEXT FROM csr INTO @EmployeeID
WHILE @@FETCH_STATUS = 0

BEGIN
	SELECT * FROM [dbo].[tblTransaction] WHERE EmployeeNumber = @EmployeeID
	FETCH NEXT FROM csr INTO @EmployeeID
END

CLOSE csr
DEALLOCATE csr --Not necessary, but good practice.