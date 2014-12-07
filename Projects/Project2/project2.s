/* 
 * Author: Victor Medel
 * Created on December 6, 2014
 * CSC11 Project 2 - Simple Game of Black Jack
 *
 */
 
 .data
 
 message1: .asciz "You have $50. Place your bet to start the game: $"
 message2: .asciz "\nYou placed a bet of $%f"
 message3: .asciz "\nYou have been dealt the following card(s):\n"
 message4: .asciz "Your current score is %d\n"

 message5: .asciz "\nThe House has been dealt the following card(s):\n"
 message6: .asciz "The house's score is %d\n"

 message7: .asciz "Would you like another card? (0 for yes, 1 for no): "
 message8: .asciz "\The house has been dealt the following additional cards:\n"
 
 
 face: .asciz "%d of "
 suit: .asciz "%d |"
 
 win: .asciz "You Win!\n"
 lose: .asciz "You Lose\n"
 
 clubs: .asciz "Clubs | "
 diamonds: .asciz "Diamonds | "
 hearts: .asciz "Hearts | "
 spades: .asciz "Spades | "
 
 ace: .asciz "Ace of "
 jack: .asciz "Jack of "
 queen: .asciz "Queen of "
 king: .asciz "King of "
 
 format: .asciz "%d"
 bet_format: .asciz "%f"
 
 .text
									@ Start of Randomize Division
 division:
	push {lr} 						@ Push lr onto the stack
									@ Determine the quotient and remainder
	mov r0,#0
	mov r3,#1
	cmp r1,r2
	blt end
	bl scaleLeft
	bl addSub
 
 scaleRight:
	push {lr} 						@ Push lr onto the stack
		doWhile_r1_lt_r2: 			@ Shift right until just under the remainder
			mov r3,r3,ASR #1; 		@ Division counter
			mov r2,r2,ASR #1 		@ Mod/Remainder subtraction
			cmp r1,r2
			blt doWhile_r1_lt_r2
	pop {lr} 						@ Pop lr from the stack
	bx lr 							


 addSub:
	push {lr} 						@ Push lr onto the stack
	doWhile_r3_ge_1:
		add r0,r0,r3
		sub r1,r1,r2
		bl scaleRight
		cmp r3,#1
		bge doWhile_r3_ge_1
	pop {lr}						 @ Pop lr from the stack
	bx lr 							 

	
 scaleLeft:
	push {lr} 						@ Push lr onto the stack
		doWhile_r1_ge_r2: 			@ Scale left till overshoot with remainder
			mov r3,r3,LSL #1 		@ scale factor
			mov r2,r2,LSL #1 		@ subtraction factor
			cmp r1,r2
			bge doWhile_r1_ge_r2 	@ End loop at overshoot
	mov r3,r3,ASR #1 				@ Scale factor back
	mov r2,r2,ASR #1 				@ Scale subtraction factor back
	pop {lr} 						@ Pop lr from the stack
	bx lr							

	
end:
	pop {lr} 						@ Pop lr from the stack
	bx lr 				
									@ End of Randomizer Division
 
									@ Suit Selection
 
suit1:
	cmp r1, #1
	ble clubs
	bal suit2

suit2:
	cmp r1, #2
	ble diamonds
	bal suit3

suit3:
	cmp r1, #3
	ble hearts
	bal suit4

suit4:
	cmp r1, #4
	ble spades
	bal exit

clubs:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_clubs		@ Set clubs as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	
	
diamonds:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_diamonds		@ Set diamonds as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	


hearts:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_hearts		@ Set hearts as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	

spades:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_spades		@ Set spades as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
 
									@End of Suit Selection
				
									@Ace, Jack, Queen, and King Selection
				
face1:
	cmp r1, #1
	ble ace
	bal face2

face2:
	cmp r1, #14
	bge king
	bal face3

face3:
	cmp r1, #13
	bge queen
	bal face4

face4:
	cmp r1, #12
	bge jack
	bal face5

face5:
	cmp r1, #11
	bge ace
	bal regular
	
									@ Ace, Jack, Queen , and King Selection
ace:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_ace			@ Set ace as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	
	
jack:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_jack			@ Set jack as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	


queen:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_queen		@ Set queen as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	

king:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_king			@ Set king as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	
regular:
	push {lr} 						@ Push lr onto the stack
	ldr r0, address_of_face			@ Set face as the first parameter of printf
	bl printf 						@ Call printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 		
 
									@ End Ace, Jack, Queen , and King Selection
 
									@ Card Selector
 card_face:	 						@ Create a random number
	push {lr} 						@ Push lr onto the stack
	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#14 						@ Move 14 to r2
									@ We want rand()%14+1 so cal division function with rand()%14
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 14
	mov r5, r1
	bl face1
	bl card_suit
	
	pop {lr} 						@ Pop lr from the stack
	bx lr 
	
 card_suit:	
	push {lr} 						@ Push lr onto the stack
	
	bl rand 						@ Call rand
	mov r1,r0,asr #1 				@ In case random return is negative
	mov r2,#4 						@ Move 4 to r2
									@ We want rand()%4+1 so call division function with rand()%4
	bl division						@ Call division function to get remainder
	add r1,#1 						@ Remainder in r1 so add 1 giving between 1 and 4
	mov r10, r1
	bl suit1
	
	pop {lr} 						@ Pop lr from the stack
	bx lr 
	
 ask:
	str lr, [sp,#-4]! 				@ Push lr onto the top of the stack
	sub sp, sp, #4 					@ Make room for one 4 byte integer in the stack
									@ In these 4 bytes we will keep the number
									@ entered by the user
	
 	ldr r0, address_of_message7		@ r0 <- message6
 	bl printf					 	@ call to printf
 	ldr r0, address_of_format		@ r0 <- scan_pattern
 	mov r1, sp 						@ Set variable of the stack as 	
	bl scanf				        @ call to scanf	
	
	add r1, sp, #4               	@ Place sp+4 -> r1
	ldr r1, [sp] 					@ Load the integer b read by scanf into r2
	bl compare
	
	add sp, sp, #4					@ Discard the integer read by scanf
	ldr lr, [sp], #+4 				@ Pop the top of the stack and put it in lr
	bx lr                           @ return from main using lr

 compare:	
	push {lr} 						@ Push lr onto the stack
	cmp r1, #0
	beq additionalpc
	bne comparehouse
	pop {lr} 						@ Pop lr from the stack
	bx lr 
	
 comparehouse
	push {lr} 						@ Push lr onto the stack
	cmp r8, #16
	blt additionalhc
	pop {lr} 						@ Pop lr from the stack
	bx lr 
 
 additionalpc:
	push {lr} 						@ Push lr onto the stack
									@ Additional card dealt to the player
	ldr r0, address_of_message3		@ Set message3 as the first parameter of printf
	bl printf 						@ Call printf	
	bl card_face
		
	cmp r5, #11
	movgt r5, #10
	
	add r7, r7, r5					@ Add player's score and print it out
	mov r1, r7
	ldr r0, address_of_message4		@ Set message4 as the first parameter of printf
	bl printf
	bl comparehouse
	pop {lr} 						@ Pop lr from the stack
	bx lr 	
	
 additionalhc:
	push {lr} 						@ Push lr onto the stack
									@ Additional card dealt to the player
	ldr r0, address_of_message5		@ Set message5 as the first parameter of printf
	bl printf 						@ Call printf	
	bl card_face
		
	cmp r5, #11
	movgt r5, #10
	
	add r8, r8, r5					@ Add player's score and print it out
	mov r1, r8
	ldr r0, address_of_message6		@ Set message6 as the first parameter of printf
	bl printf
	pop {lr} 						@ Pop lr from the stack
	bx lr 		
 
 	
  .global main
 main:
 
	push {lr}	 					@ Push lr onto the top of the stack	
	mov r0,#0 						@ Set time(0)
	bl time 						@ Call time 
	bl srand 						@ Call srand
	
									@ Initial cards dealt to the player
	ldr r0, address_of_message3		@ Set message3 as the first parameter of printf
	bl printf 						@ Call printf	
	
	bl card_face
	mov r5, r5
	bl card_face
	mov r6, r5
	
	cmp r5, #11
	movgt r5, #10
	cmp r6, #11
	movgt r6, #10
	
	add r7, r6, r5					@ Add player's score and print it out
	mov r1, r7
	ldr r0, address_of_message4		@ Set message4 as the first parameter of printf
	bl printf
 
									@ Initial cards dealt to the house
	ldr r0, address_of_message5		@ Set message5 as the first parameter of printf
	bl printf 						@ Call printf	
	
	bl card_face
	mov r5, r5
	bl card_face
	mov r6, r5
	
	cmp r5, #11
	movgt r5, #10
	cmp r6, #11
	movgt r6, #10
	
	add r8, r6, r5					@ Add house's score and print it out
	mov r1, r8
	ldr r0, address_of_message6		@ Set message6 as the first parameter of printf
	bl printf
	bl ask
	
	
scorecomp0:							@ The following compare numonics are used to compare score and determine winner
	cmp r7, #21
	ble housescore
	bgt youlose
	
housescore:
	cmp r8, #21
	ble scorecomp
	bgt youwin
	
scorecomp:
	cmp r7, r8
	bgt youwin
	blt youlose
	
youwin:	
	ldr r0, address_of_win
	bl printf
	bal exit

youlose:
	ldr r0, address_of_lose
	bl printf
	bal exit
	
	@add r4,#1
	@cmp r4,#1						@ How many hands do you want the dealer to deal?
	@blt face1

exit:	
	pop {lr} 						@ Pop the top of the stack and put it in lr
	bx lr 							@ Leave main
	
	
	
 
 address_of_message1: .word message1
 address_of_message2: .word message2
 address_of_message3: .word message3
 address_of_message4: .word message4
 address_of_message5: .word message5	 
 address_of_message6: .word message6
 address_of_message7: .word message7
 address_of_message8: .word message8

 address_of_face: .word face
 address_of_suit: .word suit
 
 address_of_win: .word win
 address_of_lose: .word lose
 
 address_of_clubs: .word clubs
 address_of_diamonds: .word diamonds
 address_of_hearts: .word hearts
 address_of_spades: .word spades
 
 address_of_ace: .word ace
 address_of_jack: .word jack
 address_of_queen: .word queen
 address_of_king: .word king
 
 									@ External Functions
 .global printf
 .global time
 .global srand
 .global rand