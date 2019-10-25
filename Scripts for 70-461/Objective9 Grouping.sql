USE [70-461]
GO

------------------------------------------- 148. GROUPING SETS------------------------------------------------------------------

SELECT E.Department, E.EmployeeNumber, A.AttendanceMonth AS AttendanceMonth, SUM(A.NumberAttendance) AS NumberAttendance,
GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
GROUPING_ID(E.Department, E.EmployeeNumber, A.AttendanceMonth) AS EmployeeNumberGroupedID
FROM tblEmployee AS E JOIN tblAttendance AS A
ON E.EmployeeNumber = A.EmployeeNumber
GROUP BY ROLLUP (E.Department, E.EmployeeNumber, A.AttendanceMonth)
ORDER BY CASE WHEN Department IS NULL THEN 1 ELSE 0 END, Department,
		 CASE WHEN E.EmployeeNumber IS NULL THEN 1 ELSE 0 END, E.EmployeeNumber,
		 CASE WHEN AttendanceMonth IS NULL THEN 1 ELSE 0 END, AttendanceMonth

SELECT SUM(A.NUMBERATTENDANCE) FROM TBLATTENDANCE A
JOIN tblEmployee E ON E.EmployeeNumber = A.EmployeeNumber
where e.Department = 'litigation'
--SELECT E.Department, E.EmployeeNumber, A.AttendanceMonth AS AttendanceMonth, SUM(A.NumberAttendance) AS NumberAttendance,
--GROUPING(E.EmployeeNumber) AS EmployeeNumberGroupedBy,
--GROUPING_ID(E.Department, E.EmployeeNumber, A.AttendanceMonth) AS EmployeeNumberGroupedID
--	FROM tblEmployee AS E JOIN tblAttendance AS A
--	ON E.EmployeeNumber = A.EmployeeNumber
--GROUP BY CUBE(E.Department, E.EmployeeNumber, A.AttendanceMonth)
--ORDER BY Department, EmployeeNumber, AttendanceMonth

