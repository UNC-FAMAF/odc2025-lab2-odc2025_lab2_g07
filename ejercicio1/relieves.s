	
	.globl relieves

	relieves:

		//creo un stack para guardar el los registros trabajados fuera de la rutina
    	sub sp, sp, 64

    	//guardo valores con los que se trabaja fuera del proc
    	
		stur x30,[sp,56]
		stur x10,[sp,48]
		stur x9,[sp,40]
		stur x4,[sp,32]
		
		// posicion inicial de x,y, color
		stur x3,[sp,24]
		stur x2,[sp,16]
		stur x1,[sp,8]
		stur x0,[sp,0]

		//seteo variables temporales con la posicion inicial del pixel
		mov x9, x1
		mov x10,x2

		//guardo color pasado como parametro
		mov x0, x5 


		//dibujo 14 rectangulos que representan un relieve en el cactus
		mov x3,5
		mov x4,70
		bl cuadrado

		add x1,x9,10
		sub x2,x10, 10
		mov x3,20
		mov x4,5
		bl cuadrado

		add x1,x9, 30
		add x2,x10,0
		mov x3,5
		mov x4,70
		bl cuadrado

		sub x1,x9, 100
		add x2,x10,10
		mov x3,5
		mov x4,40
		bl cuadrado

		add x1,x9, 120
		add x2,x10,20
		mov x3,5
		mov x4,30
		bl cuadrado

		sub x1,x9, 70
		add x2,x10,70
		mov x3,70
		mov x4,5
		bl cuadrado

		add x1,x9, 40
		add x2,x10,70
		mov x3,60
		mov x4,5
		bl cuadrado

		sub x1,x9, 30
		add x2,x10,90
		mov x3,5
		mov x4,60
		bl cuadrado

		add x1,x9, 0
		add x2,x10,90
		mov x3,5
		mov x4,40
		bl cuadrado

		sub x1,x9, 10
		add x2,x10,110
		mov x3,5
		mov x4,30
		bl cuadrado

		sub x1,x9, 20
		add x2,x10,160
		mov x3,5
		mov x4,30
		bl cuadrado

		sub x1,x9, 40
		add x2,x10,150
		mov x3,5
		mov x4,30
		bl cuadrado

		sub x1,x9, 30
		add x2,x10,190
		mov x3,5
		mov x4,30
		bl cuadrado

		sub x1,x9, 50
		add x2,x10,180
		mov x3,5
		mov x4,30
		bl cuadrado

		//cargo los registros con los valores anteriores a entrar a la rutina

		ldr x0, [sp, 0]
    	ldr x1, [sp, 8]
    	ldr x2, [sp, 16]
    	ldr x3, [sp, 24]
    	ldr x4, [sp, 32]
    	ldr x9, [sp, 40]
    	ldr x10, [sp, 48]
    	ldr x30, [sp, 56]

    	//vuelvo el valor original del stack
    	add sp, sp, 64

    	//vuelvo a punto donde habia quedado antes de ser llamado el proc
    	br x30

