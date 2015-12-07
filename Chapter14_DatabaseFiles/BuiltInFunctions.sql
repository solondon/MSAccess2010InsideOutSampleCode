USE Northwind
GO

DECLARE @SampleString NVARCHAR(250)
SET @SampleString = ' Charlotte forgot her lunch box again '
PRINT LTRIM(RTRIM(@SampleString))				-- remove blanks
PRINT LEN(@SampleString)						-- length
PRINT LOWER(@SampleString)						-- lower case
PRINT UPPER(@SampleString)						-- upper case
PRINT CHARINDEX(@SampleString,'CHARLOTTE',2)	-- substring position
PRINT SUBSTRING(@SampleString,2,9)				-- substring

DECLARE @TheDate DATETIME
SET @TheDate = '4 December 2005'
PRINT DATEADD(d,10,@TheDate)					-- add to a date
select DATEDIFF(year,@TheDate,GETDATE())		-- difference



