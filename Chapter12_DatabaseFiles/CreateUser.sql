

-- Create a test login account in Master
CREATE LOGIN TestUser WITH PASSWORD = 'TestAzureAccount444333222'
GO

-- Create a user account
CREATE USER TestUser FROM LOGIN TestUser

-- Assign user to a database role
EXEC sp_addrolemember 'db_owner', 'TestUser'