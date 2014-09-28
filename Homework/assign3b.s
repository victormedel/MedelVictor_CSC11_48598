/* Author: Victor Medel
 * Created On: September 27 ,2014
 * Purpose: Inefficient Technique for Calculating a/b and a%b
 * Assignment 3
 *
 * Note: The program I wrote for assignment 2 already reflected the 
 *       C++ program "Inefficient technique for calculating a/b and a%b" 
 *       therefore, I kept the program intact.
 */
 
 
     .global main
 
 main:
 
     MOV R2, #111          @ a
     MOV R3, #5            @ b
     MOV R4, #1            @ Used to swap R0 and R1 "flag IS set"
     MOV R0, #0            @ Set Counter to 0
     MOV R1, R2                @ Set R1=R2
 
 /*   Test to make sure that R1<R3   */

     CMP R1, R3             @ Compare R1 with R3
     BLT flag              @ If R1 is less than R3 go to flag
    
 loop:
     SUBS R1, R1, R3        @ R1=R1-R3
     ADDS R0, #1            @ Add 1 to the counter
     CMP R1, R3             @ Compare R1 with R3
     BLT flag              @ If R1 is less than R3 go to flag
     BAL loop              @ Otherwise go back to the start of the loop
     
 flag:
     CMP R4, #0             @ Check if flag is set
     BEQ exit              @ If flag is set to 0 it will exit
                            @ Otherwise it will swap registers
     MOV R4, R1             @ R1 goes to R4
     MOV R5, R0             @ R0 goes to R5
     MOV R0, R4             @ R0 is assigned R4 value
     
     MOV R1, R5             @ R1 is assigned R5 value
     
 exit:
     MOV R7, #1
     SWI 0