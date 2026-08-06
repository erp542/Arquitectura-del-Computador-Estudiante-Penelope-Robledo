.data
arreglo: .space 400 # Espacio para guardar 100 elementos en el arreglo.
cantidad_elementos: .asciiz "Cantidad de elementos: "
ingresar_elemento: .asciiz "Elemento: "
resultado: .asciiz "\nVector ordenado:\n"
espacio: .asciiz " "
salto: .asciiz "\n"

.text
.globl main

main:   li $v0, 4
	la $a0, cantidad_elementos
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	la $a0, arreglo
	move $a1, $s0
	jal  leer_arreglo
	la $a0, arreglo
	li $a1, 0
	addi $a2, $s0, -1
	jal quicksort
	li $v0, 4
	la $a0, resultado
	syscall
	la $a0, arreglo
	move $a1, $s0
	jal imprimir_arreglo
	li $v0, 10
	syscall

leer_arreglo: addi $sp, $sp, -8
              sw $ra, 4($sp)
              sw $s0, 0($sp)
              move $s0, $zero
              move $t0, $a0

ciclo_lectura: slt $t1, $s0, $a1
    	       beq $t1, $zero, fin_lectura
    	       li $v0, 4
    	       la $a0, ingresar_elemento
    	       syscall
    	       li $v0, 5
    	       syscall
    	       sw $v0, 0($t0)
    	       addi $t0, $t0, 4
    	       addi $s0, $s0, 1
    	       j ciclo_lectura

fin_lectura: lw $s0, 0($sp)
    	     lw $ra, 4($sp)
    	     addi $sp, $sp, 8
    	     jr $ra

imprimir_arreglo: addi $sp, $sp, -8
        	  sw $ra, 4($sp)
        	  sw $s0, 0($sp)
        	  move $s0, $zero
        	  move $t0, $a0

ciclo_imprimir: slt $t1, $s0, $a1
        	beq $t1, $zero, fin_imprimir
            	lw $t2, 0($t0)
            	li $v0, 1
            	move $a0, $t2
            	syscall
            	li $v0, 4
            	la $a0, espacio
            	syscall
            	addi $t0, $t0, 4
            	addi $s0, $s0, 1
            	j ciclo_imprimir

fin_imprimir: li $v0, 4
              la $a0, salto
              syscall
              lw $s0, 0($sp)
              lw $ra, 4($sp)
              addi $sp, $sp, 8
              jr $ra

swap: sll $t0, $a1, 2
      add $t0, $a0, $t0
      sll $t1, $a2, 2
      add $t1, $a0, $t1
      lw $t2, 0($t0)
      lw $t3, 0($t1)
      sw $t3, 0($t0)
      sw $t2, 0($t1)
      jr $ra

partition: addi $sp, $sp, -16
    	   sw $ra, 12($sp)
    	   sw $s2, 8($sp)
    	   sw $s1, 4($sp)
    	   sw $s0, 0($sp)
    	   move $s2, $a0 # v
    	   move $s1, $a2 # fin
    	   move $s0, $a1 # j
    	   sll $t0, $a2, 2
    	   add $t0, $s2, $t0
    	   lw $t9, 0($t0) # pivote
    	   addi $t8, $a1, -1 # i = inicio-1

ciclo_j: slt $t0, $s0, $s1
    	 beq $t0, $zero, fin_j
    	 sll $t1, $s0, 2
    	 add $t1, $s2, $t1
    	 lw  $t2, 0($t1)
    	 slt $t0, $t9, $t2
    	 bne $t0, $zero, incrementar_j
    	 addi $t8, $t8, 1
    	 move $a0, $s2
    	 move $a1, $t8
    	 move $a2, $s0
    	 addi $sp, $sp, -8
    	 sw $t8, 4($sp)
    	 sw $t9, 0($sp)
    	 jal swap
    	 lw $t9, 0($sp)
    	 lw $t8, 4($sp)
    	 addi $sp, $sp, 8

incrementar_j: addi $s0, $s0, 1
    	       j ciclo_j

fin_j: addi $t8, $t8, 1
       move $a0, $s2
       move $a1, $t8
       move $a2, $s1
       addi $sp, $sp, -4
       sw $t8, 0($sp)
       jal swap
       lw $v0, 0($sp)
       addi $sp, $sp, 4
       lw $s0, 0($sp)
       lw $s1, 4($sp)
       lw $s2, 8($sp)
       lw $ra, 12($sp)
       addi $sp, $sp, 16
       jr $ra

quicksort: slt $t0, $a1, $a2
           beq $t0, $zero, fin_quicksort
           addi $sp, $sp, -20
           sw $ra, 16($sp)
           sw $s3, 12($sp)
           sw $s2, 8($sp)
           sw $s1, 4($sp)
           sw $s0, 0($sp)
           move $s0, $a0 # v
           move $s1, $a1 # inicio
           move $s2, $a2 # fin
           jal partition
           move $s3, $v0 # pivote
           move $a0, $s0
           move $a1, $s1
           addi $a2, $s3, -1
           jal quicksort
           move $a0, $s0
           addi $a1, $s3, 1
           move $a2, $s2
           jal quicksort
           lw $s0, 0($sp)
           lw $s1, 4($sp)
           lw $s2, 8($sp)
           lw $s3, 12($sp)
           lw $ra, 16($sp)
           addi $sp, $sp, 20

fin_quicksort: jr $ra