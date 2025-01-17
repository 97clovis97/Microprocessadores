.include "graphics.inc"

.text
.globl main
main: 

    	#CHAMA DRAW GRID
    	li $a0, 35
   	li $a1, 35
    	la $a2, draw_grid
    	jal draw_grid    
    	hlt: b hlt

    	#TESTE DRAW SPRITE
    	li   $t8,0
    	li   $t9,0
    	main2:
    	move $a0,$t8
    	move $a1,$t9
    	li   $a2,14
    	jal  draw_sprite
    	addi $t8, $t8, 1
	
    	## DELAY(50)
    	li $v0, 32
    	li $a0, 50
    	syscall
	
    	##=========
    	b main2
    
    
# draw_grid(width, height, grid_table)
.globl draw_grid
draw_grid:

# i = gridTable
# for (y=0; y<height; y++)
#   for (x=0, x<width; x++)
#     sprite = *(i++)
#     drawSprite (x*7, y*7, sprite)

# |-----------|
# | empty     | 36 ($sp)
# | $ra       | 32 ($sp)
# | $s4       | 28 ($sp)
# | $s3       | 24 ($sp)
# | $s2       | 20 ($sp)
# | $s1       | 16 ($sp)
# | $s0       | 12 ($sp)
# | $a2       | 8 ($sp)
# | $a1       | 4 ($sp)
# | $a0       | 0 ($sp)
# |-----------|
#s0  = width, s1 = 


	addi $sp, $sp, -40  #pilha criada
	sw $a0, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $ra, 32($sp)		
	
	add $s1, $a0, $zero	# x_max = largura passada
	add $s2, $zero, $zero	# y = 0
	add $s3, $a1, $zero	# y_max = altura passada
	add $s4, $a2, $zero		
	
d_for_y:
	bge $s2, $s3 end_d_for_y
	li $s0, 0 # x = 0
	
d_for_x:
	lb $t0, ($s4)
	addi $a2, $t0, -64
		
	bge $s0, $s1, end_d_for_x
		
	mul $a0, $s0, X_SCALE
	mul $a1, $s2, Y_SCALE
	jal draw_sprite
		
	addi $s0, $s0, 1
	addi $s4, $s4, 1
		
	j d_for_x
	
end_d_for_x:
	addi $s2, $s2, 1
		
	j d_for_y

end_d_for_y:
	lw $a0, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $ra, 32($sp)				
	addi $sp, $sp, 40	
	jr $ra

# draw_sprite(X, Y, sprite_id)
.globl draw_sprite
draw_sprite:

# i = &sprites + sprite_id*SPRITE_SIZE
# for (y = y0; y < (y0+7); y++)
#   for (x = x0; x < (x0+7); x++)
#      	color = translateColor (*i)
#      	drawPixel (x, y, color)
#      	i++
  
# |-----------|
# | empty     | 36 ($sp)
# | $ra       | 32 ($sp)
# | $s4       | 28 ($sp)
# | $s3       | 24 ($sp)
# | $s2       | 20 ($sp)
# | $s1       | 16 ($sp)
# | $s0       | 12 ($sp)
# | $a2       | 8 ($sp)
# | $a1       | 4 ($sp)
# | $a0       | 0 ($sp)
# |-----------|
  
	addi $sp, $sp, -40
	sw $a0, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $ra, 32($sp)	#pilha inicializada

	add $s0, $a0, $zero # x = a0 + 0 -> a0 = posi��o x passada para a fun��o
	addi $s1, $s0, 7 # x_max = x + 7		cada bloco � composto por 7 pixels
	add $s2, $a1, $zero # y = a1 + 0 -> a0 = posi��o y passada para a fun��o
	addi $s3, $s2, 7 # y_max = y + 7		cada bloco � composto por 7 pixels
	
	la $t0, sprites	# t0 = &sprite
	mul $t1, $a2, SPRITE_SIZE # t1 = sprite_id * tamanho maximo
	add $s4, $t0, $t1		


#for (y = y0; y < (y0+7); y++)	
for_y: 
	bge $s2, $s3, end_for_y
for_x:
	bge $s0, $s1, end_for_x
		
	lb $a0, ($s4)	#carrega em a0 o valor do byte i
	jal mostra_cor
	
	add $a0, $s0, $zero
	add $a1, $s2, $zero
	add $a2, $v0, $zero
	jal set_pixel			#set_pixel(a0 = x, a1 = y, a2 = cor
		
	addi $s0, $s0, 1
	addi $s4, $s4, 1
		
	j for_x
	
	end_for_x:
	add $s0, $s0, -7 #x = x0
	add $s2, $s2, 1	 # y++ -> x retorna ao valor inicial e y aumenta
		
	j for_y

end_for_y:
	lw $a0, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $ra, 32($sp)	#carrega o valor armazenado na pilha para os registradores
	addi $sp, $sp, 40 #apaga a pilha ao mover o pointer para a posi��o acima da sua origem
	jr $ra

#set_pixel(X, Y, color)
.globl set_pixel
set_pixel:

  	la  $t0, FB_PTR
  	mul $a1, $a1, FB_XRES
  	add $a0, $a0, $a1
   	sll $a0, $a0, 2
   	add $a0, $a0, $t0
   	sw $a2, 0($a0)
   	jr $ra
mostra_cor:
	
	sll $t0, $a0, 2	#byte da cor *4 transforma inteiro
	la $t1, colors	#t1 = &colors
	add $t2, $t0, $t1 # t2 = endere�o base de colors mais o valor do da cor desejada
	lw $v0, ($t2)
	jr $ra