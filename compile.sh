#Dependencies: gtk+-3.0
# sudo apt update
# sudo apt install libgtk-3-dev:i386  g++-multilib gcc-multilib
EXEC_NAME="super_tic_tac_toe.exe"

nasm -f elf32 src/asm_functions/search_position.asm -o asm_objects/search_position.o
nasm -f elf32 src/asm_functions/memory_setup.asm -o asm_objects/memory_setup.o

NASM_OBJECTS="asm_objects/search_position.o
                asm_objects/memory_setup.o"

gcc  -m32 -I include -c src/main.c  -o c_objects/main.o 
gcc -m32 -I include -c src/c_functions/record_movement.c  -o c_objects/record_movement.o

C_OBJECTS="c_objects/main.o 
        c_objects/interface.o
        c_objects/buttons_actions.o
        c_objects/record_movement.o
        c_objects/check_button.o"
        

gcc  -c -I include -o c_objects/interface.o src/interface/interface.c $(pkg-config --cflags --libs gtk+-3.0)
gcc  -c -I include -o c_objects/buttons_actions.o src/c_functions/buttons_actions.c $(pkg-config --cflags --libs gtk+-3.0)
gcc  -c -I include -o c_objects/check_button.o src/c_functions/check_button.c $(pkg-config --cflags --libs gtk+-3.0)

#gcc -m32 -o $EXEC_NAME $C_OBJECTS $NASM_OBJECTS  $(pkg-config --cflags --libs gtk+-3.0) -rdynamic


#./$EXEC_NAME
