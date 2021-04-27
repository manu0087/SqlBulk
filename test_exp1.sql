
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

insert t1(c1,c2,c3,c4,c5,c6)
values('va1','va2','va3',getdate(),null,GETDATE()),
	  ('vb1','vb2','vb3',getdate(),null,GETDATE()),
	  ('vc1','vc2','vc3',getdate(),null,GETDATE()),
	  ('vd1','vd2','vd3',getdate(),'asd',GETDATE()),
	  ('ve1','ve2','ve3',null,'',GETDATE())

declare @r varchar(max),
		@i int
		
exec @i=dbo.CLR_Bulk_Exp 'database',
						 'C:\path\',
						 'test_exp1.txt',
						 0,-- 1->UTF8, 2-> UTF8 BOM, 3-> UTF7, 4-> UTF32, altro default 1
						 'select * from t1',--the query i want to export
						 '|',--export delimitator
						 0,--i i want to add at the end of any row the delimitator
						 '.',--decimal char
						 'c6',--the column i need to manage with a particular conversion(only date available)
						 'yyyy_MM_dd',--the format of the column before specified
						 1,--export the heading
						 'free text',--free text that could be possible add
						 0,--where i want to add the text, after or before header?
						 @r output
						
print @i
print @r
