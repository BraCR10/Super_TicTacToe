#include <interface.h>
#include <asm_utils.h>
#include <stdio.h>
#include <stdlib.h>  

void select_first_player() {
    long first_player = (rand() % 2) + 1;  
    main_matriz[90] = first_player;
    main_matriz[91] = 1;        
    printf("Jugador %ld empieza\n", first_player);
}

// Main function
void main(int argc, char **argv) {

    select_first_player();

    for (int i = 0; i < 91; i++) {
        printf("%ld ", main_matriz[i]);
    }

    call_login(argc, argv);
}
