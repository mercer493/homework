/*****************************************************************************************************************************************
*Author: Billy Brown
*UTA ID: 1000955609
*Date: 12/11/15
*Description: The take-home portion of the Final Exam.
******************************************************************************************************************************************/
.global main
.func main

main:
   MOV R0, #0
   MOV R4, #0
   MOV R5, #99
   MOV R6, #-99

_loop:
   CMP R0, #10
   BEQ _loopdone
   PUSH {R0}
   BL _prompt
   BL _scanf
   MOV R8, R0
   CMP R8, R5
   MOVLT R5, R8
   CMP R8, R6
   MOVGT R6, R8
   ADD R4, R4, R8
   POP {R0}
   LDR R1, =array_a        @ get address of a_array
   LSL R2, R0, #2          @ multiply index*4 to get array offset
   ADD R2, R1, R2          @ R2 now has the element address
   STR R8, [R2]            @ write the address of a[i] to a[i]
   ADD R2, R2, #4
   ADD R0, R0, #1          @ increment index
   BL _loop

_loopdone:
    MOV R0, #0

readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    MOV R1, R5
    BL  _printf3
    MOV R1, R6
    BL  _printf4
    MOV R1, R4
    BL  _printf2
    B _exit                 @ exit if done

_exit:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf2:
    PUSH {LR}
    LDR R0, =printf_str2
    BL printf
    POP {PC}

_printf3:
    PUSH {LR}
    LDR R0, =printf_str3
    BL printf
    POP {PC}

_printf4:
    PUSH {LR}
    LDR R0, =printf_str4
    BL printf
    POP {PC}

    
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #23             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
    
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
   
.data

.balign 4
array_a:              .skip       40
printf_str:           .asciz      "array_a[%d] = %d\n"
printf_str2:	      .asciz	  "Sum = %d\n"
printf_str3:	      .asciz	  "minimum = %d\n"
printf_str4:	      .asciz      "maximum = %d\n"
prompt_str:           .asciz      "Please enter an integer: "
format_str:           .asciz      "%d"
exit_str:             .ascii      "Terminating program.\n"
