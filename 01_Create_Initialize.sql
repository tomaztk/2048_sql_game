
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CREATE MATRIX (board) for @dim dimension
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE OR ALTER PROCEDURE dbo.CREATE_matrix
	
	@dim INT

AS
BEGIN
	DECLARE @i INT = 1
	DECLARE @j INT = 1

	DECLARE @TableCreate NVARCHAR(2000) = 
	'DROP TABLE IF EXISTS dbo.T_2048; 
	CREATE TABLE dbo.T_2048 (ID INT IDENTITY(1,1), '

	WHILE (@dim >= @i)

	BEGIN
		SET @TableCreate = @TableCreate + 'V' + CAST(@i AS VARCHAR(10)) + ' SMALLINT ,'
		SET @i = @i + 1
	END
	SET @TableCreate = STUFF(@TableCreate, LEN(@TableCreate), 1, ');')

	WHILE (@dim >= @j)
	BEGIN
		SET @TableCreate = @TableCreate + ' 
		INSERT INTO dbo.T_2048 VALUES ('
		+ STUFF(REPLICATE('0,',@dim), LEN(REPLICATE('0,',@dim)), 1, ');') 
		SET @j = @j+1
	END

	EXEC sp_executesql @tableCreate
END;
GO


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CREATE MATRIX (board) for @dim dimension
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE OR ALTER PROCEDURE dbo.INIT_matrix
	@dim INT
AS
BEGIN
	
declare @a int = 1
declare @b int = 4

declare @x int, @y int = 1

SET @x = (SELECT FLOOR(RAND()*(@b-@a+1))+@a)
SET @y = (SELECT FLOOR(RAND()*(@b-@a+1))+@a)

	DECLARE @COL NVARCHAR(100) = (
			SELECT 
				COLUMN_NAME 
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE
					TABLE_NAME = 'T_2048'
				AND TABLE_SCHEMA = 'dbo'
				AND ORDINAL_POSITION = @x+1 )



DECLARE @Sq NVARCHAR(2000) =  
	'UPDATE dbo.T_2048
		SET ' + CAST(@COL AS VARCHAR(100)) + ' = CASE WHEN ' + CAST(@COL AS VARCHAR(100)) + '  = 0 THEN 2  ELSE ' + CAST(@COL AS VARCHAR(100)) + '  END
		WHERE	
			ID = '+CAST(@y AS VARCHAR(100))

	EXEC sp_executesql @Sq

END;
GO