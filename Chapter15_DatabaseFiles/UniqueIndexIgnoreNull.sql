USE [NorthwindSQL]
GO

CREATE INDEX idxEmployee ON Employees(EmploymentCode)
GO
CREATE TRIGGER TR_Employees_EmploymentCode
ON Employees
FOR INSERT,UPDATE
AS
IF EXISTS( SELECT COUNT(*),EmploymentCode FROM Employees
		   WHERE EmploymentCode is NOT NULL
		   GROUP BY EmploymentCode
           HAVING COUNT(*) > 1)
           ROLLBACK TRAN
       
GO

-- Test this
UPDATE Employees
SET EmploymentCode = 'N1123'
WHERE EmploymentCode ='N1156'

        