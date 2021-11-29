
SET NOCOUNT ON;
GO

CREATE OR ALTER PROCEDURE dbo.PLAY_game

/**************************************************************
Procedure:          dbo.PLAY_game
Create Date:        2021-11-28
Author:             Tomaz Kastrun
Description:        Reorganize the numbers in table (update)   
					based on the selected direction and add 
					new number 2 in empty tile (where value=0).

Procedure output:	updates table: [dbo].[T_2048]
Parameter(s):       @dim - size of the matrix; e.g.: 4 = 4x4 
					@move - directon of move and calculation.
						  - Possible values: U, D, L, R (Up, Down, Left, Right)
Usage:              EXEC dbo.PLAY_game
						 @move = 'U'
                        ,@dim = 4
ChangeLog:
************************************************************* */

	 @move CHAR(1) 
	,@dim  INT  
AS
BEGIN

BEGIN

	IF @move = 'U'
		BEGIN
			EXEC dbo.MOVE_up @dim;
			EXEC [dbo].[FIND_ADD_number] @dim;
			SELECT * FROM T_2048
		END

	IF @move = 'D'
		BEGIN
			EXEC dbo.MOVE_down @dim;
			EXEC [dbo].[FIND_ADD_number] @dim;
			SELECT * FROM T_2048
		END


	IF @move = 'L'
		BEGIN
			EXEC dbo.MOVE_left @dim;
			EXEC [dbo].[FIND_ADD_number] @dim;
			SELECT * FROM T_2048
		END

	IF @move = 'R'
		BEGIN
			EXEC dbo.MOVE_right @dim;
			EXEC [dbo].[FIND_ADD_number] @dim;
			SELECT * FROM T_2048
		END

END;
GO
