/****************************************************************
*@Author: Billy Brown
*@UTA ID: 1000955609
*@Date: 11/4/15
*@Description: A simple calculator program that is capable of
*              three simple functions: sum,difference,max,and 
*	       product.
****************************************************************/
     .global main
     .func main

main:
    BL _scanf
    MOV R8,R0
    BL _getchar
    MOV R10,R0
    BL _scanf
    MOV R9,R0
    MOV R1,R8
    MOV R2,R9
    MOV R3,R10
    BL _compare
    MOV R2,R0
    BL _printf
    BL main

_scanf:
    PUSH {LR}
    SUB SP, SP, #4
    LDR R0, =format_str
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {PC}

_getchar:
    MOV R7, #3
    MOV R0, #0
    MOV R2, #1
    LDR R1, =read_char
    SWI 0
    LDR R0, [R1]
    AND R0, #0xFF
    MOV PC, LR
    
_compare:
    PUSH {LR}
    CMP R3, #'+'
    BLEQ _sum
    CMP R3, #'-'
    BLEQ _difference
    CMP R3, #'*'
    BLEQ _product
    CMP R3, #'M'
    BLEQ _max
    POP {PC}
    
_printf:
    PUSH {LR}
    LDR R0, =printf_str
    MOV R1, R2
    BL printf
    POP {PC}    

_sum:
    ADD R0,R1,R2
    MOV PC,LR

_difference:
    SUB R0,R1,R2
    MOV PC,LR

_product:
    MUL R0,R1,R2
    MOV PC,LR

_max:
    CMP R1,R2
    MOVGT R0,R1
    MOVLT R0,R2
    MOV PC,LR
.data 
format_str:     .asciz       "%d"
read_char:      .asciz       " "
printf_str:     .asciz       "Your answer is: %d\n"
