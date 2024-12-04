#!/bin/bash

# Dependencies: gtk+-3.0
# Asegúrate de tener instaladas las dependencias
# sudo apt update
# sudo apt install libgtk-3-dev gcc g++

# Nombre del ejecutable
EXEC_NAME="super_tic_tac_toe.exe"

# Compilación de archivos NASM
nasm -f elf64 -g -F dwarf src/asm_functions/search_position.asm -o asm_objects/search_position.o
nasm -f elf64 -g -F dwarf src/asm_functions/memory_setup.asm -o asm_objects/memory_setup.o

# Archivos objeto NASM
NASM_OBJECTS="asm_objects/search_position.o asm_objects/memory_setup.o"

# Compilación de archivos C
gcc -m64 -fPIE -I include -c src/main.c -o c_objects/main.o
gcc -m64 -fPIE -I include -c src/c_functions/record_movement.c -o c_objects/record_movement.o

# Archivos objeto C
C_OBJECTS="c_objects/main.o c_objects/interface.o c_objects/buttons_actions.o c_objects/record_movement.o c_objects/check_button.o c_objects/CPU_movement.o"

# Compilación de archivos dependientes de GTK
gcc -m64 -fPIE -c -I include -o c_objects/interface.o src/interface/interface.c $(pkg-config --cflags gtk+-3.0)
gcc -m64 -fPIE -c -I include -o c_objects/buttons_actions.o src/c_functions/buttons_actions.c $(pkg-config --cflags gtk+-3.0)
gcc -m64 -fPIE -c -I include -o c_objects/check_button.o src/c_functions/check_button.c $(pkg-config --cflags gtk+-3.0)
gcc -m64 -fPIE -c -I include -o c_objects/CPU_movement.o src/c_functions/CPU_movement.c $(pkg-config --cflags gtk+-3.0)
# Enlace final con PIE habilitado
gcc -m64 -fPIE -pie -o $EXEC_NAME $C_OBJECTS $NASM_OBJECTS $(pkg-config --cflags --libs gtk+-3.0)

# Ejecución
./$EXEC_NAME
