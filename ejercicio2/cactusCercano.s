
	.globl cactus1
	

	cactus1:

		sub sp, sp, 64
		stur x30,[sp,56]
		stur x10,[sp,48]
		stur x9,[sp,40]
		stur x4,[sp,32]
		
		
		stur x3,[sp,24]
		stur x2,[sp,16]
		stur x1,[sp,8]
		stur x0,[sp,0]

		mov x9, x1
		mov x10,x2
		mov x0, x5 //x5 contiene el color param

		//primer cuadrado

		mov x3,40
		mov x4,20
		bl cuadrado

		//Segundo cuadrado

		add x1, x9, 10
    		sub x2, x10, 10
    		mov x3, 20
    		mov x4, 10
    		bl cuadrado

    	 	//tercer cuadro

    		sub x1, x9, 110
    		add x2,x10, 30
    		mov x3, 20
    		mov x4, 10
    		bl cuadrado 

    		//cuarto

    		sub x1, x9, 120
    		add x2,x10, 40
    		mov x3, 40
    		mov x4, 40
    		bl cuadrado

    		//quinto 

    		sub x1,x9,80
    		add x2, x10,50
    		mov x3, 10
    		mov x4, 10
    		bl cuadrado

    		// sexto
    		sub x1,x9,80
    		add x2, x10,60
    		mov x3, 20
    		mov x4, 20
    		bl cuadrado

    		//septimo
    		sub x1,x9,60
    		add x2,x10,70
    		mov x3, 20
    		mov x4,10
    		bl cuadrado

    		//octavo
    	sub x1,x9, 30
    	add x2,x10, 70
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	//noveno
    	sub x1, x9, 20
    	add x2,x10, 50
    	mov x3, 10
    	mov x4, 30
    	bl cuadrado

    	//decimo
    	sub x1,x9, 10
    	add x2,x10, 20
    	mov x3, 60
    	mov x4, 60
    	bl cuadrado

    	// undecimo

    	add x1,x9, 50
    	add x2, x10, 60
    	mov x3, 10
    	mov x4, 20
    	bl cuadrado

    	//decimo segundo

    	add x1,x9, 60
    	add x2,x10, 70
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	//decimo tercero

    	add x1,x9,90
    	add x2,x10,70
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	//decimo cuarto

    	add x1,x9, 120 
    	add x2,x10, 40
    	mov x3, 20
    	mov x4, 10
    	bl cuadrado

    	//decimo quinto

    	add x1,x9, 110 
    	add x2,x10,50
    	mov x3, 30
    	mov x4, 10
    	bl cuadrado

    	//decimo sexto

    	add x1,x9, 100
    	add x2,x10, 60
    	mov x3, 40
    	mov x4, 30
    	bl cuadrado

    	//decimo septimo

    	sub x1,x9, 110
    	add x2,x10, 80
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	//decimo octavo
    	sub x1,x9, 100
    	add x2,x10, 80
    	mov x3, 20
    	mov x4, 20
    	bl cuadrado

    	//decimo noveno

    	sub x1,x9, 90
    	add x2, x10, 100
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	// vigesimo

    	sub x1,x9, 80
    	add x2,x10, 80
    	mov x3, 180
    	mov x4, 40
    	bl cuadrado

    	// vigesimo primero
    	add x1, x9, 100
    	add x2,x10, 90
    	mov x3, 20
    	mov x4, 20
    	bl cuadrado

    	//vigesimo segundo

    	add x1,x9, 120
    	add x2,x10, 90
    	mov x3,10
    	mov x4, 10
    	bl cuadrado

    	//vigesimo tercero

    	sub x1,x9, 60
    	add x2, x10, 120
    	mov x3, 20
    	mov x4, 10
    	bl cuadrado

    	//vigesimo cuarto

    	sub x1, x9, 50
    	add x2,x10, 130
    	mov x3,10
    	mov x4, 10
    	bl cuadrado

    	//vigesimo quinto

    	sub x1,x9, 40
    	add x2, x10, 120
    	mov x3, 60
    	mov x4, 40
    	bl cuadrado

    	//vigesimo sexto

    	add x1,x9, 20
    	add x2,x10, 120
    	mov x3,20
    	mov x4, 20
    	bl cuadrado

    	// vigesimo septimo

    	add x1,x9, 20
    	add x2,x10, 140
    	mov x3, 10
    	mov x4, 10
    	bl cuadrado

    	//vigesimo octavo

    	add x1,x9,40
    	add x2,x10,120
    	mov x3, 40
    	mov x4, 10
    	bl cuadrado

    	//vigesimo noveno

    	sub x1,x9,50
    	add x2,x10, 160
    	mov x3, 60
    	mov x4, 30
    	bl cuadrado

    	//trigesimo
    	sub x1,x9, 60
    	add x2,x10, 190
    	mov x3, 60
    	mov x4, 40
    	bl cuadrado

    	//trigesimo primero

    	sub x1,x9, 70
    	add x2, x10,230
    	mov x3, 60
    	mov x4, 10
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




    									


