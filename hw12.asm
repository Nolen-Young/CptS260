.data
bufferExp: .space 30
bufferExpLength: .word 0
asciiZero: .byte '0'

.text

#Turn on the transmitter control
lui $t0, 0xFFFF
lw $t1, 8($t0)
ori $t1, $t1, 0x0001
sw $t1, 8($t0)

#Turn on the receiver control
lui $t0, 0xFFFF
lw $t1, 0($t0)
ori $t1, $t1, 0x0002
sw $t1, 0($t0)

main:

mainLoop:
lw $t5, bufferExpLength
addi $s0, $s0, 1
addi $s0, $s0, -1
beq $t5, 4, Terminate
j mainLoop


Terminate:
li $v0, 10
syscall

#HANDLER
myHandler:
# save all my things
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $t0, 4($sp)
sw $t1, 0($sp)

jal StoreChar

lw $t0, bufferExpLength
addi $t0, $t0, 1
sw $t0, bufferExpLength

jal Display 

bne $t0, 4, B1
jal Evaluate
B1:

# recover
lw $t1, 0($sp)
lw $t0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12

jr $ra



StoreChar:
#save
addi $sp, $sp, -12
sw $ra, 8($sp)
sw $t5, 4($sp)
sw $t3, 0($sp)

lw $t3, 0xFFFF0004 #word to be loaded in $t3
la $t5, bufferExp

sw $t3, 0($t5)

addi $t5, $t5, 4

#recover
lw $t3, 0($sp)
lw $t5, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12

jr $ra

Evaluate:
#save
addi $sp, $sp, -20
sw $ra, 0($sp)
sw $t0, 16($sp)
sw $t1, 12($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)


# load 
la $t1, bufferExp
lw $t0, 4($t1) 
lw $t2, 8($t1)

addi $t0, $t0, -48 
addi $t2, $t2, -48 

add $t3, $t0, $t2
add $t3, $t3, 48

sw $t3, 0xFFFF000c


#recover
lw $t3, 4($sp)
lw $t2, 8($sp)
lw $t1, 12($sp)
lw $t0, 16($sp)
lw $ra, 0($sp)
addi $sp, $sp, 20

jr $ra

Display:
#save
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $t0, 4($sp)
sw $t1, 8($sp)

la $t0, bufferExp
addi $t0, $t0, -4
lw $t1, bufferExp
sw $t1, 0xFFFF000c

addi $t0, $t0, 4

#recover

lw $t1, 8($sp)
lw $t0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 12

jr $ra


.kdata
save_s0: .word 0
save_ra: .word 0
save_t0: .word 0
save_t1: .word 0
save_t5: .word 0

.ktext 0x80000180 # interupt
# save
sw $t0, save_t0
sw $t1, save_t1
sw $t5, save_t5
sw $s0, save_s0
sw $ra, save_ra

la $k0, myHandler
jalr $k0

APPLE: 
#clear cause reg again
mtc0 $zero, $13
mfc0 $t0, $12
andi $t0, 0x111D
ori $t0, 0x0001
mtc0 $t0, $12

#recover
lw $t0, save_t0
lw $t1, save_t1
lw $t5, save_t5
lw $s0, save_s0
lw $ra, save_ra 
eret