/*
 * Author: Victor Medel
 * Created On: October 10, 2014
 * Purpose: Input and Output Division Program
 * Assignment 4
 *
 */
 
 .data
 
@@ Numerator Input @@
 .balign 4
 message1: .asciz "Please type your numerator: "
 
@@ Denominator Input @@
 .balign 4
 message2: .asciz "Please type your denominator: "
 
@@ Quotient Output @@
 .balign 4
 message3: .asciz "Your Quotient is %d\n"
 
@@ Remainder Output @@
 .balign 4
 message4: .asciz "Your Remainder is %d\n" 
 
@@ Format pattern for scanf @@
 .balign 4
 scan_pattern: .asciz "%d"

@@ Where scanf will store the numbers read @@
 
 .balign 4
 numerator_read: .word 0
 
 .balign 4
 demoninator_read: .word 0
 
 .balign 4
 return: .word 0
 
 .balign 4
 return2: .word 0
 
 .balign 4
 return3: .word 0  @@ Might need this return @@
 
 
 .text
 
@ Division Function
 
 division:
	ldr r1, address_of_return2           	@ r1 <- address_of_return
	str lr, [r1]				  			@ *r1 <- lr
	cmp r1, r3				  				@ compare r1 to r3
	bge scaleleft				  			@ If r1 is greater than or equal to r3 then go to scale left
	bx lr					  				@ otherwise exit
 
scaleleft:
	mov r4, r4, lsl #1						@ Scale factor
	mov r5, r5, lsl #1						@ Subtraction factor
	cmp r1, r5								@ Compare r1 with r5
	bge scaleleft							@ If r1 is greater than or equal to r5 loop back to scaleleft
	mov r4, r4, asr #1						@ Otherwise Scale factor back
	mov r5, r5, asr #1 						@ and scale subtraction factor back
	bal addsub								@ Continue division function by branching to addsub
	

addsub:
	add r0, r0, r4							@ Count the subtracted scale factor
	sub r1, r1, r5							@ Subtract the scaled mod
	bal scaleright							@ Keep scaling right until less than remainder
	
addsubcomp:	
	cmp r4, #1 								@ Compare if r4 is greater than 1
	bgt addsub								@ If r4 greater than 1 branch to addsub
	bx lr									@ Otherwise exit

scaleright:
	mov r4, r4, asr #1 						@ Division Counter
	mov r5, r5, asr #1						@ Mod/Remainder subtraction
	cmp r1, r5								@ Compare remainder (r1) with subtraction factor (r5)
	bgt scaleright							@ If r1 is greater than r5 return to scaleright
	bal addsubcomp							@ Otherwise go to addsubcomp
 
    .global main
 main:
 
	mov r2, #0					 				@ numerator initialization r2 = 0
	mov r3, #0					 				@ denominator initialization r3 = 0
	mov r4, #1					 				@ r4 = 1
	mov r5, r3					 				@ r5 = denominator (r3) 
	mov r0, #0								    @ Quotient r0 initialized to 0
	mov r1, r2					 				@ Remainder r1 = r2 
 
 	ldr r1, address_or_return					@ r1 <- address_of_return
 	str lr, [r1]					 			@ *r1 <- lr
 
@ Numerator Input
 
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 
 	ldr r0, address_of_scan_pattern				@ r0 <- scan_pattern
 	ldr r2, address_of_numerator_read			@ r2 <- numerator
 	bl scanf				         			@ call to scanf
 	
@ Denominator Input
 	
 	ldr r0, address_of_message2			 		@ r0 <- message2
 	bl printf					 		 		@ call to printf
 	
 	ldr r0, address_of_scan_pattern		        @ r0 <- scan_pattern
 	ldr r3, address_of_denominator_read		 	@ r3 <- denomintator
 	bl scanf				        		 	@ call to scanf
 	
@ Format Input for Calculation 
 	
	ldr r2, address_of_numerator_read    		@ r0 <- numerator_read
	ldr r3, address_of_denominator_read  		@ r1 <- denominator_read
	ldr r2, [r2]                         		@ r2 <- *r2
	ldr r3, [r3]                         		@ r3 <- *r3
	bl division                          		@ Branchout to Division Funtion
  
 
@ Output Results 

	mov r4, r0                            		@ r4 <- r0
	mov r5, r1                            		@ r5 <- r1
	ldr r2, address_of_numerator_read     		@ r2 <- numerator_read
	ldr r2, [r2]                          		@ r2 <- *r2
	ldr r3, address_of_denominator_read   		@ r3 <- denominator_read
	ldr r3, [r3]                          		@ r3 <- *r3
	ldr r0, address_of_message3           		@ r0 <- message3
	ldr r1, address_of_message4           		@ r1 <- message4
	bl printf
 
 
 
	ldr lr, address_of_return              		@ lr <- address_of_return
	ldr lr, [lr]                           		@ lr <- *lr
	bx lr                                  		@ return from main using lr
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 address_of_scan_patter: .word scan_pattern
 address_of_numerator_read: .word numerator_read
 address_of_denominator_read: .word denominator_read
 address_of_return: .word return
 
 @ External
	.global printf
	.global scanf
