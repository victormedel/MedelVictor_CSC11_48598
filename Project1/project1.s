/*
 * Author: Victor Medel
 * Created on November 1, 2014
 * CSC11 Project 1 - Simple Game of Black Jack
 *
 */
 
 .data
 
 message1: .asciz "You have been delt the following cards:  %d "
 message2: .asciz "of %d"
 message3: .asciz " and a %d "
 message4: .asciz "of %d\n"

 
 .text
 
scaleRight:
	push {lr} 						@ Push lr onto the stack
		doWhile_r1_lt_r2: 			@ Shift right until just under the remainder
			mov r3,r3,ASR #1; 		@ Division counter
			mov r2,r2,ASR #1 		@ Mod/Remainder subtraction
			cmp r1,r2
			blt doWhile_r1_lt_r2
	pop {lr} 						@ Pop lr from the stack
	bx lr 							


addSub:
	push {lr} 						@ Push lr onto the stack
	doWhile_r3_ge_1:
		add r0,r0,r3
		sub r1,r1,r2
		bl scaleRight
		cmp r3,#1
		bge doWhile_r3_ge_1
	pop {lr}						 @ Pop lr from the stack
	bx lr 							 

	
scaleLeft:
	push {lr} 						@ Push lr onto the stack
		doWhile_r1_ge_r2: 			@ Scale left till overshoot with remainder
			mov r3,r3,LSL #1 		@ scale factor
			mov r2,r2,LSL #1 		@ subtraction factor
			cmp r1,r2
			bge doWhile_r1_ge_r2 	@ End loop at overshoot
	mov r3,r3,ASR #1 				@ Scale factor back
	mov r2,r2,ASR #1 				@ Scale subtraction factor back
	pop {lr} 						@ Pop lr from the stack
	bx lr							

	
division:
	push {lr} 						@ Push lr onto the stack
									@ Determine the quotient and remainder
	mov r0,#0
	mov r3,#1
	cmp r1,r2
	blt end
	bl scaleLeft
	bl addSub

end:
	pop {lr} 						@ Pop lr from the stack
	bx lr 							
		
 
 

	.global main
main:
	push {lr}	 					@ Push lr onto the top of the stack	
	mov r0,#0 						@ Set time(0)
	bl time 						@ Call time 
	bl srand 						@ Call srand
	
	mov r4,#0 						@ Setup loop counter

	
face1:	 							@ Create a random number
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	ldr r0, address_of_message1		@ Set message1 as the first parameter of printf
	bl printf 						@ Call printf	
	bl suit1

suit1:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so call division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	ldr r0, address_of_message2		@ Set message2 as the first parameter of printf
	bl printf 						@ Call printf
	bl face2

face2:	 							@ Create a random number
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	ldr r0, address_of_message3		@ Set message1 as the first parameter of printf
	bl printf 						@ Call printf
	bl suit2

suit2:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so cal division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	ldr r0, address_of_message4		@ Set message2 as the first parameter of printf
	bl printf 						@ Call printf
	
	
	add r4,#1
	cmp r4,#1						@ How many hands do you want the dealer to deal?
	blt face1
	
	pop {lr} 						@ Pop the top of the stack and put it in lr
	bx lr 							@ Leave main
 
 
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4	
 
									@ External Functions
 .global printf
 .global time
 .global srand
 .global rand