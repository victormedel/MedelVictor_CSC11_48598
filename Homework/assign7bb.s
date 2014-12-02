/* 
 * Author: Victor Medel
 * Create On: November 30, 2014
 * Purpose: Assignment 7b: Implement the Drag and Temperature
 * 			Calculations as a pure integer calculation
 *
 */
 
 
 .data
 
 message1: .asciz "Enter your temperature in Fahrenheit: "
 message2: .asciz "You entered %d degrees Fahrenheit\n"
 message3: .asciz "Your temperature in Celsius is %d\n"
 format: .asciz "%d"
 
 .text
 
temp:
	push {lr}									@ Push lr onto the stack
												@ The stack is now 4 byte aligned
	
	ldr r3, =32									@ r3=32
	ldr r4, =0x8e38								@ 16 bits, >>16 [5/9=0.555...]

	sub r5, r1, r3								@ r5 = (Fahrenheit-r3)
	mul r5, r4, r5								@ r5 = (5/9)*r5
	mov r5, r5, asr #16							@ r5 >>16
	mov r0, r5									@ r0 = r5
	
	pop {lr}									@ Pop lr from the stack
	bx lr
 
	.global main
main:
	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #4 								@ Make room for two 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user

												@ Radius and Velocity Input
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 	ldr r0, address_of_format					@ r0 <- scan_pattern
 	mov r1, sp 									@ Set variable of the stack as velocity	
	bl scanf				         			@ call to scanf											

												@ Echo Results
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [sp] 								@ Load the integer velocity read by scanf into r2
	ldr r0, address_of_message2 				@ Set message2 as the first parameter of printf
	bl printf
	
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [sp] 								@ Load the integer velocity read by scanf into r2
	bl temp		                         		@ Branchout to Temperature Conversion Funtion
	
	mov r1, r0                         			@ r1 <- r0 | return of drag force
	ldr r0, address_of_message3 				@ Set &message3 as the first parameter of printf
	bl printf	
												
	add sp, sp, #4								@ Discard the integer read by scanf
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr
	bx lr      
	
	
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_format: .word format												
 
 .global scanf
 .global printf