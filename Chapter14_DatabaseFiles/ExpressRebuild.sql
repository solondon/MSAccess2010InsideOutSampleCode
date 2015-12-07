--------------------------------------------------------------------------------------------------------------
-- SQL Express Maintenance Plan
-- Version 1.0
-- author : Andrew Couch
--
-- This script file has been developed to enable an SQL Express system to execute a number
-- of steps equivalent to running a maintenance plan
-- The script is provided FREE, and we accept NO responsibility for any advese effects on
-- your application or business from executing this code.
-- By running this script you accept full responsibility for any adverse effects.
-- As this is Version 1.0 development is at an early stage, and so feel free to make any comments
-- regarding improving this script.
-------------------------------------------------------------------------------------------------------------------

--  READ THE CODE AND COMMENTS BELOW BEFORE EXECUTING THIS CODE!!!!!

-- before the backup step at the end of the script can be executed, you will need to add
-- a dump device, and modify the final lines of this script to refer to the device
-- Create a backup directory file, for example C:\SQLBackups\
-- Then execute the line below to create the backup device, ie. northwinddata
-- You must be in master, with admin rights to do this, see code below.
-- The line
-- Then go to the bottom of this script file

/*
USE master
GO
--To Remove Device if required
sp_dropdevice 'northwinddata'
--To Create Devices
EXEC sp_addumpdevice 'disk', 'northwinddata', 
'C:\SQLBackups\northwinddata.bak'
-- To See Devices
SELECT * FROM sys.backup_devices
*/

-- >>>>>>>>>>>>>>>>>>>CHANGE THIS TO USE YOUR DATABASE

USE northwind

-- find all the tables in the database
-- and rebuild all the indexes on each table
-- also run the database consistency checker on each table
DECLARE @TargetDatabase AS VARCHAR(50) 
DECLARE @FillFactor AS INT
DECLARE @TableSchema as Sysname
DECLARE @TableName AS sysname
DECLARE @Command AS VARCHAR(200)
-- Set the table fill factor
SET @FillFactor = 80
PRINT 'REBUILDING ALL INDEXES AND RUNNING CHECK ON TABLES'
PRINT '-------------------------------------------------------------------------'
DECLARE reb_cursor  CURSOR
FOR
SELECT TABLE_SCHEMA,TABLE_NAME FROM 
	INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'
OPEN reb_cursor
FETCH NEXT FROM reb_cursor INTO @TableSchema, @TableName
WHILE @@FETCH_STATUS <> -1
BEGIN
	IF @@FETCH_STATUS <> -2
	BEGIN
		PRINT @TableSchema + ' - ' + @TableName
		SET @Command = 'ALTER INDEX ALL ON [' + @TableSchema + 
			'].[' + @TableName + 
			'] REBUILD WITH (FILLFACTOR =' + 
			CAST(@Fillfactor AS VARCHAR(10)) + ');'
		EXEC (@Command);
		SET @Command = 'DBCC CHECKTABLE ("[' + @TableSchema + 
			'].[' + @TableName + ']")'
		EXEC (@Command);
	END
	FETCH NEXT FROM reb_cursor INTO @TableSchema, @TableName
END
CLOSE reb_cursor
DEALLOCATE reb_cursor
PRINT '-------------------------------------------------------------------------'
GO

-- If you do not want to run a backup or shrink the files the comment out the code that follows

--SHRINK DATABASE
DECLARE @fileid as INT
DECLARE @Command AS VARCHAR(200)
PRINT 'SHRINKING ALL FILES'
PRINT '-------------------------------------------------------------------------'
DECLARE file_cursor  CURSOR
FOR
SELECT file_id FROM sys.database_files
OPEN file_cursor
FETCH NEXT FROM file_cursor INTO @fileid
WHILE @@FETCH_STATUS <> -1
BEGIN
	IF @@FETCH_STATUS <> -2
	BEGIN
		PRINT @fileid
		SET @Command = 'DBCC SHRINKFILE (' + CAST(@fileid AS VARCHAR(10)) + ')'
		EXEC (@Command);
	END
	FETCH NEXT FROM file_cursor INTO @fileid
END
CLOSE file_cursor
DEALLOCATE file_cursor
PRINT '-------------------------------------------------------------------------'
GO
/* 
-- BACKUP DATABASE & TRUNCATE THE LOGFILE
-- This assumes simple recovery model and just truncates the log file
PRINT 'BACKING UP DATABASE AND LOG FILE'
PRINT '-------------------------------------------------------------------------'
DECLARE @DatabaseName AS VARCHAR(200)
SELECT @DatabaseName = [Name] from sys.database_files WHERE type_desc = 'rows'
-- >>>>>>>>>>>>>THEN NEXT 2 LINES NEED CHANGED, for northwinddata, substitute the name of your
-- backup device
BACKUP DATABASE @DatabaseName TO northwinddata
RESTORE FILELISTONLY  FROM northwinddata
PRINT '-------------------------------------------------------------------------'
GO
*/

