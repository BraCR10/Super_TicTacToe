#include <asm_utils.h>
#include <stdio.h>

long record_movement(long offset) {
    long result;
    

    printf("\nPre move:\n");
    for (int i = 0; i < 91; i++) {
        printf("%ld ", main_matriz[i]);  
    }
  
    result = search_position(offset);
    
    if (result == 0) {
        printf("Invalid move: Position already occupied.\n");
        return -1;  
    }

    printf("\nPost move:\n");
    for (int i = 0; i < 91; i++) {
        printf("%ld ", main_matriz[i]);  
    }

    printf("Player %ld played at position %ld\n", result, offset);
    


    return result;
}
