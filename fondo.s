	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH,		480
	.equ FRANJA,     		10             
	.equ ALTO_CIELO,		270
	.equ BITS_PER_PIXEL,  	32
	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main
//COLOR ARENA B09C66

main:
	// x0 contiene la direccion base del framebuffer

 	mov x20, x0	         // Guarda la dirección base del framebuffer en x20

	//---------------- DESIERTO ------------------------------------
	
	movz x10, 0xB0, lsl 16        //Defino color Arena
	movk x10, 0x9C66, lsl 00      //Defino color Arena

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
  

	//---------------- CIELO ------------------------------------
	mov x0, x20                  //Tomo de vuelta la direccion de inicio del buffer

	movz x10, 0x10, lsl 16      //Defino color para parte superior cielo
	movk x10, 0x1030, lsl 00    //Defino color para parte superior cielo

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
	cbz x3, InfLoop  //Si fue la ultima linea de cielo, me voy.
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

	//------------------Infinite Loop-----------------------------------

InfLoop:
	b InfLoop
