#Fa�a um programa que leia 3 notas dos endere�os 0x00, 0x04 e 0x08 e, sabendo que a m�dia �
#7, armazene 1 no endere�o 0x0C caso ele esteja aprovado ou no endere�o 0x10 caso ele esteja
# reprovado.


.text
        
	lw $t0, 0($gp)
	lw $t1, 4($gp)
	lw $t2, 8($gp)
	li $t3, 1
	
	add $t0, $t0, $t1
	add $t0, $t1, $t2
	div $t1, $t0, 3
	bge $t1, 7, aprovado
	sw $t1, 16($gp)
	j end

aprovado:
	  sw $t3, 12($gp)
end:
