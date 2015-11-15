/*********************************************************************************************************************************
*Name: Billy Brown
*UTA ID: 1000955609
*11/14/15
*Description:
**********************************************************************************************************************************/
main:
   BL _prompt1
   BL _scanf
   BL _prompt2
   BL _scanf
   BL _count
   BL _printf
   BL main
   
   
_prompt1:
   PUSH {LR}
   PUSH {R1}               @ backup register value
   PUSH {R2}               @ backup register value
   PUSH {R7}               @ backup register value
   MOV R7, #4              @ write syscall, 4
   MOV R0, #1              @ output stream to monitor, 1
   MOV R2, #26             @ print string length
   LDR R1, =prompt_str1     @ string at label prompt_str:
   SWI 0                   @ execute syscall
   POP {R7}                @ restore register value
   POP {R2}                @ restore register value
   POP {R1}                @ restore register value
   POP {PC}              @ return
   
   
   
_prompt2:
   PUSH {LR}
   PUSH {R1}               @ backup register value
   PUSH {R2}               @ backup register value
   PUSH {R7}               @ backup register value
   MOV R7, #4              @ write syscall, 4
   MOV R0, #1              @ output stream to monitor, 1
   MOV R2, #26             @ print string length
   LDR R1, =prompt_str2     @ string at label prompt_str:
   SWI 0                   @ execute syscall
   POP {R7}                @ restore register value
   POP {R2}                @ restore register value
   POP {R1}                @ restore register value
   POP {PC}
   
   
   
   
   _scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return
    
    
    
    
  _count:
    PUSH {LR}
    CMP R1, #0
    MOVEQ R0, #1
    POPEQ {PC}
    MOVLT R0, #0
    POPLT {PC}
    CMP R2, #0
    MOVEQ R0, #0
    POPEQ {PC}
    PUSH {R1}
    PUSH {R2}
    SUB R1, R1, R2
    BL _count
    POP {R1}
    PUSH {R0}
    SUB R2, R2, #1
    BL _count
    MOV R3,R0
    POP {R0}
    ADD R4,R0,R3
    POP {R2}
    POP {PC}
    
  _printf:
    PUSH {LR}               @ store the return address
    LDR R0, = printf_str     @ R0 contains formatted string address
    MOV R1, R4              @ R1 contains printf argument 1 (redundant line)
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
   
   
   
.data
prompt_str1:                .asciz              "Please enter an integer n: "
prompt_str2:                .asciz              "Please enter an integer m: "
printf_str:                 .asciz              "%d\n"
