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
 denominator_read: .word 0
 
 .balign 4
 return: .word 0
 
 .balign 4
 return2: .word 0
 
 .text
 
    .global main
 main:
 	ldr r1, address_of_return					@ r1 <- address_of_return
 	str lr, [r1]					 			@ *r1 <- lr
	
 
@ Numerator Input and Format
 
 	ldr r0, address_of_message1					@ r0 <- message1
 	bl printf					 				@ call to printf
 
 	ldr r0, address_of_scan_pattern				@ r0 <- scan_pattern
 	ldr r1, address_of_numerator_read			@ r1 <- numerator_read
	bl scanf				         			@ call to scanf
	
	ldr r0, address_of_numerator_read    		@ r2 <- numerator_read
	ldr r2, [r0]                         		@ r2 <- *r2
 	
@ Denominator Input and Format
 	
 	ldr r0, address_of_message2			 		@ r0 <- message2
 	bl printf					 		 		@ call to printf
 	
 	ldr r0, address_of_scan_pattern		        @ r0 <- scan_pattern
 	ldr r1, address_of_denominator_read		 	@ r1 <- denomintator_read
 	bl scanf				        		 	@ call to scanf
 	
	ldr r0, address_of_denominator_read  		@ r3 <- denominator_read
	ldr r3, [r0]                         		@ r3 <- *r3
	
	bl division                          		@ Branchout to Division Funtion
  
 
@ Output Results 

	mov r4, r2                            		@ r4 <- r2
	ldr r1, address_of_numerator_read     		@ r1 <- numerator_read
	ldr r1, [r1]                          		@ r2 <- *r2
	ldr r0, address_of_message3           		@ r0 <- message3
	
	mov r5, r3                            		@ r5 <- r3
	ldr r3, address_of_denominator_read   		@ r3 <- denominator_read
	ldr r3, [r3]                          		@ r3 <- *r3
	ldr r0, address_of_message4           		@ r1 <- message4
	
	bl printf									@ return from main using lr
 
	ldr lr, address_of_return              		@ lr <- address_of_return
	ldr lr, [lr]                           		@ lr <- *lr
	bx lr                                  		@ return from main using lr
 
 
 @ Division Function
 
 division:
	ldr r1, address_of_return2           	@ r1 <- address_of_return
	str lr, [r1]				  			@ *r1 <- lr
											
											@ Register Initilization
	mov r0, #0								@ r0=0
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
	mov r4, r4, asr #1						@ Otherwise Scale factor back
	mov r5, r5, asr #1 						@ and scale subtraction factor back
	bal addsub								@ Continue to addsub

addsub:
	add r0, r0, r4							@ Count the subtracted scale factor
	sub r1, r1, r5							@ Subtract the scaled mod
	bal scaleright							@ Continue to scaleright
	
addsubcomp:	
	cmp r4, #1 								@ Compare if r4 is greater than 1
	bgt addsub								@ If r4 greater than 1 branch back to addsub

scaleright:
	mov r4, r4, asr #1 						@ Division Counter
	mov r5, r5, asr #1						@ Mod/Remainder subtraction
	cmp r1, r5								@ Compare remainder (r1) with subtraction factor (r5)
	blt scaleright							@ If r1 is less than r5 return to scaleright
	bal addsubcomp							@ Otherwise go to addsubcomp
	
exit:
	ldr lr, address_of_return2
	ldr lr, [lr]
	bx lr
	address_of_return2: .word return2	
 
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 address_of_scan_pattern: .word scan_pattern
 address_of_numerator_read: .word numerator_read
 address_of_denominator_read: .word denominator_read
 address_of_return: .word return
 
 @ External
.global printf
.global scanf
