Nombre y apellido 
Integrante 1: Juan Manuel Ariazaga
Integrante 2: Nahuel Rodrigo Funes Vitorgan
Integrante 3: Augusto Ajalla
Integrante 4: Fabricio Augusto Carinelli


Descripción ejercicio 1: Una foto de un anochecer en el desierto. Funciona con las siguientes subrutinas que se encuentran en distintos archivos: Fondo (dibuja cielo y arena),
                         nube, cactus y cartel. A su vez, cada una de esas rutinas usa subrutinas mas pequeñas (cuadrado, pixel, etc) que facilitan la tarea.


Descripción ejercicio 2: Una animación de un anochecer en el desierto. Las subrutinas del ejercicio 1 se encuentran modularizadas y listas para ser llamadas luego de cada delay_loop, modificando
                          antes su color (rutina de oscurecimiento) y su posicion (en caso de la nube)


Justificación instrucciones ARMv8: ubfx: En los segmentos de codigo donde debemos editar color, esta instruccion nos permite copiar solo una parte del registro color en otro registro, de manera
                                         sencilla y practica, para poder editar esa parte del color (componende red, green o blue) y luego volver a unir todo en el registro original.
                                   udiv: para multiplicar los colores por un decimal, decidimos multiplicar y dividir por enteros. Esta intruccion que usamos para dividir no es parte de LEGv8


