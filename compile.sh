#Dependencies: gtk+-3.0
# sudo apt update
# sudo apt install libgtk-3-dev:i386
# sudo apt install libgdk-pixbuf2.0-dev:i386 libglib2.0-dev:i386 libpango1.0-dev:i386 libcairo2-dev:i386
EXEC_NAME="super_tic_tac_toe.out"

#C_FILES="src/main.c src/interface/interface.c src/actions/buttons_actions.c"
NASM_FILES="src/asm_functions/memory_managment.asm"
NASM_OBJECTS="src/asm_functions/memory_managment.o"

nasm -f elf32 $NASM_FILES 
#ld -s -m elf_i386 -o main $NASM_OBJECTS 
gcc -m32 -I include -o $EXEC_NAME $C_FILES $NASM_OBJECTS $(pkg-config --cflags --libs gtk+-3.0)

./$EXEC_NAME