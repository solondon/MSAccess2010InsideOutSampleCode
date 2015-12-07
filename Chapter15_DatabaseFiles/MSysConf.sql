USE Northwind
GO


CREATE TABLE MSysConf(
Config		SMALLINT		NOT NULL,
chValue		VARCHAR(255)	NULL,
nValue		INTEGER			NULL,
Comments	VARCHAR(255)	NULL
)
GO
INSERT INTO MSysConf(Config,nValue,Comments)
VALUES(101,0,
'Prevent storage of the logon ID and password in linked tables.')
GO 

--VALUES(103, 5,
--'number of rows retrieved.') 
--VALUES(101,1,
--'Allow storage of the logon ID and password in linked tables.')
--VALUES(102,1,
--'delay in seconds between each retrieval.')

 
--Note Setting a higher delay time decreases network traffic, 
-- but increases the amount of time that read-locks are left on data 
-- (if the server uses read-locks).

INSERT INTO MSysConf(Config,nValue,Comments)
VALUES(103, 1,
'number of rows retrieved.') 
GO

SELECT * FROM MSysConf
