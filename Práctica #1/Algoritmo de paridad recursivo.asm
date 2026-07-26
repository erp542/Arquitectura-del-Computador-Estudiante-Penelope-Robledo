.data
entrada: .asciiz "Ingrese un numero entero positivo: "
salida: .asciiz "Resultado: "
resultado_par: .asciiz "El numero es par."
resultado_impar: .asciiz "El numero es impar."
salto_linea: .asciiz "\n"

.text
.globl main

main:	li $v0, 4
	la $a0, entrada
	syscall
	li $v0, 5
	syscall
	move $a0, $v0
	jal paridad
	move $t0, $v0
	li $v0, 4
	la $a0, salida
	syscall
	beq $t0, $zero, es_par
	li $v0, 4
	la $a0, resultado_impar
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	li $v0, 10
	syscall

es_par:	li $v0, 4
	la $a0, resultado_par
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	li $v0, 10
	syscall

paridad: addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	slti $t0, $a0, 1
	beq $t0, $zero, caso_recursivo
	# Caso base
	li $v0, 0
	addi $sp, $sp, 8
	jr $ra

caso_recursivo:	addi $a0, $a0, -1
		jal paridad
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		li $t1, 1
		sub $v0, $t1, $v0
		jr $ra
	
	