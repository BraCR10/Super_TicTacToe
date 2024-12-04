# Super Tic Tac Toe

**Super Tic Tac Toe** is an enhanced version of the classic **Tic Tac Toe** game, where each cell of the main board is a smaller **sub Tic Tac Toe** board. Players take turns playing on the smaller boards, and the goal is to align three smaller boards in a row to win the main game. This project combines graphical elements using **C**, [GTK](https://www.gtk.org/), and [GLADE](https://glade.gnome.org/), with the underlying game logic and memory management handled in **Assembly(NASM 64-bit)**, using linked functions for integration.

## Features

- **Nested Gameplay**: The main board consists of a 3x3 grid, where each cell is a smaller Tic Tac Toe board. Players must win sub-games to win the main game.
- **Random Starting Player**: The first player is chosen randomly at the start of the game.
- **Sub-board Navigation**: The next sub-board to be played is determined by the last move made. The player must play in the corresponding sub-board based on the position of the last move.
- **Automatic Board Unlocking**: If the corresponding sub-board has already been won, all sub-boards are unlocked for play.
- **CPU Mode**: In CPU mode, the computer always plays as "O". The CPU evaluates the board and plays the first available space in any row, following a simple strategy of searching for open lines.
- **Tie Rules**: In case of a draw in a sub-board, it is awarded to the last player who played. If the main game ends in a draw, the game follows the same rule for deciding the winner.

## Game Flow

1. **Start the Game**: A random player is selected to start the game.
2. **Make a Move**: Players take turns playing on the sub-board corresponding to the position of the last move made on the main board.
3. **Sub-board Completion**: When a player wins a sub-board, it is marked as completed, and the winner is indicated.
4. **Main Board Completion**: Once a player has aligned three sub-boards in a row on the main board, the game ends with that player as the winner.
5. **CPU Mode**: In CPU mode, the computer automatically selects its move based on the available lines and plays as "O".

## Rules

- **Winning the Game**: To win the main game, you must align three sub-boards in a row (horizontally, vertically, or diagonally).
- **Sub-board Play**: When a player marks a cell on the main board, the next move must be in the corresponding sub-board.
- **Draws**: If a sub-board ends in a draw, the last player is awarded that sub-board. If the main game ends in a draw, the last player to play wins.
- **Unlocking Sub-boards**: If a sub-board has been won, players can play on any other available sub-board. If the sub-board corresponding to the last move is already won, all sub-boards become unlocked.

## Installation
1. **Fork the repository**:
2. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/super-tic-tac-toe.git
3. **Run script in Linux**:
   ```bash
   ./compile.sh
**Note:**  The project needs [NASM](https://www.nasm.us/) , [GTK](https://www.gtk.org/) and [GCC](https://gcc.gnu.org/install/) to compile.
