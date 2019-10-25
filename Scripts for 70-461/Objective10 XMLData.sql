DECLARE @x XML
SET @x = '<Shopping ShopperName = "Phillip Burton" Weather = "Nice">
<ShoppingTrip ShoppingTripID="L1">
    <Item Cost="5">Bananas</Item>
    <Item Cost="4">Apples</Item>
    <Item Cost="3">Cherries</Item>
</ShoppingTrip>
<ShoppingTrip ShoppingTripID="L2">
    <Item>Emeralds</Item>
    <Item>Diamonds</Item>
    <Item>Furniture</Item>
</ShoppingTrip>
</Shopping>'

--SELECT @x -- A Select without WHERE is only possible in Management Studio

--ALTER TABLE 
--[dbo].[tblEmployee]
--ADD XMLOutput XML NULL

--ctrl + shift + r  to update references

--UPDATE [dbo].[tblEmployee]
--SET XMLOutput = @x
--WHERE EmployeeNumber = 200

--ALTER TABLE [dbo].[tblEmployee]
--DROP COLUMN xmlOutput

SELECT E.EmployeeNumber, E.EmployeeFirstName, E.EmployeeLastName, E.DateOfBirth, T.Amount, T.DateOfTransaction
FROM [dbo].[tblEmployee] AS E
LEFT JOIN [dbo].[tblTransaction] AS T
ON E.EmployeeNumber = T.EmployeeNumber
WHERE E.EmployeeNumber BETWEEN 200 AND 202
--FOR XML RAW
--FOR XML RAW('MyRow')
FOR XML RAW('MyRow'), ELEMENTS
--NOTE: Execute each and see what happens

--------------------------------------FOR XML AUTO-------------------------------------------------------------------
SELECT tEmployee.EmployeeNumber, 
	tEmployee.EmployeeFirstName, 
	tEmployee.EmployeeLastName, 
	tEmployee.DateOfBirth, 
	tTransaction.Amount, 
	tTransaction.DateOfTransaction
FROM [dbo].[tblEmployee] AS tEmployee
LEFT JOIN [dbo].[tblTransaction] AS tTransaction
ON tEmployee.EmployeeNumber = tTransaction.EmployeeNumber
WHERE tEmployee.EmployeeNumber BETWEEN 200 AND 202
--FOR XML AUTO --This will separate by XML atributes and each atribute will be named as the alias of its table
FOR XML AUTO, ELEMENTS



--SELECT 
--	e.EmployeeFirstName AS '@EmployeeFirstName', 
--	e.EmployeeLastName AS '@EmployeeLastName', 
--	e.DateOfBirth, 
--	(SELECT T.Amount AS '@Amount'
--	FROM [dbo].[tblTransaction] AS T
--	WHERE e.EmployeeNumber = T.EmployeeNumber
--	FOR XML PATH('r'), TYPE) AS TransactionElement 	
--FROM [dbo].[tblEmployee] AS e
--WHERE e.EmployeeNumber BETWEEN 200 AND 202
--FOR XML PATH('Elements'), ROOT('MyXML')

SELECT tEmployee.EmployeeNumber, 
	tEmployee.EmployeeFirstName, 
	tEmployee.EmployeeLastName, 
	tEmployee.DateOfBirth, 
	tTransaction.Amount, 
	tTransaction.DateOfTransaction
FROM [dbo].[tblEmployee] AS tEmployee
LEFT JOIN [dbo].[tblTransaction] AS tTransaction
ON tEmployee.EmployeeNumber = tTransaction.EmployeeNumber
WHERE tEmployee.EmployeeNumber BETWEEN 200 AND 202
FOR XML path('Employees')

------------------Shreddding XML Data----------------------------
-------------XQuery Value and Exist methods----------------------
DECLARE @x XML
SET @x = '<Shopping ShopperName = "Phillip Burton" Weather = "Nice">
<ShoppingTrip ShoppingTripID="L1">
    <Item Cost="5">Bananas</Item>
    <Item Cost="4">Apples</Item>
    <Item Cost="3">Cherries</Item>
</ShoppingTrip>
<ShoppingTrip ShoppingTripID="L2">
    <Item>Emeralds</Item>
    <Item>Diamonds</Item>
    <Item>Furniture</Item>
</ShoppingTrip>
</Shopping>'
--SELECT @x.value('(/Shopping/ShoppingTrip/Item)[1]', 'varchar(50)')--For elements
--SELECT @x.value('(/Shopping/ShoppingTrip/Item/@Cost)[1]', 'varchar(50)')
--SELECT @x.exist('(/Shopping/ShoppingTrip/Item/@Cost)[1]') --Returns a bool value wheter if exists or not
--SET @x.modify('replace value of (/Shopping/ShoppingTrip[1]/Item[3]/@Cost)[1] with "6.0"')
SET @x.modify('insert <Item Cost="5">New Food</Item> into (/Shopping/ShoppingTrip)[2]')
SELECT @x

-----------------------Xquery Query method using For and Return------------------------
DECLARE @x XML
SET @x = '<Shopping ShopperName = "Phillip Burton" Weather = "Nice">
<ShoppingTrip ShoppingTripID="L1">
    <Item Cost="5">Bananas</Item>
    <Item Cost="4">Apples</Item>
    <Item Cost="3">Cherries</Item>
</ShoppingTrip>
<ShoppingTrip ShoppingTripID="L2">
    <Item>Emeralds</Item>
    <Item>Diamonds</Item>
    <Item>Furniture</Item>
</ShoppingTrip>
</Shopping>'

--SELECT @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip/Item return $ValueRetrieved')
--SELECT @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip/Item return concat(string($ValueRetrieved),";")')
--SELECT @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip[1]/Item
--		order by $ValueRetrieved/@Cost
--	return concat(string($ValueRetrieved),";")')
SELECT @x.query('for $ValueRetrieved in /Shopping/ShoppingTrip[1]/Item
				let $CostVariable := $ValueRetrieved/@Cost
				where $CostVariable >= 4
				order by $CostVariable		
	return concat(string($ValueRetrieved),";")')
--For let where order by return
----------------------XQUERY Nodes - Shredding a variable--------------------------------

DECLARE @x XML
SET @x = '<Shopping ShopperName = "Phillip Burton" Weather = "Nice">
<ShoppingTrip ShoppingTripID="L1">
    <Item Cost="5">Bananas</Item>
    <Item Cost="4">Apples</Item>
    <Item Cost="3">Cherries</Item>
</ShoppingTrip>
<ShoppingTrip ShoppingTripID="L2">
    <Item>Emeralds</Item>
    <Item>Diamonds</Item>
    <Item>Furniture</Item>
</ShoppingTrip>
</Shopping>'

SELECT 
	tbl.col.value('.', 'varchar(50)') AS Item
	,tbl.col.value('@Cost', 'varchar(50)') AS Cost
FROM @x.nodes('/Shopping/ShoppingTrip/Item') AS tbl(col)

---------------------- XQUERY Nodes - Shredding a table --------------------------------

DECLARE @x XML, @x2 XML
SET @x = '<Shopping ShopperName = "Phillip Burton" Weather = "Nice">
<ShoppingTrip ShoppingTripID="L1">
    <Item Cost="5">Bananas</Item>
    <Item Cost="4">Apples</Item>
    <Item Cost="3">Cherries</Item>
</ShoppingTrip></Shopping>'
SET @x2 =
'<Shopping><ShoppingTrip ShoppingTripID="L2">
    <Item>Emeralds</Item>
    <Item>Diamonds</Item>
    <Item>Furniture</Item>
</ShoppingTrip>
</Shopping>'
DROP TABLE #tblXML
CREATE TABLE #tblXML(pkXML INT PRIMARY KEY, xmlCol XML)

INSERT INTO #tblXML(pkXML, xmlCol) VALUES (1, @x)
INSERT INTO #tblXML(pkXML, xmlCol) VALUES (2, @x2)

SELECT * FROM #tblXML

SELECT 	
	tbl.col.value('@Cost', 'varchar(50)') 
	FROM #tblXML CROSS APPLY xmlCol.nodes('/Shopping/ShoppingTrip/Item') AS tbl(col)