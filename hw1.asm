.data
str1: .asciiz "Hello World\n"
.text
la $a0, str1
li $v0, 4
syscall
li $v0, 10
syscall