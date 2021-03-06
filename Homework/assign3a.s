/* 
 * 
 * Author: Victor Medel
 * Created On: September 27 ,2014
 * Purpose: Inefficient Technique for Calculating a/b and a%b (Flag Is Not Set)
 * Assignment 3
 *
 */
 
 
     .global main
 
 main:
 
     MOV R2, #111          @ a
     MOV R3, #5            @ b
     MOV R4, #0            @ Used to swap R0 and R1 "flag is NOT set"
     MOV R0, #0            @ Set Counter to 0
     MOV R1, R2            @ Set R1=R2
 
 /*   Test if R1>=R3   */

     CMP R1, R3            @ Compare R1 with R3
     BGE loop              @ If R1 is greater than or equal to R3 go to loop
    
 loop:
     SUBS R1, R1, R3        @ R1=R1-R3
     ADDS R0, #1            @ Add 1 to the counter
     CMP R1, R3             @ Compare R1 with R3
     BGE loop               @ If R1 is greater than or equal to R3 go to loop
     BAL flag               @ Otherwise go to flag
     
 flag:
     CMP R4, #0             @ Check if flag is set
     BEQ exit               @ If flag is set to 0 it will exit
                            @ Otherwise it will swap registers
    MOV R5, R0              @ R0 goes to R5
    MOV R0, R1              @ R1 goes to R0
    MOV R1, R5              @ R1 is assigned R5 value
     
 exit:
     MOV R7, #1
     SWI 0
