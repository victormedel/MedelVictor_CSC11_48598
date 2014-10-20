/*
 * Author: Victor Medel
 * Created On: October 19, 2014
 * Purpose: Input and Output Division Program
 * Assignment 5
 *
 */
 
.data
 
 message1: .asciz "Please type your numerator: "
 message2: .asciz "Please type your denominator: "
 message3: .asciz "%d divided by %d is %d\n"
 message4: .asciz "with a remainder of %d\n" 
 scan_pattern: .asciz "%d"
 
 
											@ Division Function
 division:
	push {r2, r3, lr}						@ Push r2, r3, and lr onto the stack
											@ The stack is now 8 byte aligned
	mov r2, r0								@ Keep a copy of the numerator value from r0 in r2
	mov r3, r1								@ Keep a copy of the numerator value from r1 in r3
											
											@ Register Initilization
											
	mov r4, #1								@ r4=1, Counter initialized
	mov r5, r3								@ r5=r3, Set r5 equal to denominator
	mov r1, r2								@ r1=r2, Set r1 equal to numerator
	
	cmp r1, r3				  				@ Compare r1 to r3
	ble exit								@ If r1 is less than or equal to r3 exit
	bal scaleleft							@ Otherwise continue to scaleleft
	
scaleleft:	
	mov r4, r4, lsl #1						@ Scale factor|Division counter 
	mov r5, r5, lsl #1						@ Subtraction|Mod/Remainder subtraction
	cmp r1, r5								@ Compare r1 with r5
	bge scaleleft							@ If r1 is greater than or equal to r5 loop to scaleleft
	mov r4, r4, lsr #1						@ Otherwise Scale factor back
	mov r5, r5, lsr #1 						@ and scale subtraction factor back
	bal addsub								@ Continue to addsub

addsub:
	add r0, r0, r4							@ Count the subtracted scale factor
	sub r1, r1, r5							@ Subtract the scaled mod
	bal scaleright							@ Continue to scaleright

scaleright:
	mov r4, r4, lsr #1 						@ Division Counter
	mov r5, r5, lsr #1						@ Mod/Remainder subtraction
	cmp r1, r5								@ Compare remainder (r1) with subtraction factor (r5)
	blt scaleright							@ If r1 is less than r5 return to scaleright
	bal addsubcomp							@ Otherwise go to addsubcomp
	
addsubcomp:	
	cmp r4, #1 								@ Compare if r4 is greater than 1
	bge addsub								@ If r4 greater than 1 branch back to addsub
	
exit:
	pop {r2, r3, lr}						@ Pop lr, r3, and r2 from the stack
	bx lr
 
 .text
 
    .global main
 main:
	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #4 								@ Make room for one 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user
	
												@ Numerator Input
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 
 	ldr r0, address_of_scan_pattern				@ r0 <- scan_pattern
 	mov r1, sp 									@ Set the top of the stack as the second parameter
												@ of scanf
	bl scanf				         			@ call to scanf
	ldr r0, [sp] 								@ Load the integer read by scanf into r0
												@ So we set it as the first parameter
	
												@ Denominator Input
 	ldr r0, address_of_message2			 		@ r0 <- message2
 	bl printf					 		 		@ call to printf
 	
 	ldr r0, address_of_scan_pattern		        @ r0 <- scan_pattern
 	mov r2, sp 									@ Set the top of the stack as the third parameter
												@ of scanf
 	bl scanf				        		 	@ call to scanf
 	ldr r1, [sp] 								@ Load the integer read by scanf into r1
												@ So we set it as the third parameter
	
	bl division                          		@ Branchout to Division Funtion
  
												@ Output Results 
	mov r2, r0                            		@ r2 <- r0
	mov r3, r1                         			@ r3 <- r1
	
	ldr r1, [sp] 								@ Load the integer read by scanf into r1 */
												@ So we set it as the second parameter of printf */
	ldr r0, address_of_message3 				@ Set &message2 as the first parameter of printf */
	
	ldr r1, [sp] 								@ Load the integer read by scanf into r1 */
												@ So we set it as the second parameter of printf */
	ldr r0, address_of_message4 				@ Set &message2 as the first parameter of printf */
	bl printf
 
	add sp, sp, #+4 							@ Discard the integer read by scanf */
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr */
	bx lr                                  		@ return from main using lr
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 address_of_scan_pattern: .word scan_pattern
