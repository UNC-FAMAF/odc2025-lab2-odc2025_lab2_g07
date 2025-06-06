	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  		32

	// COLOR ARENA 0xB09C66
	// COLOR PARTE SUPERIOR CIELO 0x101030
	// COLOR CARTEL 0x8a6642
	// COLOR NUBE 0xc8cbca
	// COLOR ESTRELLAS 0x82a1b1
	// COLOR CACTUS CERCANO 0x146f15
	// COLOR DETALLES CACTUS CERCANO 0x163d13
	// COLOR CACTUS LEJANO 0x181016

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


movAll:						// Para simular movimiento hare un loop que en cada iteracion vuelve a pintar los objetos de la escena por con modificaciones

	bl oscurecer_desierto			// Oscurece los colores de la escena para simular el anochecer
	bl oscurecer_cielo			// ..
	bl oscurecer_cartel			// ..
	bl oscurecer_nubes			// ..
	bl oscurecer_cactus1			// ..
	bl oscurecer_cactus1_relieves		// ..
	bl oscurecer_cactus2			// ..

	mov x18, 8				// La idea es que la nube se mueva 8px antes de orcurecer la escena

	sub x3, x3, 2

movNube:					// Este loop diferencia el movimiento de la nube al cambio de color de fondo
	bl fondo				// Dibuja el fondo
	bl estrellas				// Dibuja las estrellas
	bl cartel				// Dibuja el carte de OdC 2025
	bl nube					// Dibuja la nueve es su nueva posicion
	bl nube2
	bl dibuja_cactus
	bl cactus2

	movz x19, 0x100, lsl 16		// Esta seccion inicia una un contador con un numero grande y lo va decrementando hasta llegar a 0
delay:					// La idea es generar un pequeño delay para que se puedan observar los cambios intermedios
	sub x19, x19, 1			// Decrementa el contador
	cbnz x19, delay			// Si no es 0 vuelve a decrementar

	sub x1, x1, 1			// Mueve la nube un pixel a la izquierda
	sub x18, x18, 1			// Decrementa el contador que indica los 8px que se movera la nube
	cbnz x18, movNube		// Si todavia no se movio 8px vuelvo a decrementar
	
	cmp x1, 90			// Si la nube no llego al lado izquierdo de la pantalla vuelvo a repetir el proceso
	b.ge movAll			// ..

b skip

oscurecer_desierto:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 95			// Esto es porque no deja multiplicar/dividir literales
    mov x14, 100		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.95

    and x15, x5, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x5, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x5, 16, 8		// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  	// Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   	// Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x5, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x5, x17, x16		// Copio red y green
    orr x5, x5, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_cielo:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 9999		// Esto es porque no deja multiplicar/dividir literales
    mov x14, 10000		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.9999

    and x15, x6, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x6, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x6, 16, 8		// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16 	// Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   	// Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x6, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x6, x17, x16		// Copio red y green
    orr x6, x6, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_cartel:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 95			// Esto es porque no deja multiplicar/dividir literales
    mov x14, 100		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.95

    and x15, x7, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x7, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x7, 16, 8		// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  	// Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   	// Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x7, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x7, x17, x16		// Copio red y green
    orr x7, x7, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_nubes:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 95			// Esto es porque no deja multiplicar/dividir literales
    mov x14, 100		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.99

    and x15, x8, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x8, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x8, 16, 8		// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  // Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   // Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x8, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x8, x17, x16		// Copio red y green
    orr x8, x8, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_cactus1:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 95			// Esto es porque no deja multiplicar/dividir literales
    mov x14, 100		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.95

    and x15, x10, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x10, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x10, 16, 8	// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  	// Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   	// Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x10, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x10, x17, x16		// Copio red y green
    orr x10, x10, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_cactus1_relieves:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 95			// Esto es porque no deja multiplicar/dividir literales
    mov x14, 100		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.99

    and x15, x11, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x11, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x11, 16, 8	// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  // Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   // Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x11, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x11, x17, x16		// Copio red y green
    orr x11, x11, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

oscurecer_cactus2:

    sub sp, sp, 48		// Reserva lugar en el stack
    str x30, [sp, 40]		// Guarda la direccion desde donde se llamo a la rutina
    str x17, [sp, 32]		// Guarda los valores de los registros que voy a utilizar para no perder datos
    str x16, [sp, 24]		// ..
    str x15, [sp, 16]		// ..
    str x14, [sp, 8]		// ..
    str x13, [sp, 0]		// ..

    mov x13, 9995		// Esto es porque no deja multiplicar/dividir literales
    mov x14, 10000		// Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 0.9995

    and x15, x12, 0xff		// Extraer bits 0-7  (blue del RGB)
    ubfx x16, x12, 8, 8		// Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x17, x12, 16, 8	// Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    
    mul x15, x15, x13		// Multiplico por 99
    udiv x15, x15, x14		// Divido el resultado por 100 (division entera) 
    mul x16, x16, x13		// Multiplico por 99 
    udiv x16, x16, x14		// Divido el resultado por 10 (division entera) 
    mul x17, x17, x13		// Multiplico por 99
    udiv x17, x17, x14		// Divido el resultado por 10 (division entera)
	
    lsl x17, x17, 16  // Acomodo los bits en el lugar correspondiente al red en RGB
    lsl x16, x16, 8   // Acomodo los bits en el lugar correspondiente al geen del RGB
	
    mov x12, 0			// Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
    orr x12, x17, x16		// Copio red y green
    orr x12, x12, x15		// Copio blue

    ldr x13, [sp, 0]		// Recupera los valores de entrada de los registros
    ldr x14, [sp, 8]		// ..
    ldr x15, [sp, 16]		// ..
    ldr x16, [sp, 24]		// ..
    ldr x17, [sp, 32]		// ..
    ldr x30, [sp, 40]       	// Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          	// Libera el stack
    br x30                  	// Salta a la direccion desde donde se llamo a la rutina

skip:

InfLoop:
	b InfLoop
