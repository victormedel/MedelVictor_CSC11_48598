/*
 * Author: Victor Medel
 * Created On: October 19, 2014
 * Purpose: Input and Output Division Program
 * Assignment 5
 *
 */
 
.data
 message1: .asciz "Type numerator and then denominator: "
 message2: .asciz "You typed %d for the numerator and %d for the denominator \n"
 message3: .asciz "Your Answer is %d with a remainder of %d\n" 
 scan_pattern: .asciz "%d %d"

 .text
 
	.global division
division:
	push {lr}								@ Push lr onto the stack
											@ The stack is now 8 byte aligned
	movs r6, r2
	movs r2, r1								@ Keep a copy of the numerator value from r0 in r2
	movs r3, r6								@ Keep a copy of the numerator value from r1 in r3
											
											@ Register Initilization
											
	mov r4, #1								@ r4=1, Counter initialized
	mov r5, r3								@ r5=r3, Set r5 equal to denominator
	mov r1, r2								@ r1=r2, Set r1 equal to numerator
	
	cmp r1, r3				  				@ Compare r1 to r3
	ble exit								@ If r1 is less than or equal to r3 exit
	bal scaleleft							@ Otherwise continue to scaleleft
	
	.global scaleleft
scaleleft:	
	push {lr}								@ Push lr onto the stack
	mov r4, r4, lsl #1						@ Scale factor|Division counter 
	mov r5, r5, lsl #1						@ Subtraction|Mod/Remainder subtraction
	cmp r1, r5								@ Compare r1 with r5
	bge scaleleft							@ If r1 is greater than or equal to r5 loop to scaleleft
	mov r4, r4, lsr #1						@ Otherwise Scale factor back
	mov r5, r5, lsr #1 						@ and scale subtraction factor back
	bal addsub								@ Continue to addsub
	pop {lr}								@ Pop lr from the stack
	bx lr

	.global addsub
addsub:
	push {lr}								@ Push lr onto the stack
	add r0, r0, r4							@ Count the subtracted scale factor
	sub r1, r1, r5							@ Subtract the scaled mod
	bal scaleright							@ Continue to scaleright
	pop {lr}								@ Pop lr from the stack
	bx lr

	.global scaleright
scaleright:
	push {lr}								@ Push lr onto the stack
	mov r4, r4, lsr #1 						@ Division Counter
	mov r5, r5, lsr #1						@ Mod/Remainder subtraction
	cmp r1, r5								@ Compare remainder (r1) with subtraction factor (r5)
	blt scaleright							@ If r1 is less than r5 return to scaleright
	bal addsubcomp							@ Otherwise go to addsubcomp
	pop {lr}								@ Pop lr from the stack
	bx lr
	
	.global addsubcomp
addsubcomp:	
	push {lr}								@ Push lr onto the stack
	cmp r4, #1 								@ Compare if r4 is greater than 1
	bge addsub								@ If r4 greater than 1 branch back to addsub
	pop {lr}								@ Pop lr from the stack
	bx lr
	
exit:
	pop {lr}								@ Pop lr from the stack
	bx lr
 
    .global main
main:
	str lr, [sp,#-4]! 							@ Push lr onto the top of the stack
	sub sp, sp, #8 								@ Make room for two 4 byte integer in the stack
												@ In these 4 bytes we will keep the number
												@ entered by the user
	
												@ Numerator Input
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 	ldr r0, address_of_scan_pattern				@ r0 <- scan_pattern
 	mov r2, sp 									@ Set variable of the stack as b	
	add r1, r2, #4								@ and second value as a of scanf	
	bl scanf				         			@ call to scanf											
	
												@ Echo Results
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [r1]								@ Load the integer a read by scanf into r1
	ldr r2, [sp] 								@ Load the integer b read by scanf into r2
	ldr r0, address_of_message2 				@ Set &message2 as the first parameter of printf
	bl printf
												@ Prepare and send to division function
	add r1, sp, #4               				@ Place sp+4 -> r1
	ldr r1, [r1]								@ Load the integer a read by scanf into r1
	ldr r2, [sp] 								@ Load the integer b read by scanf into r2
	bl division                          		@ Branchout to Division Funtion
												
	mov r2, r1                            		@ r2 <- r1 | division function returning r1 for quotient
	mov r1, r0                         			@ r1 <- r0 | division function returning r0 for remainder
	ldr r0, address_of_message3 				@ Set &message3 as the first parameter of printf
	bl printf
 
	add sp, sp, #8								@ Discard the integer read by scanf
	ldr lr, [sp], #+4 							@ Pop the top of the stack and put it in lr
	bx lr                                  		@ return from main using lr
 

 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_scan_pattern: .word scan_pattern
