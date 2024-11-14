#include <asm_utils.h>


int record_movement(int offset){
  int player;
  memory_managment(offset,&player);
  return player;
}