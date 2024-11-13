
EXEC_NAME="super_tic_tac_toe"

SRC_FILES="src/main.c src/interface/interface.c"

gcc -I include -o $EXEC_NAME $SRC_FILES $(pkg-config --cflags --libs gtk+-3.0)




./super_tic_tac_toe 