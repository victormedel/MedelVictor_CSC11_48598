/* 
 * 
 * Author: Victor Medel
 * Created On: September 27 ,2014
 * Purpose: More Efficient Technique for Calculating a/b and a%b
 * Assignment 3
 *
 */
 
     .global main
 main:
 
     LDR R2, =0x56CE       @ a
     MOV R3, #5            @ b
     MOV R4, #1            @ Used to swap R0 and R1 "flag IS set"
     MOV R5, #0		          @ Sets Register R5 to 0
     MOV R6, #0		          @ Sets Register R6 to 0
     MOV R7, #0		          @ Sets Register R7 to 0
     MOV R8, #10	          @ Sets Register R8 to 10
     MOV R9, #0		          @ Sets Register R9 to 0
     MOV R10, #0           @ Sets Register R10 to 0
     MOV R0, #0            @ Set Counter to 0
     MOVS R1, R2           @ Set R1=R2
 
 /*   Test if R1>=R3   */

     CMP R1, R3             @ Compare R1 with R3
     BGE scale              @ If R1 is greater than or equal to R3 go to scale
     BAL flag               @ Otherwise jump to flag
     
 scale:
     MOVS R6, #1            @ R6=1 scale
     MULS R7, R3, R6        @ R7=R3*R6 subtraction factor
     MULS R9, R7, R8        @ R9=R7*R8 next subtraction factor to test
     BAL scalecomp

 scalecomp:    
     CMP R1, R9             @ Compares R1 with R9
     BGT inscale            @ If R1 is greater than R9 then go to inscale
     BAL loop               @ Otherwise jump to loop
     
 inscale:
     MOVS R10, R6           @ R10=R6
     MULS R6, R10, R8       @ R6=R6*R8
     MULS R7, R3, R6        @ R7=R3*R6
     MULS R9, R7, R8        @ R9=R7*R8
     BAL scalecomp
    
 loop:
     ADDS R0, R0, R6        @ R0=R0+R6 Increase by scale
     SUBS R1, R1, R7        @ R1=R1-R7 Subtract by scale
     CMP R1, R7             @ Compare R1 to R7
     BGE loop               @ If R1 is greater than or Equal to R7 go back to loop
     BAL comploop
 
 comploop:
     CMP R6, #1             @ Compare R6 to 1
     BGT scale              @ If R6 is greater than 1 jump back to scale
     BAL flag               @ Otherwise go to flag
     
 flag:
     CMP R4, #0             @ Check if flag is set
     BEQ exit               @ If flag is set to 0 it will exit
                            @ Otherwise it will swap registers
    MOVS R5, R0             @ R0 goes to R5
    MOVS R0, R1             @ R1 goes to R0
    MOVS R1, R5             @ R1 is assigned R5 value
     
 exit:
     BX LR
