/*
 *
 * Start and End Time will be controlled here
 *
 */
 
 
.data
message: .asciz "Start Time: %d\nEnd Time: %d\nDiffrence: %d\n"
starts: .word 0


.text

	.global starts
starts:
	push {lr}
	
	mov r0, #0						/* Set time to zero */
	bl time
	ldr r2, address_of_start		/* Set address of start as the third parameter of start */
	str r0, [r2]					/* Store start time in r2 */
	
	pop {lr}
	bx lr



	.global ends
ends:
	push {lr}
	
	mov r0, #0						/* Set time to zero */
	bl time
	
	mov r2, r0						/* Move r0/end time to r2 */
	ldr r1, address_of_start		/* Set start address the second parameter of ends */
	ldr r1, [r1]					/* Load the start time to r1 */
	sub r3, r2, r1					/* r3 = end time - start time
	
	ldr r0, address_of_message			/* Load answer to r0 */
	bl printf						/* Print message with start, ends, and diffrece of time
	
	pop {lr}
	bx lr
	
address_of_message: .word message
address_of_start: .word starts
	
	.global time
	.global printf