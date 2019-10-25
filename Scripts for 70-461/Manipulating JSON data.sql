DECLARE @json NVARCHAR(4000)
SET @json = '
{
"name":"Phillip",
"Shopping":
	{"ShoppingTrip":1,
	 "Items":
	  [
		{"Item":"Bananas","Cost":5},
		{"Item":"Apples","Cost":4},
		{"Item":"Cherries","Cost":3}
	  ]
	 }
}
'
SELECT ISJSON(@json)

--SELECT JSON_VALUE --Returns 1 value
--SELECT JSON_QUERY --Returns an object or an array

--SELECT JSON_QUERY(@json, '$.Shopping.Items')
--SELECT JSON_VALUE(@json, 'strict $.name') --You can avoid Strict but that is giving you error messages related to JSON
--SELECT JSON_VALUE(@json, 'strict $.Shopping.Items[0].Cost')

----------------------JSON_MODIFY----------------------------------
--Three parameters: 
-- a)The JSON that you'll modify
-- b)The path of what you'll modify
-- c)The new value. Remember: for something more complex than a single value, you will need JSON_QUERY

SELECT JSON_MODIFY(@json, 'strict $.Shopping.Items[1].Item', 'Big Apples')
SELECT JSON_MODIFY(@json, '$.Date','2019-10-22')--Avoid strict because you are adding a new value
SELECT JSON_MODIFY(@json, 'strict $.Shopping.Items[0]', JSON_QUERY('{"Item":"Big Bananas","Cost":1}'))

--Converting from JSON to a SQL Table
SELECT * FROM OPENJSON(@json, '$.Shopping.Items')
	WITH (Item varchar(10), Cost INT)

--Converting from a SQL Table to JSON