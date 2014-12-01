/* 
 * Author: Victor Medel
 * Create On: November 26, 2014
 * Purpose: Assignment 7b: Implement the Drag and Temperature
 * 			Calculations as a pure integer calculation
 *
 */
 
 
 .data
 
 message1: .asciz "Enter the radius and velocity: "
 message2: .asciz "You entered %d inches for radius and %d feet/sec. for your velocity.\n"
 message3: .asciz "Your Drag Force is %d\n"
 format: .asciz "%d %d"
 
 .text
 
drag:
	push {lr}									@ Push lr onto the stack
												@ The stack is now 4 byte aligned
	
	ldr r3, =1									@ Setup for [1/2]
	mov r3, r3, asr #1							@ r3 = 1/2
	ldr r4, =0x9b5								@ Setup for (0.00237) [Density]
	mov r4, r4, asr #20							@ r4 = 0.00237
	ldr r5, =0x3243f7							@ Setup for (3.1415..) [Pi]
	mov r5, r5, asr #20							@ r5 = 3.14159265359
	ldr r6, =0x1c7								@ Setup for Unit Converstion [1/144]
	mov r6, r6, asr #16							@ r6 = (1/144)
	ldr r7, =0x667								@ Coefficient of Density | r7 = 0.4
	
												@ Dynamic Pressure
	mov r8, r3
	mul r8, r4, r8
	mul r8, r2, r8
	mul r8, r2, r8
	mov r8, r8, asr #13
												@ Area Equation
	mov r9, r5
	mul r9, r1, r9
	mov r9, r9, asr #16
	mul r9, r1, r9
	mul r9, r6, r9
	mov r9, r9, asr #12
												@ Drag Equation
	mul r10, r8, r9
	mov r10, r10, asr #16
	mul r10, r7, r10
	mov r10, r10, asr #12
	mov r0, r10
	
	pop {lr}									@ Pop lr from the stack
	bx lr
 
	.global main
main:
	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #8 								@ Make room for two 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user

												@ Radius and Velocity Input
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 	ldr r0, address_of_format					@ r0 <- scan_pattern
 	mov r2, sp 									@ Set variable of the stack as velocity	
	add r1, r2, #4								@ and second value as radius of scanf	
	bl scanf				         			@ call to scanf											

												@ Echo Results
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [r1]								@ Load the integer radius read by scanf into r1
	ldr r2, [sp] 								@ Load the integer velocity read by scanf into r2
	ldr r0, address_of_message2 				@ Set message2 as the first parameter of printf
	bl printf
	
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [r1]								@ Load the integer radius read by scanf into r1
	ldr r2, [sp] 								@ Load the integer velocity read by scanf into r2
	bl drag		                         		@ Branchout to Division Funtion
	
	mov r1, r0                         			@ r1 <- r0 | return of drag force
	ldr r0, address_of_message3 				@ Set &message3 as the first parameter of printf
	bl printf	
												
	add sp, sp, #8								@ Discard the integer read by scanf
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr
	bx lr      
	
	
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_format: .word format												
 
 .global scanf
 .global printf