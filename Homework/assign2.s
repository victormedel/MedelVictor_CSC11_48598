/* Assignment 2: Calculate a/b and a%b with successive subtraction */

	.global _start
_start:
	MOV R2, #20		@ a=20
	MOV R3, #5		@ b=5

	SUBS R1, R2, R3		@ R1=R2-R3
	CMP R1, R3		@ Compare R1 with R3
	BLT _exit		@ If R1 is less than R3 then exit
	BAL _loop		@ otherwise go to loop

_loop:
	SUBS R1, R1, R3		@ R1=R1-R3	
	CMP R1, R3		@ Compare R1 with R3
	BLT _exit		@ If R1 is less than R3 then exit
	BAL _loop		@ otherwise go back to the start of the loop
	
 
_exit:
	MOV R7, #1
	SWI 0
	
