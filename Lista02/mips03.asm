#Fa�a um programa que leia o conte�do das posi��es 0x00 e 0x04, e armazene o maior deles na
#posi��o 0x08.

.text 
	li $t0, 0
	li $t1, 2
	#lw $t0, 0($gp)
	#lw $t1, 4($gp)
	
	bgt $t0, $t1, desvia
	sw $t1, 8($gp)
	j end
desvia:
	sw $t0, 8($gp)
end:    