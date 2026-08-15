.data
LuzControl: .word 0
LuzEstado: .word 0
LuzDatos: .word 0
inicio: .asciiz "Inicializando sensor de luminosidad.\n"
sensorListo: .asciiz "Sensor listo.\n"
mensajeErrorInicializacion: .asciiz "Error de hardware durante la inicializacion.\n"
valorLeido: .asciiz "Luminosidad leida: "
mensajeErrorLectura: .asciiz "Error en la lectura del sensor.\n"
salto: .asciiz "\n"

.text
.globl main

main: la $a0, inicio
      li $v0, 4
      syscall
      jal InicializarSensorLuz
      move $t0, $v0
      li $t1, -1
      beq $t0, $t1, errorInicializacion
      la $a0, sensorListo
      li $v0, 4
      syscall
      jal LeerLuminosidad
      move $t0, $v0
      move $t1, $v1
      li $t2, -1
      beq $t1, $t2, errorLectura
      la $a0, valorLeido
      li $v0, 4
      syscall
      move $a0, $t0
      li $v0, 1
      syscall
      la $a0, salto
      li $v0, 4
      syscall
      j fin
      
errorInicializacion: la $a0, mensajeErrorInicializacion
		      li $v0, 4
		      syscall
		      j fin
		      
errorLectura: la $a0, mensajeErrorLectura
	       li $v0, 4
	       syscall

fin: li $v0, 10
     syscall
     
InicializarSensorLuz: li $t0, 1
		      la $t1, LuzControl
		      sw $t0, 0($t1)
		      la $t1, LuzEstado
		      
espera: lw $t2, 0($t1)
	      beq $t2, $zero, espera
	      li $t3, -1
	      beq $t2, $t3, errorHardware
	      li $v0, 0
	      jr $ra
	      
errorHardware: li $v0, -1
	  jr $ra
	  
LeerLuminosidad: la $t0, LuzEstado
		 lw $t1, 0($t0)
		 li $t2, -1
		 beq $t1, $t2, retornoErrorLectura
		 la $t0, LuzDatos
		 lw $v0, 0($t0)
		 li $v1, 0
		 jr $ra
		 
retornoErrorLectura: li $v0, 0
	       move $v1, $t2
	       jr $ra