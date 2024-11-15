
global search_position    
extern main_matriz
extern playerSeletor
section .text


search_position:
      enter   0,0
      pusha
      mov eax, [ebp+12] ; player variable in C to return the player
      mov ebx, [ebp+8] ; offset 
      mov ecx, playerSeletor ; playerSeletor variable
      mov edx, main_matriz ; main_matriz variable pointer

      cmp dword [edx+ebx], 0 ; checking if the position is empty
      mov dword [eax], 0 ; if empty, return 0 to C
      jne exit ; if not empty, return to C

      mov ecx, [ecx] ; getting the player number
      mov [edx+ebx],ecx ; putting the player number in the matriz

      change_player:
      mov ecx, playerSeletor ; playerSeletor variable
      cmp dword [ecx], 1 ; checking if the player is 1
      je player1 
      jne player2

      player1:
      mov dword [ecx], 2 ; changing the player to 2
      mov dword [eax], 2 ; putting the player in the parameter to return to C
      jmp exit

      player2:
      mov dword [ecx], 1 ; changing the player to 1
      mov dword [eax], 1 ; putting the player in the parameter to return to C
      jmp exit

      exit:
      popa
      leave	
      ret