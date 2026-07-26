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

paridad: li $v0, 0

ciclo:	beq $a0, $zero, fin
	li $t0, 1
	sub $v0, $t0, $v0
	addi $a0, $a0, -1
	j ciclo

fin:	jr $ra
	
	