/******************************************************************************
* 
* 
*
* 
* 
*
* @AUTHOR Billy J. Brown
******************************************************************************/
 
.global main
.func main
   
main:
    BL _prompt
    BL _scanf
    MOV R7, R0
    MOV R0, #0              @ initialze index variable
generate:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ gendone             @ exit loop if done
    LDR R1, =a_array        @ get address of a_array
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    ADD R8, R7, R0
    STR R8, [R2]            @ write the address of a[i] to a[i]
    ADD R2, R2, #4
    ADD R8, R8, #1
    SUB R8, 0, R8
    STR R8 [R2]
    ADD R0, R0, #2          @ increment index
    BL generate             @ branch to next loop iteration
gendone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a_array              @ get address of a
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
a_array:              .skip       80
b_array:              .skip       80
printf_str:           .asciz      "a[%d] = %d\n"
prompt_str:           .asciz      "Please enter an integer: "
format_str:           .asciz      "%d\n"
exit_str:             .ascii      "Terminating program.\n"
