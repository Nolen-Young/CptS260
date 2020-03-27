.text
li $t0, 'a'
#set up for reading in string
la $a0, string
li $a1, 64
li $v0, 8
#read in string
syscall
move $s0, $a0
#get end of string address
addi $s0, $s0, 63

#find 'a' loop
LOOP1:
lb $t1, 0($s0)
beq $t0, $t1, EXIT
addi $s0, $s0, -1
j LOOP1
EXIT:

# move all characters down 1
LOOP2:
lb $t1, 0($s0)
lb $t2, 1($s0) #character above s0
beqz $t1, EXIT2
sb $t2, 0($s0)
addi $s0, $s0, 1
j LOOP2
EXIT2:

la $a0, string
li $v0, 4
syscall



#kill yourself
li $v0, 10
syscall

.data
string: .space, 64