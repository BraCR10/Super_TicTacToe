section .text
global search_position

extern main_matriz       

search_position:
    push rbp                      ; Save the base pointer
    mov rbp, rsp                  ; Set the stack pointer as the base pointer
    sub rsp, 16                   ; Reserve space for local variables
    

    push rbx
    push rdi
    push rsi
    push rdx
    
    mov rsi, [rbp+24]             ; Load the offset into rsi (0-indexed)
    lea rcx, [rel main_matriz]    ; Get the base address of the matrix
    
    mov r8, 9
    mov r13, rsi ; Save the offset in r13

    ; Multiply rsi by 8 to calculate the correct position in bytes
    shl rsi, 3                    ; Multiply rsi by 8 (equivalent to rsi * 8)

    ; Load the value of the cell
    mov rax, [rcx+rsi]            ; Load the value of the cell (64 bits)
    test rax, rax                 ; If the value is 0, the cell is empty
    jnz invalid_move              ; If the cell is occupied, jump to invalid_move

    ; If the cell is free, check the player
    lea rdx, [rel main_matriz]
    mov rbx, [rdx+90*8]           ; Load the current player value (64 bits) into rbx

    ; Validation for player 1
    cmp rbx, 1
    je player_1_move              ; If player 1, process their move

    ; Validation for player 2
    cmp rbx, 2
    je player_2_move              ; If player 2, process their move

    ; If the player value is invalid
    mov rax, 0                    ; Set rax to 0 indicating an invalid player
    jmp exit

player_1_move:
    ; Mark the cell for player 1
    mov qword [rcx+rsi], 1        ; Store the value 1 in the position for player 1 (64 bits)
    
    jmp calculate_table
    
    mov rax, 1                    ; Return 1 to indicate that the move was made by player 1
    jmp update_turn

player_2_move:
    ; Mark the cell for player 2
    mov qword [rcx+rsi], 2        ; Store the value 2 in the position for player 2 (64 bits)

    jmp calculate_table
    mov rax, 2                    ; Return 2 to indicate that the move was made by player 2
    jmp update_turn

update_turn:
    ; Switch turns: if the current player is 1, change to 2, and vice versa
    lea rdx, [rel main_matriz]
    xor rbx, 3                    ; If it's 1 -> 2, if it's 2 -> 1 (1 XOR 3 = 2, 2 XOR 3 = 1)
    mov qword [rdx+90*8], rbx     ; Update the current player in main_matriz[81]
    jmp exit

invalid_move:
    ; If the cell is already occupied
    mov rax, 0                    ; Result 0 means invalid move
    jmp exit

calculate_table:

    
    mov rax, r13
    xor rdx, rdx
    div r8
    mov r9, rax
    xor rax, rax

    jmp check_win

check_win:

    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_row2                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_row2                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_row2                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx


    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win

    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory


    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno

check_win_row2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base
    add rdx, 24

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_row3                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_row3                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_row3                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno

check_win_row3:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base
    add rdx, 48

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_column                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_column                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_column                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]
                ; Cargar el valor del jugador actual en rbx
    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno

check_win_column:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8*3]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*6]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_column2                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_column2                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_column2                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno

check_win_column2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*7]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_column3                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_column3                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_column3                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno


check_win_column3:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*2]             ; Carga el primer elemento
    mov r11, [rdx+8*5]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*8]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_diagnol                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_diagnol                   ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_diagnol                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno


check_win_diagnol:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*0]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*8]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne check_win_diagnol2                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne check_win_diagnol2                   ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je check_win_diagnol2                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno



check_win_diagnol2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*2]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*6]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne no_win                  ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne no_win                  ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je no_win                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    cmp rbx, 1                     ; Comparar si el jugador actual es 1
    je player_1_victory            ; Si es 1, saltar a la etiqueta player_1_victory
    cmp rbx, 2                     ; Comparar si el jugador actual es 2
    je player_2_victory            ; Si es 2, saltar a la etiqueta player_2_victory

    ; En caso de un valor inesperado (seguridad adicional)
    mov rax, 0                     ; Resultado 0 indica error o condición inválida
    jmp update_turn                ; Saltar a la lógica de cambio de turno







global_check_win:

    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_row2                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_row2                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_row2                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx


    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win


global_check_win_row2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base
    add rdx, 24

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_row3                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_row3                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_row3                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    ; En caso de un valor inesperado (seguridad adicional)
    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
global_check_win_row3:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base
    add rdx, 48

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+16]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_column                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_column                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_column                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]
                ; Cargar el valor del jugador actual en rbx
    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    

global_check_win_column:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx]             ; Carga el primer elemento
    mov r11, [rdx+8*3]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*6]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_column2                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_column2                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_column2                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    

global_check_win_column2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*7]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_column3                    ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_column3                    ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_column3                     ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    
    


global_check_win_column3:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*2]             ; Carga el primer elemento
    mov r11, [rdx+8*5]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*8]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_diagnol                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_diagnol                   ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_diagnol                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    

global_check_win_diagnol:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*0]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*8]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_check_win_diagnol2                   ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_check_win_diagnol2                   ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_check_win_diagnol2                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win
    




global_check_win_diagnol2:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, r9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r10, [rdx+8*2]             ; Carga el primer elemento
    mov r11, [rdx+8*4]           ; Carga el segundo elemento (8 bytes de distancia para 64 bits)
    mov r12, [rdx+8*6]          ; Carga el tercer elemento (16 bytes de distancia)

    ; Comprobar si los tres valores son iguales (y no son 0)
    cmp r10, r11
    jne global_no_win                  ; Si r10 != r11, no hay victoria
    cmp r11, r12
    jne global_no_win                  ; Si r11 != r12, no hay victoria
    cmp r10, 0
    je global_no_win                   ; Si r10 es 0, no hay victoria

    lea rdx, [rel main_matriz]     ; Dirección base de la matriz
    mov rbx, [rdx+90*8]            ; Cargar el valor del jugador actual en rbx

    cmp r10, 3
    je player_win
    cmp r10, 4
    je player_win



global_1_return:
    mov rax, 3
    jmp exit

global_2_return:
    mov rax, 4
    jmp exit

player_1_victory:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, 9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r13, r9
    imul r13, r13, 8
    add rdx, r13

    mov qword [rdx], 3  

    mov r9, 9
    jmp global_check_win

    mov rax, 3                     ; rax = 3, indica victoria para el jugador 1
    jmp update_turn

player_2_victory:
    lea rdx, [rel main_matriz] ; Dirección base de la matriz en rdx
    mov r13, 9                 ; Copia r9 (índice) a r8
    imul r13, r13, 72            ; Calcula el desplazamiento: r8 = r9 * 72
    add rdx, r13                ; Suma el desplazamiento a la dirección base

    mov r13, r9
    imul r13, r13, 8
    add rdx, r13

    mov qword [rdx], 4
    
    mov r9, 9
    jmp global_check_win

    mov rax, 4                     ; rax = 4, indica victoria para el jugador 2
    jmp update_turn

player_win:
    mov rax, 5
    jmp exit
    
no_win:
    ; If the cell is free, check the player
    lea rdx, [rel main_matriz]
    mov rbx, [rdx+90*8]           ; Load the current player value (64 bits) into rbx

    mov rax, rbx
    jmp update_turn

global_no_win:
    cmp rbx, 1                     ; Compare if the current player is 1
    je global_1_return             ; If it's 1, jump to the global_1_return label

    cmp rbx, 2                     ; Compare if the current player is 2
    je global_2_return             ; If it's 2, jump to the global_2_return label
    
exit:
    pop rdx
    pop rsi
    pop rdi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
