#include <interface.h>
#include <asm_utils.h>


// Main function
void
main (int    argc,
      char **argv)
{

  interface_call(argc,argv);
  memory_setup();
}