/*
 * Author: Victor Medel
 * Created on November 1, 2014
 * CSC11 Project 1 - Simple Game of Black Jack
 *
 */
 
 .data
 
 message1: .asciz "You have been delt the following card(s):  %d "
 message2: .asciz "of %d"
 message3: .asciz " and a %d "
 message4: .asciz "of %d\n"
 message5: .asciz "Your current score is %d\n"
 message6: .asciz "Would you like another card? \n(Enter 1 for yes, anything else for no.): "
 format: .asciz "%d"
 
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

	.global face1
face1:	 							@ Create a random number
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	mov r5, r1
	ldr r0, address_of_message1		@ Set message1 as the first parameter of printf
	bl printf 						@ Call printf	
	bl suit1

	.global suit1
suit1:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so call division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	mov r10, r1
	ldr r0, address_of_message2		@ Set message2 as the first parameter of printf
	bl printf 						@ Call printf
	bl face2

	.global face2
face2:	 							@ Create a random number
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	mov r6, r1
	ldr r0, address_of_message3		@ Set message3 as the first parameter of printf
	bl printf 						@ Call printf
	bl suit2

	.global suit2
suit2:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so cal division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	mov r10, r1
	ldr r0, address_of_message4		@ Set message4 as the first parameter of printf
	bl printf 						@ Call printf
	
	add r6, r6, r5					@ Add players score and print it out
	mov r1, r6
	ldr r0, address_of_message5		@ Set message5 as the first parameter of printf
	bl printf
	
	cmp r6, #21						@ Compare players score with 21
	ble	ask							@ Ask player if the would like another card
	bgt	house						@ Otherwise display house's hand
	
ask:
	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #4 								@ Make room for one 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user
	
 	ldr r0, address_of_message6					@ r0 <- message6
 	bl printf					 				@ call to printf
 	ldr r0, address_of_format					@ r0 <- scan_pattern
 	mov r8, sp 									@ Set variable of the stack as 	
	bl scanf				         			@ call to scanf	

	add sp, sp, #4								@ Discard the integer read by scanf
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr
	cmp r8, #1
	ble face3
	bgt house

	
	.global face3
face3:	 							@ Create a random number
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	mov r7, r1
	ldr r0, address_of_message1		@ Set message3 as the first parameter of printf
	bl printf 						@ Call printf
	bl suit2

	.global suit3
suit3:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so cal division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	mov r10, r1
	ldr r0, address_of_message2		@ Set message4 as the first parameter of printf
	bl printf 						@ Call printf
	
	add r7, r7, r6					@ Add players score and print it out
	mov r1, r7
	ldr r0, address_of_message5		@ Set message5 as the first parameter of printf
	bl printf
	
	
	
	
	add r4,#1
	cmp r4,#1						@ How many hands do you want the dealer to deal?
	blt face1
	
	pop {lr} 						@ Pop the top of the stack and put it in lr
	bx lr 							@ Leave main
 
 
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 address_of_message5: .word message5	 
 address_of_message6: .word message6
 address_of_format: .word format
									@ External Functions
 .global printf
 .global time
 .global srand
 .global rand