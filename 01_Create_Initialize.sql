
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


CREATE OR ALTER PROCEDURE dbo.FIND_ADD_number
/**************************************************************
Procedure:          dbo.FIND_ADD_number
Create Date:        2021-11-29
Author:             Tomaz Kastrun
Description:        Adds number 2 (update) in a cell that  
					holds the value|number 0.

Procedure output:	updates table: [dbo].[T_2048]
Parameter(s):       @dim - size of the matrix; e.g.: 4 = 4x4 
Usage:              EXEC dbo.ADD_FIND_ADD_numbernumber
                        @dim = 4
ChangeLog:
************************************************************* */

	@dim INT

AS
BEGIN

		DECLARE @row INT = 1
		DECLARE @col int = 1

		declare @zeros table (id int identity(1,1), row_n int, col_n int, val int)

		while @row <= @dim
		BEGIN
			while @col <= @dim
			BEGIN
				DECLARE @s NVARCHAR(1000) 
				SET @s = 'SELECT CAST(v' + CAST(@col AS varchar(10)) + ' AS INT) as v FROM T_2048 WHERE id = ' + CAST(@row AS varchar(10))
		
				CREATE TABLE #res (val int)
				insert into #res 
				exec sp_executesql @s
	
				insert into @zeros
				SELECT @row AS row_n
					,@col AS col_n
					,(SELECT CAST(val as int) FROM #res) AS val


				SET @col = @col + 1
				DROP TABLE IF EXISTS #res
			END
			SET @col = 1
			SET @row = @row + 1
		END

					-- All the numbers
					-- Get position for 0 
					DECLARE @id INT =  (  SELECT top 1  ID FROM @zeros WHERE val = 0 order by NEWID() )
					PRINT @id
			
					DECLARE @new_col VARCHAR(10) = (SELECT 'V' + cast(col_n as varchar(10)) FROM @zeros WHERE id = @id)
					DECLARE @new_row INT = (SELECT row_n FROM @zeros WHERE id = @id)

					print @new_col
					print @new_row

					IF ( SELECT COUNT(*)  ID FROM @zeros WHERE val = 0) > 0
									BEGIN
						
											DECLARE @Sq NVARCHAR(2000) =  
												'UPDATE dbo.T_2048
													SET ' + CAST(@new_col AS VARCHAR(100)) + ' =  2
													WHERE	
														ID = '+CAST(@new_row AS VARCHAR(100))

												EXEC sp_executesql @Sq
					
									END
									ELSE
									BEGIN
										SELECT 'Game over'
										DROP TABLE IF EXISTS dbo.T_2048;
									END	


END;
GO
