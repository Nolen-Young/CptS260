.data
list: .word 4
asciiZero: .byte '0'
exp: .space 30

# the polling is sort of working but I can't seem to extract the correct numbers from the array that the numbers are stored in.
# if you can see what is wrong with it that would be greatly appreciated

.text
main:
	addi $s0, $0, 113 
	lui $t0, 0xFFFF   #$t0 = 0xFFFF0000
	li $t3, 0


getEquation:
	poll:                 # polling procedure
		lw $t1, 0($t0) 
		andi $t1, $t1, 0x0001
		beq $t1, $zero, poll 

	lw $a0, 4($t0)    # load word into register $a0
	la $t2, list
	move $t4, $t3
	sll $t4, $t1, 2
	add $t2, $t2, $t4
	sw $a0, ($t2) # store into an array. In this case all 4 characters fit into one memory word
	addi $t3, $t3, 1 #increment counter
	blt $t3, 4, getEquation #get 4 character presses
	
	#convert first num from char to a num
	la $t2, list
	addi $sp, $sp, -4
	sw $t0, ($sp) # store array address
	lw $a0, ($t2)
	jal char2num
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	move $s1, $v0
	
	#second number convert
	la $t2, list
	addi $sp, $sp, -8
	sw $t0, ($sp) # store array address
	sw $s1, 4($sp)
	lw $a0, 2($t2)
	jal char2num
	lw $s1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8
	move $s2, $v0
	
	add $s3, $s1, $s2 #final result is in $s3
	
	li $v0, 10
	syscall
	
	
char2num:
	lb $t0, asciiZero
	subu $v0, $a0, $t0
	jr $ra
	
num2char:
	lb $t0, asciiZero
	addu $v0, $a0, $t0
	jr $ra