

---- --------------------------
---- --------------------------
---- MOVE UP Procedure
---- --------------------------
---- --------------------------

CREATE OR ALTER PROCEDURE dbo.MOVE_up
		@dim INT
AS
BEGIN



	DECLARE @Column_counter INT = 2
	Declare @max_column INT = (SELECT @dim /* dim */ + 2)


	while @max_column > @Column_counter
	BEGIN
		-- Get first column name
		DECLARE @col_name VARCHAR(10) = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'T_2048' and ORDINAL_POSITION = @Column_counter)
		print @col_name

		DECLARE @sql1 NVARCHAR(2000) =
		'SELECT  id, ' + @col_name + ' as v FROM T_2048'

		DROP TABLE IF EXISTS #temp;
		create table  #temp (id int, v int)
	
		insert into #temp
		EXEC sp_executesql @sql1

		--SELECT * FROM #temp
		/* premik */

		---------------------------------------
					-- UP scenarij
						DECLARE @ii int = 1
						while @dim-1 >= @ii -- število dimenzij
						BEGIN
							declare @i int = 1

							while @dim > @i -- 
							--declare @i int = 1 
							begin	
								declare @vv_1 int = (select v from #temp where id = @i)
								declare @vv_2 int = (select v from #temp where id = @i+1)

							IF (@vv_1 = 0 AND @vv_2 <> 0)
							BEGIN
								update #temp set v = @vv_2 where id = @i   
								update #temp set v = 0     where id = @i+1 
							END

							IF (@vv_1 <> 0 AND @vv_1 = @vv_2)
							BEGIN
								update #temp set v = @vv_1 + @vv_2 where id = @i
								update #temp set v = 0 where id = @i+1
							END

							IF (@vv_1 <> 0 AND @vv_2  = 0) 
							BEGIN
								Print 'Do nothing'
							END

							set @i = @i + 1
							end
						  set @ii = @ii + 1
						END

				-- update back to T_2048 table from #temp table

				DECLARE @sql_temp_update NVARCHAR(500)

				SET @SQL_temp_update = 
				'UPDATE T20
					SET '+@col_name+' = t.v
			
				FROM t_2048  AS T20
				JOIN #temp AS t
				ON T20.id = t.id'
			
				EXEC sp_executesql @SQL_temp_update

		----------------------------------------

		SET @Column_counter = @Column_counter + 1

		-- END; Show T_2048
	

	   END
END;
GO


---- --------------------------
---- --------------------------
---- MOVE DOWN Procedure
---- --------------------------
---- --------------------------


CREATE OR ALTER PROCEDURE dbo.MOVE_down
		@dim INT
AS
BEGIN

	DECLARE @Column_counter INT = 2
	Declare @max_column INT = (SELECT @dim /* dim */ + 2)


	while @max_column > @Column_counter
	BEGIN
		-- Get first column name
		DECLARE @col_name VARCHAR(10) = (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'T_2048' and ORDINAL_POSITION = @Column_counter)
		print @col_name

		DECLARE @sql1 NVARCHAR(2000) =
		'SELECT  id, ' + @col_name + ' as v FROM T_2048'

		DROP TABLE IF EXISTS #temp;
		create table  #temp (id int, v int)
	
		insert into #temp
		EXEC sp_executesql @sql1

		--SELECT * FROM #temp
		/* premik */

		---------------------------------------
					-- DOWN scenarij

						DECLARE @ii int = 1
						while @dim-1 >= @ii -- število dimenzij
						BEGIN
							declare @i int = @dim

							while 1 < @i  
							begin	
								declare @vv_1 int = (select v from #temp where id = @i)
								declare @vv_2 int = (select v from #temp where id = @i-1)

							IF (@vv_1 = 0 AND @vv_2 <> 0)
							BEGIN
								update #temp set v = @vv_2 where id = @i   
								update #temp set v = 0     where id = @i-1 
							END

							IF (@vv_1 <> 0 AND @vv_1 = @vv_2)
							BEGIN
								update #temp set v = @vv_1 + @vv_2 where id = @i
								update #temp set v = 0 where id = @i-1
							END

							IF (@vv_1 <> 0 AND @vv_2  = 0) 
							BEGIN
								Print 'Do nothing'
							END

							set @i = @i - 1
							end
						  set @ii = @ii + 1
						END

				-- update back to T_2048 table from #temp table

				DECLARE @sql_temp_update NVARCHAR(500)

				SET @SQL_temp_update = 
				'UPDATE T20
					SET '+@col_name+' = t.v
			
				FROM t_2048  AS T20
				JOIN #temp AS t
				ON T20.id = t.id'
			
				EXEC sp_executesql @SQL_temp_update

		----------------------------------------

		SET @Column_counter = @Column_counter + 1

		-- END; Show T_2048
	

	   END
END;
GO
