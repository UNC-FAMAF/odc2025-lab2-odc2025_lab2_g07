.globl pixel
.globl fila
.globl cuadrado
.globl triangulo_inf
.globl triangulo_sup
.globl cartel

pixel:                      // Esta rutina pinta de color x0 el pixel que se encuentra en la posicion (x,y) con x=x1, y=x2
    sub sp, sp, 16          // Reserva lugar en el stack
    str x30, [sp, 8]        // Guarda la direccion de la instruccion desde donde se llamo a la rutina
    str x9, [sp, 0]         // Guarda el valor del registro X9 por si tenia algun uso fuera de la rutina

    mov x9, 640             // X9 = 640 (Obtendre la direccion del pixel a partir de x e y con el metodo visto en clase)
    mul x9, x2, x9          // X9 = y*640
    add x9, x1, x9          // X9 = x+(y*640)
    lsl x9, x9, 2           // X9 = 4*(x+(y*640))
    add x9, x20, x9         // X9 = Direccion de inicio + 4*(x+(y*640))
    stur w0, [x9]           // Pinta el pixel (x,y) con el color almacenado en x0

    ldr x9, [sp, 0]         // Recupero el valor original de x9
    ldr x30, [sp, 8]        // Recupero la direccion de la instruccion desde donde se llamo a la rutina
    add sp, sp, 16          // Libero el stack
    br x30                  // Vuelvo a la direccion desde donde se llamo a la rutina

fila:                       // Esta rutina pinta una fila de color x0, de ancho x3 > 0, comenzando en la posicion (x1, x2)
    sub sp, sp, 24          // Reserva lugar en el stack
    str x30, [sp, 16]       // Guarda la direccion de la instruccion desde donde se llamo a la rutina
    str x3, [sp, 8]         // Guarda el ancho que le fue indicado
    str x1, [sp, 0]         // Guarda la posicion inicial del eje x1=x

xloop:
    bl pixel                // Pinta un pixel en la posicion (x1, x2) actual
    add x1, x1, 1           // Cambia a la columna derecha
    sub x3, x3, 1           // Decrementa el contador del tramo sin pintar
    cbnz x3, xloop          // Si todavia hay tramo sin pintar vuelvo a empezar

    ldr x1, [sp, 0]         // Recupero el valor inicial del eje x 
    ldr x3, [sp, 8]         // Recupero el ancho que fue indicado inicialmente
    ldr x30, [sp, 16]       // Recupero la direccion de la instruccion desde donde se llamo a la rutina
    add sp, sp, 24          // Libero el stack
    br x30                  // Vuelvo a la direccion desde donde se llamo a la rutina

cuadrado:                   // Esta rutina pinta un cuadrado de color x0, de ancho x3 > 0 y alto x4 > 0 a partir de la posicion (x1, x2) (cuadrado de x1+x3 * x2+x4)
    sub sp, sp, 24
    str x30, [sp, 16]
    str x4, [sp, 8]
    str x2, [sp, 0]
yloop:
    bl fila
    add x2, x2, 1
    sub x4, x4, 1
    cbnz x4, yloop

    ldr x2, [sp, 0]
    ldr x4, [sp, 8]
    ldr x30, [sp, 16]
    add sp, sp, 24
    br x30

triangulo_inf:              // Esta rutina dibuja un triangulo rectangulo de color x0, de ancho y alto x3 > 0 a partir de la posicion (x1, x2) hacia abajo
    sub sp, sp, 24
    str x30, [sp, 16]
    str x3, [sp, 8]
    str x2, [sp, 0]

tiloop:
    bl fila
    add x2, x2, 1
    sub x3, x3, 1
    cbnz x3, tiloop

    ldr x2, [sp, 0]
    ldr x3, [sp, 8]
    ldr x30, [sp, 16]
    add sp, sp, 24
    br x30

triangulo_sup:              // Esta rutina dibuja un triangulo rectangulo de color x0, de ancho y alto x3 > 0 a partir de la posicion (x1, x2) hacia arriba
    sub sp, sp, 24
    str x30, [sp, 16]
    str x3, [sp, 8]
    str x2, [sp, 0]

tsloop:
    bl fila
    sub x2, x2, 1
    sub x3, x3, 1
    cbnz x3, tsloop

    ldr x2, [sp, 0]
    ldr x3, [sp, 8]
    ldr x30, [sp, 16]
    add sp, sp, 24
    br x30

cartel:                         // Esta Rutina dibuja un cartel que dice ODC 2025
    sub sp, sp, 8
    str x30, [sp]
    
    movz x0, 0x73, lsl 16
  	movk x0, 0x400d, lsl 0

	  mov x1, 450
	  mov x2, 250
	  mov x3, 35
	  mov x4, 180
	  bl cuadrado

	  movz x0, 0x90, lsl 16
	  movk x0, 0x5010, lsl 0

	  mov x1, 400
	  mov x2, 260
	  mov x3, 135
	  mov x4, 40
	  bl cuadrado

	  mov x1, 535
	  mov x2, 280
	  mov x3, 20
	  bl triangulo_inf

	  bl triangulo_sup

    ldr x30, [sp]
    add sp, sp, 8
    br x30

