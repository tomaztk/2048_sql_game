# T-SQL Code for popular 2048 Game
This GitHub repository contains code samples that demonstrate how to create and use the procedures for 2048 Game using SQL Server Transact SQL (T-SQL) in your favorite editor.

# What is 2048 game?
This is the classical puzzle game, that is easy and fun to play. The objective of the game is to move the numbers (tiles in the matrix/board) in a way to combine them to create a tile with the number 2048.

![](/img/game2048.png)


# SQL Procedures

Game consists of several procedures that make the game work.
In order for the game to start, you will need to run all the procedures and use the main 'Play_game' procedure.

Two groups of procedure are available to start and play the game:
  1. Procedures to create and initialize matrix (helper procedures)
  2. Procedures to make moves (helper procedures)
  3. Procedure to play the game (main procedure)



## Create and initialize matrix

The SQL file: _01_Create_initialize.sql_  describes two procedures that create an empty matrix (board) for a given dimension and initialize the matrix by adding two start numbers at a random position [x,y].

Run the code:
```(sql)
-- Create board of size 4
EXEC dbo.CREATE_matrix 4

-- Initialize board of size 4
EXEC dbo.INIT_matrix 4 
```

## Pocedures to make moves

The SQL file: _02_Move_procedures.sql_ describes four procedures that imitate a LEFT, RIGHT, UP and DOWN user move and calculates and moves the numbers in board accordingly.

Run the code:

```(sql)
-- Make a move DOWN on a board of size 4x4
EXEC dbo.MAKE_move 'D', 4
```


# Playing the game





## Forking or cloning the repository
To work in GitHub, go to https://github.com/tomaztk/2048_sql_game and fork the repository. Work in your own fork and when you are ready to submit to make a change or publish your sample for the first time, submit a pull request into the master branch of this repository. 

You can also clone the repository. Note: further changes should be fetched manually.


```
git clone -n https://github.com/tomaztk/2048_sql_game
```

## Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). Collaboration on this code is welcome and so are any additional questions or comments.


## License
Code is licensed under the MIT license.

## Questions
Email questions to: tomaz.kastrun@gmail.com