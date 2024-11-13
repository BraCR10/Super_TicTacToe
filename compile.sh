
EXEC_NAME="super_tic_tac_toe"

SRC_FILES="src/main/main.c src/interface/interface.c"

gcc -o $EXEC_NAME $SRC_FILES $(pkg-config --cflags --libs gtk+-3.0)




./super_tic_tac_toe 