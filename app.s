	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH,		480
	
	.equ FRANJA,     10



	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer

 	mov x20, x0								// Guarda la dirección base del framebuffer en x20

	//---------------- CODE HERE ------------------------------------

	movz x10, 0x0, lsl 16
	movk x10, 0xbfff, lsl 00

	mov x2, FRANJA         
	mov x3, SCREEN_HEIGH
	

loop1:
	mov x1, SCREEN_WIDTH
loop2:
	
	mov x11 ,#9
	mov x12, #10 
	mov x2, FRANJA

    	and x4, x10, #0xFF // Extraer bits 0-7
    	ubfx x5, x10, #8, #8   // Extraer bits 8-15desde bit 8, largo 8 bits
    	ubfx x6, x10, #16, #8  // Extraer bits 16-23 (RR) desde bit 16, largo 8 bits


    	mul x4, x4, x11
	udiv x4, x4, x12 // Divido el resultado por 10 (división entera) 

	mul x5, x5, x11
	udiv x5, x5, x12 // Divido el resultado por 10 (división entera) 

	mul x6, x6, x11
	udiv x6, x6, x12 // Divido el resultado por 10 (división entera)

	lsl x6,x6,#16
	lsl x5,x5,#8

	mov x10,#0
	orr x10, x6, x5
	orr x10,x10,x4



loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	sub x3,x3,1
	
	cbz x2,loop2  	// Si no es la última fila, salto
	cbnz x3,loop1	// Si no se llega al final de la ventana, saltamos

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop
