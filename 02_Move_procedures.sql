

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



---- --------------------------
---- --------------------------
---- MOVE LEFT Procedure
---- --------------------------
---- --------------------------


CREATE OR ALTER PROCEDURE dbo.MOVE_left
		@dim INT
AS
BEGIN


	DECLARE @row_counter INT = 1 -- Row counter
	--Declare @max_row INT = (SELECT @dim )


	while @dim >= @row_counter
	BEGIN
			
			DECLARE @header NVARCHAR(4000) = ''
			SET @header = 'drop table if exists dbo.tmp
			select
			row_number() over (order by (select 1)) as id
			, v1
			into dbo.tmp
			from (
			select '

			DECLARE @col_names NVARCHAR(4000)  
			SELECT @col_names = COALESCE(@col_names + ' as v1 from T_2048 WHERE ID = '+CAST(@row_counter AS CHAR(10))+ '
			union all
			select ' , '') + COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'T_2048' AND COLUMN_NAME NOT IN ('ID')

 
			DECLARE @foot NVARCHAR(500) =  ''
			SET @foot = ' from T_2048 WHERE ID = '+CAST(@row_counter AS CHAR(10))+'
			) as x
			'
			DECLARE @sql NVARCHAR(4000) = ''

			SET @sql = @header + @col_names + @foot
			print @sql 

			EXEC sp_executesql @sql

				DECLARE @ii int = 1
				WHILE @dim - 1  >= @ii
					BEGIN
								declare @i int = @dim -- dimenzija
								while 1 < @i
									begin	
										declare @vv_1 int = (select v1 from dbo.tmp where id = @i)
										declare @vv_2 int = (select v1 from dbo.tmp where id = @i-1)

									IF (@vv_1 = 0 AND @vv_2 <> 0)
									BEGIN
										update dbo.tmp set v1 = @vv_2 where id = @i
										update dbo.tmp set v1 = 0     where id = @i-1
									END

									IF (@vv_1 <> 0 AND @vv_1 = @vv_2)
								
									BEGIN
										update dbo.tmp set v1 = @vv_1 + @vv_2 where id = @i
										update dbo.tmp set v1 = 0 where id = @i-1
									END

								set @i = @i - 1
					END
	 
				  set @ii = @ii + 1
				END


				-- final update to table T_2048
				DECLARE @y int = 1

				WHILE @y <= @dim -- variable dim
					BEGIN

					declare @val int = (select v1 from dbo.tmp where id = @y)

					declare @s nvarchar(500)
					set @s = 'UPDATE dbo.T_2048
								set v' + CAST(@y AS VARCHAR(10)) + '= ' + CAST(@val AS VARCHAR(10)) + '
								WHERE ID = ' + CAST(@row_counter AS VARCHAR(10))
								

						EXEC sp_executesql @s

						set @y = @y + 1
					END
				
      
	 	SET @row_counter = @row_counter + 1
		SET @header = NULL
		SET @col_names = NULL
		SET @foot = NULL
		SET @sql = NULL
	END

 END;
 GO

---- --------------------------
---- --------------------------
---- MOVE RIGHT Procedure
---- --------------------------
---- --------------------------



CREATE OR ALTER PROCEDURE dbo.MOVE_right
		@dim INT
AS
BEGIN


	DECLARE @row_counter INT = 1 -- Row counter
	--Declare @max_row INT = (SELECT @dim )


	while @dim >= @row_counter
	BEGIN
			
			DECLARE @header NVARCHAR(4000) = ''
			SET @header = 'drop table if exists dbo.tmp
			select
			row_number() over (order by (select 1)) as id
			, v1
			into dbo.tmp
			from (
			select '

			DECLARE @col_names NVARCHAR(4000)  
			SELECT @col_names = COALESCE(@col_names + ' as v1 from T_2048 WHERE ID = '+CAST(@row_counter AS CHAR(10))+ '
			union all
			select ' , '') + COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'T_2048' AND COLUMN_NAME NOT IN ('ID')

 
			DECLARE @foot NVARCHAR(500) =  ''
			SET @foot = ' from T_2048 WHERE ID = '+CAST(@row_counter AS CHAR(10))+'
			) as x
			'
			DECLARE @sql NVARCHAR(4000) = ''

			SET @sql = @header + @col_names + @foot
			print @sql 

			EXEC sp_executesql @sql

				DECLARE @ii int = 1
				WHILE @dim - 1  >= @ii
					BEGIN
								declare @i int = 1
								while @dim > @i
									begin	
										declare @vv_1 int = (select v1 from dbo.tmp where id = @i)
										declare @vv_2 int = (select v1 from dbo.tmp where id = @i+1)

									IF (@vv_1 = 0 AND @vv_2 <> 0)
									BEGIN
										update dbo.tmp set v1 = @vv_2 where id = @i
										update dbo.tmp set v1 = 0     where id = @i+1
									END

									IF (@vv_1 <> 0 AND @vv_1 = @vv_2)
								
									BEGIN
										update dbo.tmp set v1 = @vv_1 + @vv_2 where id = @i
										update dbo.tmp set v1 = 0 where id = @i+1
									END

								set @i = @i + 1
					END
	 
				  set @ii = @ii + 1
				END


				-- final update to table T_2048
				DECLARE @y int = 1

				WHILE @y <= @dim -- variable dim
					BEGIN

					declare @val int = (select v1 from dbo.tmp where id = @y)

					declare @s nvarchar(500)
					set @s = 'UPDATE dbo.T_2048
								set v' + CAST(@y AS VARCHAR(10)) + '= ' + CAST(@val AS VARCHAR(10)) + '
								WHERE ID = ' + CAST(@row_counter AS VARCHAR(10))
								

						EXEC sp_executesql @s

						set @y = @y + 1
					END
				
      
	 	SET @row_counter = @row_counter + 1
		SET @header = NULL
		SET @col_names = NULL
		SET @foot = NULL
		SET @sql = NULL
	END

 END;
 GO


