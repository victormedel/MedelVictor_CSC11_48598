/* Assignment 2: Calculate a/b and a%b with successive subtraction */

	.global _start
_start:
	MOV R2, #25		@ a=25
	MOV R3, #4		@ b=4
	MOV R4, #1		@ Used to swap R0 and R1 "flag"
	MOV R0, #0		@ Set Couter to 0, just to be sure

	SUBS R1, R2, R3		@ R1=R2-R3
	MOV R0, #1		@ Set counter to 1
	CMP R1, R3		@ Compare R1 with R3
	BLT _flag		@ If R1 is less than R3 go to flag
	/* BAL _loop		@ otherwise go to loop */
	
_loop:
	SUBS R1, R1, R3		@ R1=R1-R3
	ADDS R0, #1		@ Add 1 to the counter
	CMP R1, R3		@ Compare R1 with R3
	BLT _flag		@ If R1 is less than R3 go to flag
	BAL _loop		@ otherwise go back to the start of the loop

_flag:
	CMP R4, #0		@ Check if flag is set
	BEQ _exit		@ If flag is set to 0 it will exit
				@ Otherwise it will swap registers
	MOV R4, R1		@ R1 goes to R4
	MOV R5, R0		@ R0 goes to R5
	MOV R0, R4		@ R0 is assigned R4 value
	MOV R1, R5		@ R1 is assigned R5 value

	
	
_exit:
	MOV R7, #1
	SWI 0
