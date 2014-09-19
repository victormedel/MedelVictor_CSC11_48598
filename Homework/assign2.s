/* Assignment 2: Calculate a/b and a%b with successive subtraction */

	.global _start
_start:
	MOV R2, #20		@ a
	MOV R3, #5		@ b

	SUBS R1, R2, R3		@ R1=R2-R3

loop:
	SUBS R1, R1, R3		@ R1=R1-R3	
	CMP R1, R3		@ Compare R1 with R3
	BLT stop		@ If R1<R3
 
stop:
	
