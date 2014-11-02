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
 @message5: .asciz " "
 @message6: .asciz " "
 format:   .asciz "%d"
 
 .text
 
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
	mov r5, sp						@ **** Move the random number that will represent the value of the card into r5
	ldr r0, address_of_message1		@ Set message1 as the first parameter of printf
	bl printf 						@ Call printf
	bl suit1

suit1:	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so cal division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	mov r7, sp						@ **** Move the random number that will represent the suit into r7
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
	mov r6, sp						@ **** Move the random number that will represent the value of the card into r6
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
	mov r8, sp						@ **** Move the random number that will represent the suit into r8
	ldr r0, address_of_message4		@ Set message2 as the first parameter of printf
	bl printf 						@ Call printf
	
	
	mov r0, r8
	
	
	add r4,#1
	cmp r4,#1						@ How many hands do you want the dealer to deal?
	blt face1
	
	pop {lr} 						@ Pop the top of the stack and put it in lr
	bx lr 							@ Leave main
 
 
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 @address_of_message5: .word message5
 @address_of_message6: .word message6
 address_of_format: .word format	
 
									@ External Functions
 .global printf
 .global time
 .global srand
 .global rand