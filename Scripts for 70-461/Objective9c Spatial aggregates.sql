--BEGIN TRAN

--CREATE TABLE tblGeom
--(
--	GXY GEOMETRY,
--	Description VARCHAR(30),
--	IDtblGeom INT CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(1,1))

--	INSERT INTO tblGeom
--	VALUES (GEOMETRY::STGeomFromText('POINT (3 4)', 0),'First Point'),
--		   (GEOMETRY::STGeomFromText('POINT (3 5)', 0),'First Point'),
--		   (GEOMETRY::Point(4, 6, 0), 'Third Point'),
--		   (GEOMETRY::STGeomFromText('MULTIPOINT ((1 2), (2 3), (3 4))', 0), 'Three Points')

--SELECT * FROM tblGeom

--SELECT IDtblGeom, GXY.STGeometryType() AS MyType
--, GXY.STStartPoint().ToString() AS StartingPoint --In case of a single point, maybe this functions look useless, but
--, GXY.STEndPoint().ToString() AS EndingPoint	 --check the result for multipoint. In that case, you can see the
--, GXY.STPointN(1).ToString() AS FirstPoint		 --specification of each function -first, second, starting...
--, GXY.STPointN(2).ToString() AS SecondPoint
--, GXY.STPointN(1).STX AS FirstPointX
--, GXY.STPointN(1).STY AS FirstPointY
--, GXY.STNumPoints() AS NumberPoints
--FROM tblGeom

----ROLLBACK TRAN

--DECLARE @g AS GEOMETRY
--DECLARE @h AS GEOMETRY

--SELECT @g = GXY FROM tblGeom WHERE IDtblGeom = 1
--SELECT @h = GXY FROM tblGeom WHERE IDtblGeom = 3
--SELECT @g.STDistance(@h) AS MyDistance

--SELECT @g, 'Point 1'
--UNION ALL
--SELECT @h, 'Point 2'

--ROLLBACK TRAN

--------------------------LINE, POLYGON, CIRCLES----------------------------------------
--BEGIN TRAN
--CREATE TABLE tblGeom
--(GXY GEOMETRY,
--DESCRIPTION VARCHAR(20),
--IDtblGeom INT CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))

--INSERT INTO tblGeom
--VALUES (GEOMETRY::STGeomFromText('LINESTRING (1 1, 5 5)', 0), 'First line'),
--	   (GEOMETRY::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0), 'Second line'),
--	   (GEOMETRY::STGeomFromText('MULTILINESTRING((1 5, 2 6), (1 4, 2 5))', 0), 'Third line'),
--	   (GEOMETRY::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
--	   (GEOMETRY::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Circle')

--SELECT IDtblGeom, GXY.STGeometryType() AS MyType
--, GXY.STStartPoint().ToString() AS StartingPoint --In case of a single point, maybe this functions look useless, but
--, GXY.STEndPoint().ToString() AS EndingPoint	 --check the result for multipoint. In that case, you can see the
--, GXY.STPointN(1).ToString() AS FirstPoint		 --specification of each function -first, second, starting...
--, GXY.STPointN(2).ToString() AS SecondPoint
--, GXY.STPointN(1).STX AS FirstPointX
--, GXY.STPointN(1).STY AS FirstPointY
--, GXY.STNumPoints() AS NumberPoints
--, GXY.STBoundary().ToString() AS Boundary
--, GXY.STLength() AS MyLength
--, GXY.STNumPoints() AS NumberPoints
--FROM tblGeom

--DECLARE @g AS GEOMETRY
--SELECT @g = GXY FROM tblGeom WHERE IDtblGeom = 5

--SELECT IDtblGeom, GXY.STIntersection(@g).ToString() AS Intersection
--, GXY.STDistance(@g) AS DistanceFromFirstLine
--FROM tblGeom

--SELECT GXY.STUnion(@g), DESCRIPTION --It will take the description of the number 8 object
--FROM tblGeom
--WHERE IDtblGeom = 8

--ROLLBACK TRAN

--BEGIN TRAN

--CREATE TABLE tblGeog
--(GXY GEOGRAPHY,
--DESCRIPTION VARCHAR(30),
--IDtblGeog INT CONSTRAINT PK_tblGeog PRIMARY KEY IDENTITY(1,1))

--INSERT INTO tblGeog
--VALUES (GEOGRAPHY::STGeomFromText('POINT (-73.993492 40.750525)', 4326), 'Madison Square Garden, NY'), --SRID (spatial refrence id), instead of "0" is 4326 
--	   (GEOGRAPHY::STGeomFromText('POINT (-0.177452 51.500905)', 4326), 'Royal Albert Hall, London'),
--	   (GEOGRAPHY::STGeomFromText('LINESTRING (-73.993492 40.750525, -0.177452 51.500905)', 4326), 'Connection')

--SELECT * FROM tblGeog

--DECLARE @g AS GEOGRAPHY
--SELECT @g = GXY FROM tblGeog WHERE IDtblGeog = 1

------------------------------------------------SPATIAL AGGREGATES-----------------------------------------------------------------------


BEGIN TRAN
CREATE TABLE tblGeom
(GXY GEOMETRY,
DESCRIPTION VARCHAR(20),
IDtblGeom INT CONSTRAINT PK_tblGeom PRIMARY KEY IDENTITY(5,1))

INSERT INTO tblGeom
VALUES (GEOMETRY::STGeomFromText('LINESTRING (1 1, 5 5)', 0), 'First line'),
	   (GEOMETRY::STGeomFromText('LINESTRING (5 1, 1 4, 2 5, 5 1)', 0), 'Second line'),
	   (GEOMETRY::STGeomFromText('MULTILINESTRING((1 5, 2 6), (1 4, 2 5))', 0), 'Third line'),
	   (GEOMETRY::STGeomFromText('POLYGON ((4 1, 6 3, 8 3, 6 1, 4 1))', 0), 'Polygon'),
	   (GEOMETRY::STGeomFromText('POLYGON ((5 2, 7 2, 7 4, 5 4, 5 2))', 0), 'Second Polygon'),
	   (GEOMETRY::STGeomFromText('CIRCULARSTRING (1 0, 0 1, -1 0, 0 -1, 1 0)', 0), 'Circle')

--SELECT *, GXY.Filter(GEOMETRY::Parse('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))')) FROM tblGeom
--UNION ALL
--SELECT GEOMETRY::STGeomFromText('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))', 0),'Filter', 0, 0

--SELECT * FROM tblGeom WHERE GXY.Filter(GEOMETRY::Parse('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))')) = 1

--SELECT * FROM tblGeom WHERE GXY.Filter(GEOMETRY::Parse('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))')) = 1
--UNION ALL
--SELECT GEOMETRY::STGeomFromText('POLYGON((2 1, 1 4, 4 4, 4 1, 2 1))', 0),'Filter', 0

DECLARE @i AS GEOMETRY
SELECT @i = GEOMETRY::UnionAggregate(GXY)
FROM tblGeom

SELECT @i AS CombinedShapes

DECLARE @j AS GEOMETRY

SELECT @j = GEOMETRY::CollectionAggregate(GXY) FROM tblGeom

SELECT @j

SELECT @i AS CombinedShapes
UNION ALL
SELECT GEOMETRY::EnvelopeAggregate(GXY).ToString() AS Envelope FROM tblGeom
UNION ALL
SELECT GEOMETRY::ConvertHullAggregate(GXY).ToString() AS Envelope FROM tblGeom

ROLLBACK TRAN