
global memory_managment    

section .data
    msg db "Hello from ASM!", 0

section .bss

section .text
memory_managment:
      enter   0,0
      mov     EAX,[EBP+8]        ; get argument1 (x)
      add     EAX,[EBP+12]       ; add argument 2 (y)
      leave	
      ret