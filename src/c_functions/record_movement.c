#include <asm_utils.h>
#include <stdio.h>

int record_movement(int offset){
  int player;
  search_position(offset,&player);
  return player;
}