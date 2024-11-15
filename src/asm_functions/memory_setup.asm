global main_matriz;to access this matriz from other files
global playerSeletor;to access this player from other files

section .data

    main_matriz:;defining the matriz
        times 81 dd 0   ; reserving 81 spaces in memory for the matrix
                        ; each space is a double word (4 bytes)

    playerSeletor:
        player dd 1 ; 1 for player 1 and 2 for player 2
                    ; always start with player 1
section .bss


section .text
    global memory_setup  
    memory_setup: ;by this way, we inizialize the matriz from C in main at the begin 
    
    ret