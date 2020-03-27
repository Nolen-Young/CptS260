.text

main:
	la $a0, A
	addi $a2, $a0, 24
	move $a1, $a0
	jal quicksort
	
	li $v0, 10
	syscall
		
quicksort:
	#save
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	bgt $a1, $a2, exit
		jal partition
		move $a2, $v0
		jal quicksort
		move $a1, $a2
		addi $a1, $a1, 1
		lw $a2, 12($sp)
		jal quicksort
	exit:
	#recover
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	jr $ra

partition:
	lw $s0, 0($a1)
	move $s1, $a1
	addi $s1, $s1, -4
	move $s2, $a2
	addi $s2, $s2, 4
	loop:
		loop1:
			addi $s1, $s1, 4
			la $t0, 0($s1)
		bge $t0, $s0, loop1
		
		loop2:
			addi $s2, $s2, -4
			la $t1, 0($s2)
		ble $t1, $s0, loop2
		
		blt $s1, $s2, if
			move $v0, $s2
			jr $ra
		if:
		
		sw $t0, 0($s2)
		sw $t1, 0($s1)
	j loop
	

.data
A: .word 10, 2, 17, 9, 6, 4, 8