#include "interface.h"

// Main function
void
main (int    argc,
      char **argv)
{
  /**
    Define the memory_managment function in asm
    - the first parameter is the offset of the button clicked
    - the second parameter is the variable to say who play
  */
  extern void memory_managment(int,int*);

  //1=X | 2=O
  int player = 1;
  //memory_managment(0,&player);
  interface_call(argc,argv);
}