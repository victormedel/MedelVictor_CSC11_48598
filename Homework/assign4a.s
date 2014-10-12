/*
 * Author: Victor Medel
 * Created On: October 10, 2014
 * Purpose: Assignment 4
 *
 */
 
 .data
 
 /* Numerator Input */
 .balign 4
 message1: .asciz "Please type the numerator: "
 
 /* Echo Numerator */
 .balign 4
 message2: .asciz "I read the number %d\n"
 
  /* Denominator Input */
 .balign 4
 message3: .asciz "Please type the denominator: "
 
 /* Echo Denominator */
 .balign 4
 message4: .asciz "I read the number %d\n"
 
 /* Quotient Output */
 .balign 4
 message5: .asciz "Your Quotient is %d\n"
 
 /* Remainder Output */
 .balign 4
 message6: .asciz "Your Remainder is %d\n" 
 
 /* Format pattern for scanf */
 .balign 4
 scan_patter: .asciz "%d"
 
 /* Where scanf will store the number read */
 .balign 4
 number_read: .word 0
 
 .balign 4
 return: .word 0
 
 
 .text
 
	.global main
 main:
 
 ldr r1, address_or_return			/* r1 <- address_of_return */
 str lr, [r1]					/* r1 <- lr */
 
 ldr r0, address_of_message1			/* r0 <- message1 */
 bl printf					/* call to printf */
 
 ldr r0, address_of_scan_pattern		/* r0 <- scan_pattern */
 ldr r1, address_of_number_read			/* r1 <- number read */
 bl scanf					/* call to scanf */
 
 

 
 
 
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_scan_patter: .word scan_pattern
 address_of_number_read: .word number_read
 address_of_return: .word return
 
 /* External */
 .global printf
 .global scanf
