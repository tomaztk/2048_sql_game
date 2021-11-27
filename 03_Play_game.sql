
CREATE OR ALTER PROCEDURE dbo.PLAY_game
	 @move CHAR(1) -- U, D, L, R (Up, Down, Left, Right)
	,@dim  INT  -- size of the matrix
AS
BEGIN

	IF @move = 'U'
		BEGIN
			EXEC dbo.MOVE_up @dim
            -- Add new number
			SELECT * FROM T_2048
		END

	IF @move = 'D'
		BEGIN
			EXEC dbo.MOVE_down @dim
            -- -- Add new number
			SELECT * FROM T_2048
		END


	IF @move = 'L'
		BEGIN
			EXEC dbo.MOVE_left @dim
            -- -- Add new number
			SELECT * FROM T_2048
		END

	IF @move = 'R'
		BEGIN
			EXEC dbo.MOVE_right @dim
            -- -- Add new number
			SELECT * FROM T_2048
		END

END;
GO