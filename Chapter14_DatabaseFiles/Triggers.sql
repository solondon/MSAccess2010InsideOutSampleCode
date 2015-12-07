-- Triggers
USE [Northwind]
GO

-- Trigger to update a column recording
-- when and by whom the record was last update

ALTER TABLE Customers
ADD LastUpdatedOn DATETIME 
CONSTRAINT DefCustomersLastUpdatedOn DEFAULT GetDate()
GO

ALTER TABLE Customers
ADD LastUpdatedBy NVARCHAR(120)
CONSTRAINT DefCustomersLastUpdatedBy DEFAULT SUSER_SNAME()
GO

CREATE TRIGGER Tr_CustomerRowAudit_Update
ON Customers
FOR UPDATE
AS
UPDATE Customers
	SET LastUpdatedOn = GETDATE(), 
	LastUpdatedBy = SUSER_NAME()
FROM Customers 
	INNER JOIN DELETED 
		ON Customers.CustomerID = DELETED.CustomerID
GO

-- Trigger to record a mirror image of the row
-- in an auditing table
-- Create a table to record the mirror image
SELECT * INTO audit_Customers
FROM Customers
WHERE CustomerID IS NULL
GO

-- Add a field to indicate the auditing operation
-- U for Update and D for Delete
ALTER TABLE audit_Customers
ADD Operation NVARCHAR(1)
GO
-- Record the old image of the data
CREATE Trigger TR_CustomerRowAudit_Delete
ON Customers
FOR DELETE
AS
INSERT INTO audit_Customers
SELECT *,'D' FROM DELETED
GO
ALTER Trigger TR_CustomerRowAudit_Update
ON Customers
FOR UPDATE
AS
UPDATE Customers
	SET LastUpdatedOn = GETDATE(), 
	LastUpdatedBy = SUSER_NAME()
FROM Customers 
	INNER JOIN DELETED 
		ON Customers.CustomerID = DELETED.CustomerID
INSERT INTO audit_Customers
SELECT *,'U' FROM DELETED
GO

-- Now we could edit a record and check the contents
-- of the audit table
SELECT * FROM audit_Customers
GO

-- Example of ROLLBACK preventing inserts or deletes
CREATE Trigger Tr_Categories_INSERTDELETE
ON Categories
FOR INSERT,DELETE
AS
	ROLLBACK TRAN
GO

-- Example of a Trigger preventing
-- any changes to a specific column for existing records
CREATE Trigger Tr_Products_ProductName
ON Products
FOR UPDATE
AS
IF UPDATE([ProductName])
	ROLLBACK TRAN
GO
