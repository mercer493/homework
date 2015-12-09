    .global main
    .func main
   
main:
    BL _prompt
    BL _scanf
    MOV R7,R0
    BL _prompt
    BL _scanf
    MOV R8,R0
    VLDR S0, [R7]
    VLDR S1, [R8]
    VDIV.F32 S2, S0, S1
    VCVT.F64.F32 D4, S2
    MOV R1,R7
    MOV R2,R8
    BL _printf
    VMOV R1, R2, D4
    BL _printf2
    BL main               @ branch to exit procedure with no return
    
    
    
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
    
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_printf2:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str2     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
   
   
   
.data

printf_str:           .asciz      "%d/%d = "
printf_str2:          .asciz      "%f\n"
prompt_str:           .asciz      "Please enter an integer: "
format_str:           .asciz      "%d\n"
exit_str:             .ascii      "Terminating program.\n"
