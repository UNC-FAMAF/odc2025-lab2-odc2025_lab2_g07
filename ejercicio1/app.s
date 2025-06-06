	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------
	movz x5, 0xb0, lsl 16			// Defino el color del desierto
	movk x5, 0x9c66, lsl 0			// ..

	movz x6, 0x10, lsl 16			// Defino el color del cielo
	movk x6, 0x1030, lsl 0			// ..

	movz x7, 0x8a, lsl 16			// Defino el color del cartel
	movk x7, 0x6642, lsl 0			// ..

	movz x8, 0xc8, lsl 16			// Defino el color de la nube
	movk x8, 0xcbca, lsl 0			// ..

	movz x9, 0x82, lsl 16			// Defino el color de las estrellas
	movk x9, 0xa1b1, lsl 0			// ..

	movz x10, 0x14, lsl 16			// Defino el color del cactus cercano
	movk x10, 0x6f15, lsl 00		// ..

	movz x11, 0x16, lsl 16			// Defino el color de los relieves del cactus cercano
	movk x11, 0x3d13, lsl 00		// ..
	
	movz x12, 0x18, lsl 16			// Defino el color del cactus lejano
	movk x12, 0x3016, lsl 00		// ..	

	mov x1, 450			// Defino la posicion inicial de la nube
	mov x2, 50			// ..

	mov x3, 100			// Defino la posicion inicial de la nube2
	mov x4, 200			// ..

	bl fondo				// Dibuja el fondo
	bl estrellas			// Dibuja las estrellas
	bl cartel				// Dibuja el carte de OdC 2025
	bl nube					// Dibuja la nueve es su nueva posicion
	bl nube2
	bl dibuja_cactus
	bl cactus2
InfLoop:
	b InfLoop
