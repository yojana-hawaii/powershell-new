
USE [master]
GO
if exists (select * from sys.databases where name=N'inventory')
begin
	alter database inventory set single_user with rollback immediate;
	drop database if exists inventory;
end
GO

/*Create database --> change owner*/

CREATE DATABASE inventory
	CONTAINMENT = NONE
ON  PRIMARY    
	( NAME = N'inventory', 
		FILENAME = N'E:\Data\inventory.mdf' , 
		SIZE = 1024, 
		MAXSIZE = 10240MB, 
		FILEGROWTH = 10% )
	LOG ON 
	( NAME = N'inventory_log', 
		FILENAME = N'F:\Logs\inventory_log.ldf' , 
		SIZE =  5, 
		MAXSIZE = 2048MB , 
		FILEGROWTH = 5)
GO

ALTER AUTHORIZATION ON DATABASE::inventory to sa;
GO

USE [inventory]
if not exists(select * from sys.database_principals where name = 'KPHC\powershell')
begin
	CREATE USER [KPHC\powershell] FOR LOGIN [KPHC\powershell] WITH DEFAULT_SCHEMA=[dbo]
	ALTER ROLE [db_owner] ADD MEMBER [KPHC\powershell]
end
GO


USE [master]
GO
ALTER DATABASE inventory SET  READ_WRITE 
GO



