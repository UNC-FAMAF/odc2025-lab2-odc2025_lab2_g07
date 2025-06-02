.globl pixel
.globl fila
.globl cuadrado
.globl triangulo_inf
.globl triangulo_sup
.globl cartel
.globl detalle_arena

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

detalle_arena:
    sub sp, sp, 48
    str x30, [sp, 40]
    str x4, [sp, 32]
    str x3, [sp, 24]
    str x2, [sp, 16]
    str x1, [sp, 8]
    str x0, [sp, 0]

    movz x0, 0xa6, lsl 16
    movk x0, 0x925d, lsl 0
    mov x1, 0
    mov x2, 270
    mov x3, 2
    mov x4, 2

yloop_in00:
    cmp x2, 480
    b.ge yloop_out00
    mov x1, 0
xloop_in00:
    cmp x1, 640
    b.ge xloop_out00
    bl cuadrado
    add x1, x1, 12
    b xloop_in00
xloop_out00:
    add x2, x2, 24
    b yloop_in00
yloop_out00:

    mov x1, 6
    mov x2, 282
yloop_in01:
    cmp x2, 480
    b.ge yloop_out01
    mov x1, 6
xloop_in01:
    cmp x1, 640
    b.ge xloop_out01
    bl cuadrado
    add x1, x1, 12
    b xloop_in01
xloop_out01:
    add x2, x2, 24
    b yloop_in01
yloop_out01:


    ldr x0, [sp, 0]
    ldr x1, [sp, 8]
    ldr x2, [sp, 16]
    ldr x3, [sp, 24]
    ldr x4, [sp, 32]
    ldr x30, [sp, 40]
    add sp, sp, 48
    br x30

cartel:                         // Esta Rutina dibuja un cartel que dice ODC 2025
    sub sp, sp, 48
    str x30, [sp, 40]
    str x4, [sp, 32]
    str x3, [sp, 24]
    str x2, [sp, 16]
    str x1, [sp, 8]
    str x0, [sp, 0]
    
    movz x0, 0x74, lsl 16
    movk x0, 0x5330, lsl 0
    
    mov x1, 450
    mov x2, 250
    mov x3, 35
    mov x4, 180
    bl cuadrado
    
    movz x0, 0x8a, lsl 16
    movk x0, 0x6642, lsl 0
    
    mov x1, 400
    mov x2, 260
    mov x3, 135
    mov x4, 40
    bl cuadrado

    bl texto
    
    mov x1, 535
    mov x2, 280
    mov x3, 20
    bl triangulo_inf
    
    bl triangulo_sup

    ldr x0, [sp, 0]
    ldr x1, [sp, 8]
    ldr x2, [sp, 16]
    ldr x3, [sp, 24]
    ldr x4, [sp, 32]
    ldr x30, [sp, 40]
    add sp, sp, 48
    br x30

texto:
    sub sp, sp, 64
    str x30, [sp, 56]
    str x10, [sp, 48]
    str x9, [sp, 40]
    str x4, [sp, 32]
    str x3, [sp, 24]
    str x2, [sp, 16]
    str x1, [sp, 8]
    str x0, [sp, 0]

    movz x0, 0x1c, lsl 16
    movk x0, 0x1610, lsl 0

    mov x9, x1
    mov x10, x2
//------------------ BASE DEL TEXTO --------------------
    add x1, x9, 5
    add x2, x10, 5
    mov x3, 15
    mov x4, 30
    bl cuadrado

    add x1, x1, 17
    bl cuadrado

    add x1, x1, 17
    bl cuadrado

    add x1, x1, 25
    bl cuadrado

    add x1, x1, 17
    bl cuadrado
    
    add x1, x1, 17
    bl cuadrado

    add x1, x1, 17
    bl cuadrado
//------------------ DARLE FORMA AL TEXTO --------------------

    movz x0, 0x8a, lsl 16
	movk x0, 0x6642, lsl 0
    
    //------------------ DARLE FORMA A LA O --------------------
    add x1, x9, 8
    add x2, x10, 8
    mov x3, 9
    mov x4, 24
    bl cuadrado

    //------------------ DARLE FORMA A LA d --------------------
    add x1, x9, 22
    add x2, x10, 5
    mov x3, 12
    mov x4, 15
    bl cuadrado
    
    add x1, x1, 3
    add x2, x2, 18
    mov x3, 9
    mov x4, 9
    bl cuadrado
    //------------------ DARLE FORMA A LA C --------------------
    add x1, x9, 42
    add x2, x10, 8
    mov x3, 12
    mov x4, 24
    bl cuadrado

    //------------------ DARLE FORMA AL PRIMER 2 --------------------
    add x1, x9, 64
    add x2, x10, 8
    mov x3, 12
    mov x4, 10
    bl cuadrado

    add x1, x1, 3
    add x2, x2, 13
    mov x3, 12
    mov x4, 11
    bl cuadrado

    //------------------ DARLE FORMA AL 0 --------------------
    add x1, x9, 84
    add x2, x10, 8
    mov x3, 9
    mov x4, 24
    bl cuadrado

    //------------------ DARLE FORMA AL SEGUNDO 2 --------------------
    add x1, x9, 98
    add x2, x10, 8
    mov x3, 12
    mov x4, 10
    bl cuadrado

    add x1, x1, 3
    add x2, x2, 13
    mov x3, 12
    mov x4, 11
    bl cuadrado

    //------------------ DARLE FORMA AL 5 --------------------
    add x1, x9, 118
    add x2, x10, 8
    mov x3, 12
    mov x4, 10
    bl cuadrado

    sub x1, x1, 3
    add x2, x2, 13
    mov x3, 12
    mov x4, 11
    bl cuadrado

    ldr x0, [sp, 0]
    ldr x1, [sp, 8]
    ldr x2, [sp, 16]
    ldr x3, [sp, 24]
    ldr x4, [sp, 32]
    ldr x9, [sp, 40]
    ldr x10, [sp, 48]
    ldr x30, [sp, 56]
    add sp, sp, 64
    br x30

