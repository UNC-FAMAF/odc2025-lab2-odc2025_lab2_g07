	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH,		480
	.equ FRANJA,     		10             
	.equ ALTO_CIELO,		270

	// COLORES RECOMENDADOS
	// COLOR ARENA 0xB09C66
	// COLOR PARTE SUPERIOR CIELO 0x101030 
	.globl fondo


	//---------------- DESIERTO ------------------------------------

desierto:						// Esta rutina dibuja el desierto de fondo del color x5
	sub sp, sp, 40				// Reserva lugar en el stack
	str x30, [sp, 32]			// Guarda la direccion desde donde se llamo a la rutina
	str x10, [sp, 24]			// Guarda los valores de los registros que voy a utilizar para no perder datos
	str x2, [sp, 16]			// ..
	str x1, [sp, 8]				// ..
	str x0, [sp, 0]				// ..
	
	movz x0, #0xA8C0, lsl #0       
	movk x0, #0x000A, lsl #16
	add x0, x20, x0                //Pongo el frame buffer debajo del horizonte
	mov x10, x5        //Defino color Arena

	mov x2, SCREEN_HEIGH         // Y Size
loop_1:
	mov x1, SCREEN_WIDTH         // X Size
loop_0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop_0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop_1  // Si no es la última fila, salto
	
	ldr x30, [sp, 32]			// Recupera la direccion desde donde se llamo a la rutina
	ldr x10, [sp, 24]			// Recupera los valores de entrada de los registros
	ldr x2, [sp, 16]			// ..
	ldr x1, [sp, 8]				// ..
	ldr x0, [sp, 0]				// ..
	add sp, sp, 32				// Libera el stack
	br x30						// Salta a la direccion desde donde se llamo a la rutina

	//---------------- CIELO ------------------------------------

cielo:							// Esta rutina dibuja el cielo de fondo con un degradado a partir del color x6
	sub sp, sp, 104				// Reserva lugar en el stack
	str x30, [sp, 96]			// Guarda la direccion desde donde se llamo a la rutina
	str x16, [sp, 88]			// Guarda los valores de los registros que voy a utilizar para no perder datos
	str x14, [sp, 80]			// ..
	str x12, [sp, 72]			// ..
	str x11, [sp, 64]			// ..
	str x10, [sp, 56]			// ..
	str x6, [sp, 48]			// ..
	str x5, [sp, 40]			// ..
	str x4, [sp, 32]			// ..
	str x3, [sp, 24]			// ..
	str x2, [sp, 16]			// ..
	str x1, [sp, 8]				// ..
	str x0, [sp, 0]				// ..
	
	mov x0, x20                  //Tomo de vuelta la direccion de inicio del buffer

	mov x10, x6      			//Defino color para parte superior cielo

	mov x2, FRANJA              //Contador para alto de franja
	mov x3, ALTO_CIELO			//Contador para saber donde termina el cielo
	mov x14, #2                 //Contador porque cada 3 columnas cambia de tamaño
	mov x16, FRANJA

loop2:  
	mov x2, FRANJA             	
	add x2, x2, x16            //Cambio el tamaño de la franja si el contador (cada 3 franjas cambia de tamaño) llego a 0
loop1:
	mov x1, SCREEN_WIDTH      
	
loop0:
	stur w10,[x0]          // Colorear el pixel N
	add x0,x0,4	      // Siguiente pixel
	sub x1,x1,1	     // Decrementar contador X
	cbnz x1,loop0       // Si no terminó la fila, salto (sigo pintando)

	sub x2,x2,1        // Decrementar contador alto franja porque termino la fila anterior
	sub x3,x3,1       // Decrementar contador alto cielo porque termino la fila anterior
	cbz x3, end  //Si fue la ultima linea de cielo, me voy.
	cbnz x2,loop1  	//Si no es la última fila de la franja, salto (sigo pintando) pero antes reestablezco el contador de x
	
	//Si termine la franja modifico el color
	mov x11 ,#13   //Esto es porque no deja multiplicar/dividir literales
	mov x12, #10 // Voy a multiplicar por x11 y dividir por x12, o sea multiplicar por 1.3
    and x4, x10, #0xFF     // Extraer bits 0-7  (blue del RGB)
    ubfx x5, x10, #8, #8   // Extraer bits 8-15 "copiar" desde bit 8, largo 8 bits   (green del RGB)
    ubfx x6, x10, #16, #8  // Extraer bits 16-23 "copiar" desde bit 16, largo 8 bit  (red del RGB)
    mul x4, x4, x11   //Multiplico por 99
	udiv x4, x4, x12 // Divido el resultado por 100 (division entera) 
	mul x5, x5, x11  //Multiplico por 99 
	udiv x5, x5, x12 // Divido el resultado por 10 (division entera) 
	mul x6, x6, x11  //Multiplico por 99
	udiv x6, x6, x12 // Divido el resultado por 10 (division entera)
	lsl x6,x6,#16  //Acomodo los bits en el lugar correspondiente al red en RGB
	lsl x5,x5,#8   //Acomodo los bits en el lugar correspondiente al geen del RGB
	mov x10,#0     //Aca vacio el color (lo hago 0) para poder copiar los componentes por separado
	orr x10, x6, x5 //Copio red y green
	orr x10,x10,x4  //Copio blue
	sub x14, x14, #1 //le resto uno al contador de franjas, a las 3 franjas cambia de tamaño

	
	cbnz x14, loop2  //Si todavia no pinte 3 franjas del mismo tamaño, sigo pintando (salto). Ya cambie el color. Reestablezco contador x y de altofranja
	mov x14, #2  //Si ya hice 3 franjas del mismo tamaño, reestablezco el contador
	add x16, x16, #15 //Agrego 15 al tamaño de la franja
	cbnz x3, loop2  //Si no es la ultima fila del cielo, ya cambie el color y tamaño, sigo pintando (salto) pero antes reestablezco los contadores x y de Altofranja
end:

	ldr x30, [sp, 96]			// Recupera la direccion desde donde se llamo a la rutina
	ldr x16, [sp, 88]			// Recupera los valores de entrada de los registros
	ldr x14, [sp, 80]			// ..
	ldr x12, [sp, 72]			// ..
	ldr x11, [sp, 64]			// ..
	ldr x10, [sp, 56]			// ..
	ldr x6, [sp, 48]			// ..
	ldr x5, [sp, 40]			// ..
	ldr x4, [sp, 32]			// ..
	ldr x3, [sp, 24]			// ..
	ldr x2, [sp, 16]			// ..
	ldr x1, [sp, 8]				// ..
	ldr x0, [sp, 0]				// ..
	add sp, sp, 104				// Libera el stack
	br x30						// Salta a la direccion desde donde se llamo a la rutina

fondo:							// Esta rutina dibuja el fondo del dibujo a partir de los colores x5 (arena), x6 (cielo)

	sub sp, sp, 8				// Reserva lugar en el stack
	str x30, [sp, 0]			// Guarda la direccion desde donde se llamo a la rutina

	bl desierto					// Dibuja el desierto

	bl detalle_arena			// Dibuja los detalles en la arena

	bl cielo					// Dibuja el cielo

	ldr x30, [sp, 0]			// Recupera la direccion desde donde se llamo a la rutina
	add sp, sp, 8				// Libera el stack
	br x30						// Salta a la direccion desde donde se llamo a la rutina

