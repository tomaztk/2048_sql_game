
CREATE OR ALTER PROCEDURE dbo.PLAY_game
	 @move CHAR(1) -- U, D, L, R (Up, Down, Left, Right)
	,@dim  INT  -- size of the matrix
AS
BEGIN

	IF @move = 'U'
		BEGIN
			EXEC dbo.MOVE_up @dim;
            EXEC [dbo].[ADD_number] @dim;
			SELECT * FROM T_2048
		END

	IF @move = 'D'
		BEGIN
			EXEC dbo.MOVE_down @dim;
            EXEC [dbo].[ADD_number] @dim;
			SELECT * FROM T_2048
		END


	IF @move = 'L'
		BEGIN
			EXEC dbo.MOVE_left @dim;
            EXEC [dbo].[ADD_number] @dim;
			SELECT * FROM T_2048
		END

	IF @move = 'R'
		BEGIN
			EXEC dbo.MOVE_right @dim;
            EXEC [dbo].[ADD_number] @dim;
			SELECT * FROM T_2048
		END

END;
GO