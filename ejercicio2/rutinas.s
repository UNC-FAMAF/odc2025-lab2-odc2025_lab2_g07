.globl pixel
.globl fila
.globl cuadrado
.globl triangulo_inf
.globl triangulo_sup
.globl cartel
.globl detalle_arena
.globl nube
.globl nube2

// COLORES RECOMENDADOS
// COLOR ARENA 0xB09C66
// COLOR CARTEL 0x8a6642
// COLOR NUBE 0xc8cbca

//--------------------- UTILIDADES -----------------------------------------

pixel:                      // Esta rutina pinta de color x0 el pixel que se encuentra en la posicion (x,y) con x=x1, y=x2
    
    sub sp, sp, 16          // Reserva lugar en el stack
    str x30, [sp, 8]        // Guarda la direccion desde donde se llamo a la rutina
    str x9, [sp, 0]         // Guarda los valores de los registros que voy a utilizar para no perder datos

    mov x9, 640             // X9 = 640 (Obtendre la direccion del pixel a partir de x e y con el metodo visto en clase)
    mul x9, x2, x9          // X9 = y*640
    add x9, x1, x9          // X9 = x+(y*640)
    lsl x9, x9, 2           // X9 = 4*(x+(y*640))
    add x9, x20, x9         // X9 = Direccion de inicio + 4*(x+(y*640))
    stur w0, [x9]           // Pinta el pixel (x,y) con el color almacenado en x0

    ldr x9, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x30, [sp, 8]        // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 16          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


fila:                       // Esta rutina pinta una fila de color x0, de ancho x3 > 0, comenzando en la posicion (x1, x2)
    
    sub sp, sp, 24          // Reserva lugar en el stack
    str x30, [sp, 16]       // Guarda la direccion desde donde se llamo a la rutina
    str x3, [sp, 8]         // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x1, [sp, 0]         // ..

xloop:
    bl pixel                // Pinta un pixel en la posicion (x1, x2) actual
    add x1, x1, 1           // Cambia a la columna derecha
    sub x3, x3, 1           // Decrementa el contador del ancho sin pintar
    cbnz x3, xloop          // Si todavia hay ancho sin pintar continuo pintando

    ldr x1, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x3, [sp, 8]         // ..
    ldr x30, [sp, 16]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 24          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


cuadrado:                   // Esta rutina pinta un cuadrado de color x0, de ancho x3 > 0 y alto x4 > 0 a partir de la posicion (x1, x2) (cuadrado de x1+x3 * x2+x4)
    
    sub sp, sp, 24          // Reserva lugar en el stack
    str x30, [sp, 16]       // Guarda la direccion desde donde se llamo a la rutina
    str x4, [sp, 8]         // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x2, [sp, 0]         // ..

yloop:
    bl fila                 // Pinta una fila de ancho x3
    add x2, x2, 1           // Pasa a la fila de abajo
    sub x4, x4, 1           // Decrementa el contador del alto sin pintar
    cbnz x4, yloop          // Si todavia hay alto sin pintar continuo pintando

    ldr x2, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x4, [sp, 8]         // ..
    ldr x30, [sp, 16]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 24          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


triangulo_inf:              // Esta rutina dibuja un triangulo rectangulo de color x0, de ancho y alto x3 > 0 a partir de la posicion (x1, x2) hacia abajo
    sub sp, sp, 24          // Reserva lugar en el stack
    str x30, [sp, 16]       // Guarda la direccion desde donde se llamo a la rutina
    str x3, [sp, 8]         // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x2, [sp, 0]         // ..

tiloop:
    bl fila                 // Pinta una fila de ancho x3 (la forma en la que dibuja consiste en apilar filas de distintos anchos)
    add x2, x2, 1           // Pasa a la fila de abajo
    sub x3, x3, 1           // Decrementa el contador del alto sin pintar
    cbnz x3, tiloop         // Si todavia hay alto sin pintar continuo pintando

    ldr x2, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x3, [sp, 8]         // ..
    ldr x30, [sp, 16]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 24          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina

triangulo_sup:              // Esta rutina dibuja un triangulo rectangulo de color x0, de ancho y alto x3 > 0 a partir de la posicion (x1, x2) hacia arriba
    sub sp, sp, 24          // Reserva lugar en el stack
    str x30, [sp, 16]       // Guarda la direccion desde donde se llamo a la rutina
    str x3, [sp, 8]         // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x2, [sp, 0]         // ..

tsloop:
    bl fila                 // Pinta una fila de ancho x3 (la forma en la que dibuja consiste en apilar filas de distintos anchos) 
    sub x2, x2, 1           // Pasa a la fila de arriba
    sub x3, x3, 1           // Decrementa el contador del alto sin pintar
    cbnz x3, tsloop         // Si todavia hay alto sin pintar continuo pintando

    ldr x2, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x3, [sp, 8]         // ..
    ldr x30, [sp, 16]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 24          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


//--------------------- COMPLEMENTOS A OTROS DIBUJOS -----------------------------------------

detalle_arena:              // Esta rutina dibuja unos detalles en la arena a partir del color x5

    sub sp, sp, 48          // Reserva lugar en el stack
    str x30, [sp, 40]       // Guarda la direccion desde donde se llamo a la rutina
    str x4, [sp, 32]        // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x3, [sp, 24]        // ..
    str x2, [sp, 16]        // ..
    str x1, [sp, 8]         // ..
    str x0, [sp, 0]         // ..

    mov x0, x5              // Setea el color en x0 para modificarlo

    lsr x1, x0, 8           // Lleva el color verde a los bits menos significativos de x1
    lsr x2, x0, 16          // Lleva el color rojo a los bits menos significativos de x2

    and x0,  x0, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x0 quede el azul y el resto 0
    and x1,  x1, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x1 quede el verde y el resto 0
    and x2,  x2, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x0 quede el rojo y el resto 0

    mov x3, 9               // Quiero multiplicar por 9 y dividir por 10
    mov x4, 10              // O sea multiplica por 0.9 cada color para oscurecerlo

    mul x0, x0, x3          // Multiplico por 0.9, decrementa el numero que indica el color azul (la idea es oscurecerlo)
    udiv x0, x0, x4         // ..
    mul x1, x1, x3          // Multiplico por 0.9, decrementa el numero que indica el color azul (la idea es oscurecerlo)
    udiv x1, x1, x4         // ..
    mul x2, x2, x3          // Multiplico por 0.9, decrementa el numero que indica el color rojo (la idea es oscurecerlo)
    udiv x2, x2, x4         // ..

    lsl x1, x1, 8           // Pone al color verde en los bits 15 - 8
    lsl x2, x2, 16          // Pone al color rojo en los bits 23 - 16 

    orr x0, x0, x1          // Le agrega al color azul la parte verde faltante
    orr x0, x0, x2          // Le agrega al color azul y verde la parte roja faltante (y queda compuesto un color mas oscuro que el x5 de entrada)
    
    mov x1, 0               // Pone al indicador del eje x en 0
    mov x2, 270             // Pone al indicador del eje y en 270
    mov x3, 2               // Setea el ancho para cuadrados y filas en 2px
    mov x4, 2               // Setea el alto para cuadrados en 2px

                            // Esta parte dibuja muchos cuadrados de 2px y color x0 en una zona de 640px x 210px para simular textura en la arena
yloop_in00:                 
    cmp x2, 480             // Si todavia no termino de pintar la columna continua
    b.ge yloop_out00        // Si ya pinto todas las columnas termina
    mov x1, 0               // Reicia el indicador de eje x volviendo a pintar desde el borde de la pantalla
xloop_in00:                 
    cmp x1, 640             // Si todavia no termino de pintar la fila continua
    b.ge xloop_out00        // Si ya pinto toda la fila pasa a otra
    bl cuadrado             // Pinta un cuadrado en la posicion (x1, x2) actual
    add x1, x1, 12          // Pasa a pintar otra columna dejando espacio de por medio
    b xloop_in00            // Sigue pintando la fila
xloop_out00:
    add x2, x2, 24          // Pasa a pintar otra fila dejando espacio de por medio
    b yloop_in00            // Sigue pintando la columna
yloop_out00:

                            // Esta parte hace lo mismo que la enterior solo que con otro equiespaciado
    mov x1, 6
    mov x2, 282

yloop_in01:
    cmp x2, 480             // Si todavia no termino de pintar la columna continua
    b.ge yloop_out01        // Si ya pinto todas las columnas termina
    mov x1, 6               // Reicia el indicador de eje x volviendo a pintar desde 6px a la derecha del borde de la pantalla
xloop_in01:
    cmp x1, 640             // Si todavia no termino de pintar la fila continua 
    b.ge xloop_out01        // Si ya pinto toda la fila pasa a otra
    bl cuadrado             // Pinta un cuadrado en la posicion (x1, x2) actual
    add x1, x1, 12          // Pasa a pintar otra columna dejando espacio de por medio
    b xloop_in01            // Sigue pintando la fila
xloop_out01:
    add x2, x2, 24          // Pasa a pintar otra fila dejando espacio de por medio
    b yloop_in01            // Sigue pintando la columna
yloop_out01:


    ldr x0, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x1, [sp, 8]         // ..
    ldr x2, [sp, 16]        // ..
    ldr x3, [sp, 24]        // ..
    ldr x4, [sp, 32]        // ..
    ldr x30, [sp, 40]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


texto:                              // Esta rutina dibuja el texto "OdC 2025" a partir de una posicion (x1, x2) sobre el color de fondo x0
    
    sub sp, sp, 72                  // Reserva lugar en el stack
    str x30, [sp, 64]               // Guarda la direccion desde donde se llamo a la rutina
    str x11, [sp, 56]               // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x10, [sp, 48]               // ..
    str x9, [sp, 40]                // ..
    str x4, [sp, 32]                // ..
    str x3, [sp, 24]                // ..
    str x2, [sp, 16]                // ..
    str x1, [sp, 8]                 // ..
    str x0, [sp, 0]                 // ..

    mov x11, x0                     // Guarda el color de fondo del lugar donde va a estar el texto

    movz x0, 0x00, lsl 16           // Setea en x0 el color de las letras que usara como color para los rectangulos que le dara forma mas adelante
    movk x0, 0x0000, lsl 0          // ..

    mov x9, x1                      // Guarda la direccion del eje x
    mov x10, x2                     // Guarda la riceccion del eje y


    add x1, x9, 5               // Mueve el eje x 5px hacia la derecha
    add x2, x10, 5              // mueve el eje y 5px hacia abajo
    mov x3, 15                  // Setea el ancho del cuadrado que sera la base del numero
    mov x4, 30                  // Setea el alto del cuadrado que sera la base del numero
    bl cuadrado                 // Pinta la base del primer caracter

    add x1, x1, 17              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del segundo caracter

    add x1, x1, 17              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del tercer caracter

    add x1, x1, 25              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del cuarto caracter

    add x1, x1, 17              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del quinto caracter
    
    add x1, x1, 17              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del sexto caracter

    add x1, x1, 17              // Mueve el eje x hacia la derecha
    bl cuadrado                 // Pinta la base del septimo caracter

                                // Pintando sobre las bases negras con el color que sera el fondo de texto le doy forma a los caracteres

    mov x0, x11                 // Setea en x0 el color de fondo que va a usar para darle forma a los caracteres
    
    add x1, x9, 8               // Pinta un rectangulo dentro de la base que sera el centro de la O
    add x2, x10, 8              // ..
    mov x3, 9                   // ..
    mov x4, 24                  // ..
    bl cuadrado                 // ..

    add x1, x9, 22              // Pinta un rectangulo sobre la base que dara forma al palito de la d
    add x2, x10, 5              // ..
    mov x3, 12                  // ..
    mov x4, 15                  // ..
    bl cuadrado                 // ..
    
    add x1, x1, 3               // Pinta un rectangulo sobre la base que da forma a la pancita de la d
    add x2, x2, 18              // ..
    mov x3, 9                   // ..
    mov x4, 9                   // ..
    bl cuadrado                 // ..

    add x1, x9, 42              // Pinta un rectangulo sobre la base que da forma a la C
    add x2, x10, 8              // ..
    mov x3, 12                  // ..
    mov x4, 24                  // ..
    bl cuadrado                 // ..

    add x1, x9, 64              // Pinta dos rectangulos sobre la base que daran forma al primer 2
    add x2, x10, 8              // ..
    mov x3, 12                  // ..
    mov x4, 10                  // ..
    bl cuadrado                 // ..

    add x1, x1, 3               // ..
    add x2, x2, 13              // ..
    mov x3, 12                  // ..
    mov x4, 11                  // ..
    bl cuadrado                 // ..

    add x1, x9, 84              // Pinta un rectangulo dentra de la base que sera en centro del 0
    add x2, x10, 8              // ..
    mov x3, 9                   // ..
    mov x4, 24                  // ..
    bl cuadrado                 // ..

    add x1, x9, 98              // Pinta dos rectangulos sobre la base que daran forma al segundo 2
    add x2, x10, 8              // ..
    mov x3, 12                  // ..
    mov x4, 10                  // ..
    bl cuadrado                 // ..
    
    add x1, x1, 3               // ..
    add x2, x2, 13              // ..
    mov x3, 12                  // ..
    mov x4, 11                  // ..
    bl cuadrado                 // ..

    add x1, x9, 118             // Pinta dos rectangulos sobre la base que daran forma al 5
    add x2, x10, 8              // ..
    mov x3, 12                  // ..
    mov x4, 10                  // ..
    bl cuadrado                 // ..

    sub x1, x1, 3               // ..
    add x2, x2, 13              // ..
    mov x3, 12                  // ..
    mov x4, 11                  // ..
    bl cuadrado                 // ..

    ldr x0, [sp, 0]             // Recupera los valores de entrada de los registros
    ldr x1, [sp, 8]             // ..
    ldr x2, [sp, 16]            // ..
    ldr x3, [sp, 24]            // ..
    ldr x4, [sp, 32]            // ..
    ldr x9, [sp, 40]            // ..
    ldr x10, [sp, 48]           // ..
    ldr x11, [sp, 56]           // ..
    ldr x30, [sp, 64]           // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 72              // Libera el stack
    br x30                      // Salta a la direccion desde donde se llamo a la rutina

//--------------------- DIBUJOS -----------------------------------------


cartel:                         // Esta Rutina dibuja un cartel que dice "OdC 2025" de color x7
    
    sub sp, sp, 72              // Reserva lugar en el stack
    str x30, [sp, 64]           // Guarda la direccion desde donde se llamo a la rutina
    str x7, [sp, 56]            // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x6, [sp, 48]            // ..
    str x5, [sp, 40]            // ..
    str x4, [sp, 32]            // ..
    str x3, [sp, 24]            // ..
    str x2, [sp, 16]            // ..
    str x1, [sp, 8]             // ..
    str x0, [sp, 0]             // ..
    
    mov x5, x7                  // Guarda el color de entrada del cartel

    mov x0, x5                  // Setea en x0 el color del cartel para modificarlo y pintar al poste mas oscuro que la parte que tiene texto

    lsr x6, x0, 8           // Lleva el color verde a los bits menos significativos de x1
    lsr x7, x0, 16          // Lleva el color rojo a los bits menos significativos de x2

    and x0,  x0, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x0 quede el azul y el resto 0
    and x6,  x6, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x1 quede el verde y el resto 0
    and x7,  x7, 0xff       // Hace una mascara para que en los 8 bits menos significativos de x0 quede el rojo y el resto 0

    mov x1, 8               // Quiero multiplicar por 8 y dividir por 10
    mov x2, 10              // O sea multiplica por 0.8 cada color para oscurecerlo

    mul x0, x0, x1          // Multiplico por 0.8, decrementa el numero que indica el color azul (la idea es oscurecerlo)
    udiv x0, x0, x2         // ..
    mul x6, x6, x1          // Multiplico por 0.8, decrementa el numero que indica el color azul (la idea es oscurecerlo)
    udiv x6, x6, x2         // ..
    mul x7, x7, x1          // Multiplico por 0.8, decrementa el numero que indica el color rojo (la idea es oscurecerlo)
    udiv x7, x7, x2         // ..

    lsl x6, x6, 8           // Pone al color verde en los bits 15 - 8
    lsl x7, x7, 16          // Pone al color rojo en los bits 23 - 16 

    orr x0, x0, x6          // Le agrega al color azul la parte verde faltante
    orr x0, x0, x7          // Le agrega al color azul y verde la parte roja faltante (y queda compuesto un color mas oscuro que el x5 de entrada)

    mov x1, 450         // Dibuja el poste del cartel
    mov x2, 250         // ..
    mov x3, 35          // ..
    mov x4, 180         // ..
    bl cuadrado         // ..

    mov x0, x5          // Setea en x0 el color del cartel para pintar la parte que tiene texto

    mov x1, 400         // Dibuja la tabla horizontal del cartel que tendra el texto
    mov x2, 260         // ..
    mov x3, 135         // ..
    mov x4, 40          // ..
    bl cuadrado         // ..

    bl texto            // Coloca el texto en la tabla horizontal

    mov x1, 535             // Dibuja la parte inferior de la flecha o direccion
    mov x2, 280             // ..
    mov x3, 20              // ..
    bl triangulo_inf        // ..

    bl triangulo_sup        // Dibuja la parte superior de la flecha o direccion

    ldr x0, [sp, 0]         // Recupera los valores de entrada de los registros     
    ldr x1, [sp, 8]         // ..
    ldr x2, [sp, 16]        // ..
    ldr x3, [sp, 24]        // ..
    ldr x4, [sp, 32]        // ..
    ldr x5, [sp, 40]        // ..
    ldr x6, [sp, 48]        // ..
    ldr x7, [sp, 56]        // ..
    ldr x30, [sp, 64]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 72          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


nube:                       // Esta rutina dibuja una nube de color x8, a partir de la posicion (x1, x2)
    
    sub sp, sp, 64          // Reserva lugar en el stack
    str x30, [sp, 56]       // Guarda la direccion desde donde se llamo a la rutina
    str x10, [sp, 48]       // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x9, [sp, 40]        // ..
    str x4, [sp, 32]        // ..
    str x3, [sp, 24]        // ..
    str x2, [sp, 16]        // ..
    str x1, [sp, 8]         // ..
    str x0, [sp, 0]         // ..

    mov x9, x1              // Guarda en valor del eje x desde donde se pintara la nube
    mov x10, x2             // Guarda en valor del eje y desde donde se pintara la nube
    mov x0, x8              // Setea en x0 el color que utilizara para los rectangulos que dan forma a la nube

    mov x3, 100             // Pinta 3 rectangulos de color x0 a partir de la direccion (x, y) que daran forma a la nube
    mov x4, 40              // ..
    bl cuadrado             // ..

    add x1, x9, 15          // ..
    sub x2, x10, 10         // ..
    mov x3, 70              // ..
    mov x4, 55              // ..
    bl cuadrado             // ..

    add x1, x9, 35          // ..
    sub x2, x10, 15         // ..
    mov x3, 30              // ..
    mov x4, 5               // ..
    bl cuadrado             // ..

    ldr x0, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x1, [sp, 8]         // ..
    ldr x2, [sp, 16]        // ..
    ldr x3, [sp, 24]        // ..
    ldr x4, [sp, 32]        // ..
    ldr x9, [sp, 40]        // ..
    ldr x10, [sp, 48]       // ..
    ldr x30, [sp, 56]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 64          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina

nube2:                       // Esta rutina dibuja una nube de color x8, a partir de la posicion (x3, x4)
    
    sub sp, sp, 64          // Reserva lugar en el stack
    str x30, [sp, 56]       // Guarda la direccion desde donde se llamo a la rutina
    str x10, [sp, 48]       // Guarda los valores de los registros que voy a utilizar para no perder datos
    str x9, [sp, 40]        // ..
    str x4, [sp, 32]        // ..
    str x3, [sp, 24]        // ..
    str x2, [sp, 16]        // ..
    str x1, [sp, 8]         // ..
    str x0, [sp, 0]         // ..

    mov x9, x3              // Guarda en valor del eje x desde donde se pintara la nube
    mov x10, x4             // Guarda en valor del eje y desde donde se pintara la nube
    mov x0, x8              // Setea en x0 el color que utilizara para los rectangulos que dan forma a la nube

    mov x1, x9
    mov x2, x10
    mov x3, 100             // Pinta 3 rectangulos de color x0 a partir de la direccion (x, y) que daran forma a la nube
    mov x4, 40              // ..
    bl cuadrado             // ..

    add x1, x9, 15          // ..
    sub x2, x10, 10         // ..
    mov x3, 70              // ..
    mov x4, 55              // ..
    bl cuadrado             // ..

    add x1, x9, 35          // ..
    sub x2, x10, 15         // ..
    mov x3, 30              // ..
    mov x4, 5               // ..
    bl cuadrado             // ..

    ldr x0, [sp, 0]         // Recupera los valores de entrada de los registros
    ldr x1, [sp, 8]         // ..
    ldr x2, [sp, 16]        // ..
    ldr x3, [sp, 24]        // ..
    ldr x4, [sp, 32]        // ..
    ldr x9, [sp, 40]        // ..
    ldr x10, [sp, 48]       // ..
    ldr x30, [sp, 56]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 64          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina



