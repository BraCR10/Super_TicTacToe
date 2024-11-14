#Dependencies: gtk+-3.0
# sudo apt update
# sudo apt install libgtk-3-dev:i386
# sudo apt install libgdk-pixbuf2.0-dev:i386 libglib2.0-dev:i386 libpango1.0-dev:i386 libcairo2-dev:i386
EXEC_NAME="super_tic_tac_toe.exe"

C_FILES="src/main.c 
        src/interface/interface.c 
        src/c_functions/buttons_actions.c 
        src/c_functions/record_movement.c"

nasm -f elf32 src/asm_functions/memory_managment.asm
nasm -f elf32 src/asm_functions/memory_setup.asm
            

NASM_OBJECTS="src/asm_functions/memory_managment.o
              src/asm_functions/memory_setup.o"

gcc -m32 -I include -o $EXEC_NAME $C_FILES $NASM_OBJECTS $(pkg-config --cflags --libs gtk+-3.0)

./$EXEC_NAME