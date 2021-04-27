
use [database]
go

if OBJECT_ID(N't1') IS NOT NULL
begin
	drop table t1
end

create table t1
(
	c1 varchar(50),
	c2 varchar(50),
	c3 varchar(50),
	c4 date,
	c5 varchar(50),
	c6 date not null
)

declare @r varchar(max),
		@i int
		
exec @i=dbo.CLR_Bulk_mt 'database',
						'dbo',
						't1',
						'c:\path\',
					    'test_imp1.txt',
						0,-- 1->UTF8, 2-> UTF8 BOM, 3-> UTF7, 4-> UTF32, other default 1
						0,--first row, where begin to read rows
					    '|',--delimitator
						'.',--decimal separator of number in the file
						'c3,c2,c1,c4,c6',--column mapping. not necessary. if not defined uses all table columns. if defined you could use same columns and with a different order.
						'3,2,1,3,3',--column order. not necessary. if not defined uses the file column order. id defined you could change column place.
						',,,yyyyMMdd,yyyyMMdd',--you could define wich is the date format for each column (with ',' separator) or one for all (just define on without any sepatator) or nothing to use system setting. (remember! destination column should be a date/datetime type!!!)
						'false,false,true,true,true',--destination column allows null values? if yes, blank values will be null, if not leaved blank. if you set true and blank are found a exception is throw.
						1,--there is the header in the file?
						0,--buffer value to inmprove performance. you need to try same test to find it!
						0,--do yo uneed to use transaction? if yes, in case of error, nothing will be imported
						1,--rows have always the same number of columns? if no, you can set 1 to manage the case a row has less columns than the others. at the end will go to next row.
						@r output
						
print @i
print @r
