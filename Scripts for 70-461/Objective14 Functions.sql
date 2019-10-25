

--CREATE FUNCTION AmountPlusOne -- SCALAR FUNCTION: Only one value back
--(
--    @Amount SMALLMONEY
--)
--RETURNS SMALLMONEY
--AS
--BEGIN

--    RETURN @Amount + 1

--END


SELECT
	DateOfTransaction, EmployeeNumber, Amount, dbo.AmountPlusOne(Amount) AS AmountAndOne --NOTICE: unlike Stored Procedures, you can use a function inside a SELECT statement
FROM tblTransaction

---Another way to use functions
DECLARE @myValue SMALLMONEY
EXEC @myValue = dbo.AmountPlusOne 345.67 --OR @Amount = 345.67
SELECT @myValue

--------------------------------------------------------------------------------

--CREATE FUNCTION NumberOfTransactions(@EmployeeNumber int)
--RETURNS INT
--AS
--BEGIN
--	DECLARE @NumberOfTransactions INT
--	SET @NumberOfTransactions = (SELECT COUNT(*) FROM tblTransaction
--	WHERE EmployeeNumber = @EmployeeNumber)
--	RETURN @NumberOfTransactions
--END

SELECT *, dbo.NumberOfTransactions(EmployeeNumber) AS transNum
FROM tblEmployee

---------------------INLINE TABLE FUNCTION--------------------------------------
--CREATE FUNCTION TransactionList(@EmployeeNumber INT)
--RETURNS TABLE AS RETURN
--(
--    SELECT * FROM tblTransaction
--	WHERE EmployeeNumber = @EmployeeNumber
--)

SELECT * FROM dbo.TransactionList(123)

SELECT * FROM tblEmployee WHERE EXISTS(SELECT * FROM TransactionList(EmployeeNumber))

SELECT DISTINCT E.*
FROM tblEmployee AS E
JOIN tblTransaction AS T
ON E.EmployeeNumber = T.EmployeeNumber

SELECT * FROM tblEmployee AS E
WHERE EXISTS(SELECT EmployeeNumber FROM tblTransaction AS T WHERE E.EmployeeNumber = T.EmployeeNumber)

------------------- MULTI-STATEMENT TABLE FUNCTION -------------------------------------------------------

CREATE FUNCTION TransList
(
    @EmployeeNumber INT
)
RETURNS @TransList TABLE 
(
	[Amount] SMALLMONEY,
	[DateOfTransaction] SMALLDATETIME,
	[EmployeeNumber] INT
)
AS
BEGIN
    INSERT INTO @TransList(Amount, DateOfTransaction, EmployeeNumber)
    SELECT Amount, DateOfTransaction, EmployeeNumber FROM tblTransaction
	WHERE EmployeeNumber = @EmployeeNumber
    RETURN 
END

SELECT * FROM dbo.TransList(123)
GO
------------------------OUTER APPLY/CROSS APPLY---------------------------------

SELECT * FROM tblEmployee AS E
OUTER APPLY TransList(E.EmployeeNumber) AS T -- KIND OF LEFT JOIN

SELECT * FROM tblEmployee AS E
CROSS APPLY TransList(E.EmployeeNumber) AS T -- KIND OF LEFT JOIN

--Using a UDF (User Defined Function) inside a WHERE clause
SELECT * FROM tblEmployee AS E
WHERE (SELECT COUNT(*) FROM dbo.TransList(E.EmployeeNumbeR)) > 3 --When executed, it will be kind of slow...