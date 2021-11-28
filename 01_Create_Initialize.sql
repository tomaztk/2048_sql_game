
CREATE OR ALTER PROCEDURE dbo.CREATE_matrix
	
/**************************************************************
Procedure:          dbo.CREATE_Matrix
Create Date:        2021-11-28
Author:             Tomaz Kastrun
Description:        Creates a table that has same number of 
					columns and rows with helped ID column.
					Imitates the matrix function in Py/R.
					Table name is dbo.T_2048 and is used as
					board for the game, each cell is a tile.

Procedure output:	[dbo].[T_2048]
Parameter(s):       @dim - size of the matrix; e.g.: 4 = 4x4 
Usage:              EXEC dbo.CREATE_Matrix
                        @dim = 4
ChangeLog:
************************************************************* */

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


CREATE OR ALTER PROCEDURE dbo.ADD_number

/**************************************************************
Procedure:          dbo.ADD_number
Create Date:        2021-11-28
Author:             Tomaz Kastrun
Description:        Adds number 2 (update) in a cell that  
					holds the value|number 0.

Procedure output:	updates table: [dbo].[T_2048]
Parameter(s):       @dim - size of the matrix; e.g.: 4 = 4x4 
Usage:              EXEC dbo.ADD_number
                        @dim = 4
ChangeLog:
************************************************************* */

	@dim INT
AS
BEGIN
	
DECLARE @nofTry INT = 10*@dim
DECLARE @i INT = 1

WHILE @nofTry > @i
	BEGIN

			declare @a int = 1
			declare @b int = @dim

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


			--- CHECK if 0
			DECLARE @check0 NVARCHAR(1000) = 'SELECT ' +@COL+ ' FROM dbo.T_2048 WHERE ID =' + CAST(@y AS varchar(10))
			PRINT @check0

			DECLARE @temp TABLE (RES INt)

			INSERT INTO @temp
			EXEC sp_executesql @check0


			IF (SELECT res FROM @temp) = 0
				BEGIN
						SET @i = @nofTry
						DECLARE @Sq NVARCHAR(2000) =  
							'UPDATE dbo.T_2048
								SET ' + CAST(@COL AS VARCHAR(100)) + ' = CASE WHEN ' + CAST(@COL AS VARCHAR(100)) + '  = 0 THEN 2  ELSE ' + CAST(@COL AS VARCHAR(100)) + '  END
								WHERE	
									ID = '+CAST(@y AS VARCHAR(100))

							EXEC sp_executesql @Sq
							--RETURN;
				END
		SET @i = @i + 1
	END

END;
GO
