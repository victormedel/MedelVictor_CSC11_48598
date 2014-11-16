/*
 * Author: Victor Medel
 * Created On: November 11, 2014
 * Assignment 7a
 * Purpose: Convert via Input Fahrenheit to Celsius.
 *
 */
 
 .data
 
 message1: .asciz "Your Temperature in Fahrenheit %d"
 message2: .asciz "\nYou entered %d degrees Fahrenheit"
 message3: .asciz "\nYour Temperature in Celsius is %d"
 format: .asciz "%d"
 
 
 .text
 
convert:
	push {lr}								@ Push lr onto the stack
											@ The stack is now 4 byte aligned
	mov r5, #5								@ r5=5
	sub r1, r1, #32							@ r1=(input-32)
	mul r1, r5, r1							@ r1=r1*r5
											
	bal division 
 
division:
	push {lr}								@ Push lr onto the stack
											@ The stack is now 4 byte aligned
											
	mov r0, #0									
	mov r3, #1								@ r3=1, Counter initialized
	mov r2, #9								@ r2=9 from (5/9)
	cmp r1, r2				  				@ Compare r1 to r3
	ble exit								@ If r1 is less than or equal to r3 exit
	bal scaleleft							@ Otherwise continue to scaleleft
	

scaleleft:	
	push {lr}								@ Push lr onto the stack
	mov r3, r3, lsl #1						@ Scale factor|Division counter 
	mov r2, r2, lsl #1						@ Subtraction|Mod/Remainder subtraction
	cmp r1, r2								@ Compare r1 with r2
	bge scaleleft							@ If r1 is greater than or equal to r5 loop to scaleleft
	mov r3, r3, asr #1						@ Otherwise Scale factor back
	mov r2, r2, asr #1 						@ and scale subtraction factor back
	bal addsub								@ Continue to addsub
	pop {lr}								@ Pop lr from the stack
	bx lr


addsub:
	push {lr}								@ Push lr onto the stack
	add r0, r0, r3							@ Count the subtracted scale factor
	sub r1, r1, r2							@ Subtract the scaled mod
	bal scaleright							@ Continue to scaleright
	pop {lr}								@ Pop lr from the stack
	bx lr


scaleright:
	push {lr}								@ Push lr onto the stack
	mov r3, r3, asr #1 						@ Division Counter
	mov r2, r2, asr #1						@ Mod/Remainder subtraction
	cmp r1, r2								@ Compare remainder (r1) with subtraction factor (r2)
	blt scaleright							@ If r1 is less than r5 return to scaleright
	bal addsubcomp							@ Otherwise go to addsubcomp
	pop {lr}								@ Pop lr from the stack
	bx lr
	

addsubcomp:	
	push {lr}								@ Push lr onto the stack
	cmp r3, #1 								@ Compare if r3 is greater than 1
	bge addsub								@ If r4 greater than 1 branch back to addsub
	pop {lr}								@ Pop lr from the stack
	bx lr
	
exit:
	pop {lr}								@ Pop lr from the stack
	bx lr
	
	
	
	
	.global main
main:

	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #4 								@ Make room for one 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user
												
	
												@ Enter Temperature in Fahrenheit
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 	ldr r0, address_of_format						@ r0 <- format
 	mov r1, sp 									@ Set variable of the stack as r1 (Temp in F)	
	bl scanf				         			@ call to scanf											
	
												@ Echo Results
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [sp] 								@ Load the integer temp in f read by scanf into r1
	ldr r0, address_of_message2 				@ Set &message2 as the first parameter of printf
	bl printf
												@ Prepare and send to convert function
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [sp] 								@ Load the temperature read by scanf into r1
	bl convert	                         		@ Branch out to Convert Function											
												
	
												@ Return Answer
	mov r1, r0                         			@ r1 <- r0 | convert function returning r0
	ldr r0, address_of_message3 				@ Set &message3 as the first parameter of printf
	bl printf	
												
												
	add sp, sp, #4								@ Discard the integer read by scanf
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr
	bx lr                                  		@ return from main using lr
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_format: .word format												
 
 .global scanf
 .global printf