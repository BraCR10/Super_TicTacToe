#include <interface.h>
#include <asm_utils.h>
#include <stdio.h>

extern int main_matriz[81];

// Main function
void
main (int    argc,
      char **argv)
{
  memory_setup();
  interface_call(argc,argv);
}