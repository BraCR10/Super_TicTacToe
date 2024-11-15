#ifndef ASM_UTILS_H
#define ASM_UTILS_H
/**
  Define the memory_managment function in asm
  - the first parameter is the offset of the button clicked
  - the second parameter is the variable to say who play
*/
extern void search_position(int offset, int *player);
extern void memory_setup();
#endif