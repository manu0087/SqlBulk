
/************

1 - copy the dll in a path where Sql can access (ex: c:\temp\) and replace the value of @path with this
2 - replace [database] with your db
3 - to run "first step" you need sa grant

************/


use [database]

--first step - begin

alter database [database] set trustworthy on;
go

sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
sp_configure 'clr enabled', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO

--first step - end

IF EXISTS (
SELECT * FROM dbo.sysobjects 
WHERE id = object_id (N'[dbo].[CLR_Bulk_mt]') )

DROP PROCEDURE [dbo].[CLR_Bulk_mt];

GO
IF EXISTS (
SELECT * FROM dbo.sysobjects 
WHERE id = object_id (N'[dbo].[CLR_Bulk_mt_xls]') )

DROP PROCEDURE [dbo].[CLR_Bulk_mt_xls];

GO
IF EXISTS (
SELECT * FROM dbo.sysobjects 
WHERE id = object_id (N'[dbo].[CLR_Bulk_Exp]') )

DROP PROCEDURE [dbo].[CLR_Bulk_Exp];

GO
------------------------------------------
------------------------------------------

declare @path varchar(max)='c:\path\'
--------------------------


IF EXISTS (
SELECT * FROM sys.assemblies 
WHERE name = 'SqlBulk' )
DROP ASSEMBLY SqlBulk;

IF EXISTS (
SELECT * FROM sys.assemblies 
WHERE name = 'functions' )
DROP ASSEMBLY [functions];

IF EXISTS (
SELECT * FROM sys.assemblies 
WHERE name = 'excel' )
DROP ASSEMBLY excel;


CREATE ASSEMBLY excel
FROM @path+'excel.dll'
with PERMISSION_SET=unsafe

CREATE ASSEMBLY [SqlBulk]
--AUTHORIZATION dbo
FROM @path+'SqlBulk.dll'
with PERMISSION_SET=unsafe
 
GO
PRINT N'Creating [dbo].[CLR_Bulk_MT]...';
go

CREATE PROCEDURE [dbo].[CLR_Bulk_MT]
--@server NVARCHAR (max), 
@db NVARCHAR (max), 
@schema NVARCHAR (max), 
@table NVARCHAR (max), 
@path NVARCHAR (max), 
@file NVARCHAR (max), 
@encoding int=1, 
@first_row int, 
@delimitator NCHAR (1), 
@decimale NCHAR (1), 
@trace NVARCHAR (max), 
@positions NVARCHAR (max), 
@options NVARCHAR (max), 
@allow_blank NVARCHAR (max), 
@heading BIT, 
@buffer_row INT, 
@trans BIT, 
@use_min_columns BIT, 
@error NVARCHAR (max) OUTPUT
AS EXTERNAL NAME SqlBulk.[CLR_Bulk_MT.SqlBulk].[CLR_Bulk_MT]

GO
PRINT N'Creating [dbo].[CLR_Bulk_MT_xls]...';


GO
CREATE PROCEDURE [dbo].[CLR_Bulk_MT_xls]
--@server NVARCHAR (max), 
@db NVARCHAR (max), 
@schema NVARCHAR (max), 
@table NVARCHAR (max), 
@path NVARCHAR (max), 
@file NVARCHAR (max),
@sheet int, @first_row int, 
@decimale NCHAR (1), 
@tracciato NVARCHAR (max), 
@positions NVARCHAR (max), 
@options NVARCHAR (max), 
@allow_blank NVARCHAR (max), 
@intestazione BIT, 
@buffer_row INT, 
@trans BIT, 
@use_min_columns BIT, 
@error NVARCHAR (max) OUTPUT
AS EXTERNAL NAME SqlBulk.[CLR_Bulk_MT_xls.SqlBulk].[CLR_Bulk_MT_xls]

GO

PRINT N'Creating [dbo].[CLR_Bulk_Exp_1]...';
go
CREATE PROCEDURE [dbo].[CLR_Bulk_Exp]
@db NVARCHAR (max), 
@path NVARCHAR (max), 
@file NVARCHAR (max), 
@encoding int,--=0, 
@query NVARCHAR (max), 
@delimitator NVARCHAR (1), 
@delimitator_last BIT,--=0, 
@decimale NCHAR (1), 
@tracciato NVARCHAR (max), 
@options NVARCHAR (max),--='', 
@intestazione BIT, 
@testo NVARCHAR (max),--='', 
@testo_after_int BIT,--=0, 
@error NVARCHAR (max) OUTPUT
AS EXTERNAL NAME SqlBulk.[CLR_Bulk_Exp.SqlBulk].[CLR_Bulk_Exp]

go
