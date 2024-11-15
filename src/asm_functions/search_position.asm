
global search_position   

extern main_matriz ; to access the matriz from other files
extern playerSelector ; to access the player number from other files



section .text

search_position:
      enter   0,0
      pusha
      mov eax, [ebp+12] ; player variable in C to return the player
      mov ebx, [ebp+8] ; offset 
      mov ecx, [playerSelector] ; playerSeletor variable data
      mov edx, main_matriz ; main_matriz variable pointer


      cmp byte [edx+ebx], 0 ; checking if the position is empty
      jne locked ; if  empty, return to C

      change_player:
      cmp ecx, 1 ; checking if the player is 1
      je player1 
      jne player2

      player1:
      mov byte  [edx+ebx],1 ; putting the player number in the matriz            
      mov dword [playerSelector], 2 ; changing the player to 2
      mov dword [eax], 1 ; putting the player in the parameter to return to C
      jmp exit

      player2:
      mov byte  [edx+ebx],2 ; putting the player number in the matriz  
      mov dword [playerSelector], 1 ; changing the player to 1
      mov dword [eax], 2 ; putting the player in the parameter to return to C
      jmp exit

      locked:
      mov dword [eax], 0 ; if locked, return 0 to C

      exit:
      popa
      leave	
      ret