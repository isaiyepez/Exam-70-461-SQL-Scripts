DECLARE @newValue AS UNIQUEIDENTIFIER --GUID
SET @newValue = NEWID()
SELECT @newValue AS TheNewID
GO

BEGIN TRAN
CREATE TABLE tblEmployee4
(UniqueID UNIQUEIDENTIFIER CONSTRAINT df_TblEmployee4_UniqueID DEFAULT NEWID(),
--BETTER TO USE A NEWSEQUENTIALID() IN A DEFAULT CONSTRAINT
EmployeeNumber INT CONSTRAINT uq_tblEmployee4_EmployeeNumber UNIQUE)

INSERT INTO tblEmployee4(EmployeeNumber)
VALUES (1), (2), (3)

SELECT * FROM tblEmployee4
ROLLBACK TRAN
GO

DECLARE @newvalue AS UNIQUEIDENTIFIER
-- Note that, instead of INT which will take 4 bytes, GUID will take 16 bytes

-----------------------------------SEQUENCES---------------------------------------
BEGIN TRAN
CREATE SEQUENCE newSeq AS INT
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999
CYCLE --at the end, it will cycle (goes back at the beginning of the sequence and starts again)

CREATE SEQUENCE secondSeq AS INT
SELECT * FROM sys.sequences
--IN THIS SECOND CASE, IT WILL TAKE THE MIN VALUE OF THE DATA TYPE AND THE MAX FOR THE MAXIMUM VALUE

ROLLBACK TRAN
---------------------------------------------------------------------------------------------
BEGIN TRAN
CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
CACHE 50
SELECT NEXT VALUE FOR newSeq AS NextValue;
-- SELECT *, NEXT VALUE FOR newSeq OVER (ORDER BY DateOfTransaction) AS NextNumber FROM tblTransaction
ROLLBACK TRAN

CREATE SEQUENCE newSeq AS BIGINT
START WITH 1
INCREMENT BY 1
MINVALUE 1
--MAXVALUE 999999
--CYCLE
CACHE 50

ALTER TABLE tblTransaction
ADD NextNumber INT CONSTRAINT DF_Transaction DEFAULT NEXT VALUE FOR newSeq

BEGIN TRAN
SELECT * FROM tblTransaction
INSERT INTO tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES(1,'2017-01-01', 123)
SELECT * FROM tblTransaction WHERE EmployeeNumber = 123;
UPDATE tblTransaction
SET NextNumber = NEXT VALUE FOR newSeq
WHERE NextNumber IS NULL
SELECT * FROM tblTransaction WHERE EmployeeNumber = 123
ROLLBACK TRAN

--TO RESET IDENTITY
--SET IDENTITY_INSERT tableName ON
--DBCC CHECKIDENT(tablename, RESEED)

--TO RESET SEQUENCE
--ALTER SEQUENCE newSeq
--RESTART
--(Or this option)
--ALTER SEQUENCE newSeq
--RESTART WITH -1000

ALTER TABLE tblTransaction
DROP DF_Transaction
ALTER TABLE tblTransaction
DROP COLUMN NextNumber
DROP SEQUENCE newSeq


