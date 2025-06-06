.globl estrellas

estrellas:              // Esta rutina dibuja unas estrellas en el cielo a partir del color x9

    sub sp, sp, 48          // Reserva lugar en el stack
    stur x30, [sp, 40]       // Guarda la direccion desde donde se llamo a la rutina
    stur x4, [sp, 32]        // Guarda los valores de los registros que voy a utilizar para no perder datos
    stur x3, [sp, 24]        // ..
    stur x2, [sp, 16]        // ..
    stur x1, [sp, 8]         // ..
    stur x0, [sp, 0]         // ..

    mov x0, x9              // Setea el color en x0 para modificarlo
    
    mov x1, 0               // Pone al indicador del eje x en 0
    mov x2, 0               // Pone al indicador del eje y en 0
    mov x3, 2               // Setea el ancho para cuadrados y filas en 2px
    mov x4, 2               // Setea el alto para cuadrados en 2px

                            // Esta parte dibuja muchos cuadrados de 2px y color x0 en una zona de 640px x 270px para simular las estrellas
yloop_in00:                 
    cmp x2, 270             // Si todavia no termino de pintar la columna continua
    b.ge yloop_out00        // Si ya pinto todas las columnas termina
    mov x1, 0               // Reicia el indicador de eje x volviendo a pintar desde el borde de la pantalla
xloop_in00:                 
    cmp x1, 640             // Si todavia no termino de pintar la fila continua
    b.ge xloop_out00        // Si ya pinto toda la fila pasa a otra
    bl cuadrado             // Pinta un cuadrado en la posicion (x1, x2) actual
    add x1, x1, 60          // Pasa a pintar otra columna dejando espacio de por medio
    b xloop_in00            // Sigue pintando la fila
xloop_out00:
    add x2, x2, 60          // Pasa a pintar otra fila dejando espacio de por medio
    b yloop_in00            // Sigue pintando la columna
yloop_out00:

                            // Esta parte hace lo mismo que la enterior solo que con otro equiespaciado
    mov x1, 30
    mov x2, 30

yloop_in01:
    cmp x2, 270             // Si todavia no termino de pintar la columna continua
    b.ge yloop_out01        // Si ya pinto todas las columnas termina
    mov x1, 30              // Reicia el indicador de eje x volviendo a pintar desde 6px a la derecha del borde de la pantalla
xloop_in01:
    cmp x1, 640             // Si todavia no termino de pintar la fila continua 
    b.ge xloop_out01        // Si ya pinto toda la fila pasa a otra
    bl cuadrado             // Pinta un cuadrado en la posicion (x1, x2) actual
    add x1, x1, 60          // Pasa a pintar otra columna dejando espacio de por medio
    b xloop_in01            // Sigue pintando la fila
xloop_out01:
    add x2, x2, 60          // Pasa a pintar otra fila dejando espacio de por medio
    b yloop_in01            // Sigue pintando la columna
yloop_out01:


    ldur x0, [sp, 0]         // Recupera los valores de entrada de los registros
    ldur x1, [sp, 8]         // ..
    ldur x2, [sp, 16]        // ..
    ldur x3, [sp, 24]        // ..
    ldur x4, [sp, 32]        // ..
    ldur x30, [sp, 40]       // Recupera la direccion desde donde se llamo a la rutina
    add sp, sp, 48          // Libera el stack
    br x30                  // Salta a la direccion desde donde se llamo a la rutina


