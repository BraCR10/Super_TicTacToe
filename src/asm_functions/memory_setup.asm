global main_matriz;to access this matriz from other files


section .data

    main_matriz:;defining the matriz
        times 81 dd 0   ; reserving 81 spaces in memory for the matrix
                        ; each space is a double word (4 bytes)

section .bss


section .text
    global memory_setup  
    memory_setup: ;by this way, we inizialize the matriz from C in main at the begin 
    
    ret