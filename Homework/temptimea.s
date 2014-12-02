/*
 * Author: Victor Medel
 * Created On: November 11, 2014
 * Assignment 7a
 * Purpose: Convert via Input Fahrenheit to Celsius.
 *
 */
 
 .data
 
 begTime: .word 0
 endTime: .word 0
 
 message1: .asciz "Converting 50 degrees Fahrenheit in a Loop of 1000000"
 message2: .asciz "Total Time: %d seconds"

 
 
 .text

loop:
	ldr r6, =1000000
	
    mov r0, #0								@ begTime=time(0)
    bl time									@ Time function
    ldr r7, address_of_begTime				@ Point r7 to address of begTime
    str r0, [r7]							@ Store the beginning of time in r7
	bal for

for:
	cmp r6, #0								@ Does r6 = 0
	beq exit								@ If it does exit
	bal convert								@ Otherwise continue to convert function

convert:
	push {lr}								@ Push lr onto the stack
											@ The stack is now 4 byte aligned
	sub r6, r6, #1							@ r6 = r6 - 1
	mov r1, #50								@ Initialize temperature for test purposes
	mov r5, #5								@ r5=5
	sub r1, r1, #32							@ r1=(input-32)
	mul r1, r5, r1							@ r1=r1*r5									
	bl division 
	pop {lr}								@ Pop lr from the stack
	bx lr

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
	bge addsub								@ If r3 greater than 1 branch back to addsub
	bal for
	pop {lr}								@ Pop lr from the stack
	bx lr
	
exit:
    mov r0, #0	 							@endTime=time(0);
    bl time
    ldr r7, address_of_endTime
    str r0, [r7]
	pop {lr}								@ Pop lr from the stack
	bx lr
	
	
	
	
	.global main
main:									
												
 	ldr r0, address_of_message1					@ Setup and printout message 1
	bl printf
	
	bl loop	                         			@ Branch out to Loop Function											
												
												@ Result
	ldr r2, address_of_endTime
    ldr r2, [r2]
    ldr r1, address_of_begTime
    ldr r1, [r1]
    sub r1, r2, r1
    ldr r0, address_of_message2
    bl printf
												
	bx lr                                  		@ return from main using lr
 
 address_of_message1: .word message1
 address_of_message2: .word message2

 address_of_begTime: .word begTime
 address_of_endTime: .word endTime
 
 .global scanf
 .global printf
 .global time