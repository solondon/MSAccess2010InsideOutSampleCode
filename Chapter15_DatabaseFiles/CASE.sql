Use Northwind
GO

CREATE TABLE Months(
MonthID			INT PRIMARY KEY,
TheMonthName	NVARCHAR(15)
)
GO
INSERT INTO Months(MonthID,TheMonthName)
VALUES(1,'January'),(2,'February'),(3,'March'),(4,'April'),
(5,'May'),(6,'June'),(7,'July'),(8,'August'),
(9,'September'),(10,'October'),(11,'November'),
(12,'December')
GO
-- Simple Case
SELECT MonthID , TheMonthName,
	Simplecase =
	CASE MonthID
		WHEN 1  THEN 'January'
		WHEN 2  THEN 'February'
		WHEN 3  THEN 'March'
		WHEN 4  THEN 'April'
		WHEN 5  THEN 'May'
		WHEN 6  THEN 'June'
		WHEN 7  THEN 'July'
		WHEN 8  THEN 'August'
		WHEN 9  THEN 'September'
		WHEN 10  THEN 'October'
		WHEN 11  THEN 'November'
		WHEN 12  THEN 'December'
	Else 'Unknown'
	END
FROM Months
GO

-- Searched Case
SELECT MonthID , TheMonthName,
	SearchedCase =
	CASE 
		WHEN MonthID IN(1,2,3) THEN 'First Quarter'
		WHEN  MonthID IN(4,5,6) THEN 'Second Quarter'
		WHEN  MonthID IN(7,8,9)  THEN 'Third Quarter'
		WHEN  MonthID IN(10,11,12) THEN ' Fourth Quarter'
	Else 'Unknown'
	END
FROM Months
GO