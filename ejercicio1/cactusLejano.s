	
	.globl cactus2

	cactus2:

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
		mov x0, x5

		mov x3,60
		mov x4,20
		bl cuadrado

		sub x1, x9, 10
    	add x2, x10, 20
    	mov x3, 20
    	mov x4, 20
    	bl cuadrado

    	add x1, x9, 20
    	add x2,x10, 20
    	mov x3, 20
    	mov x4, 40
    	bl cuadrado 

    	add x1, x9, 50
    	sub x2,x10, 20
    	mov x3, 20
    	mov x4, 20
    	bl cuadrado

    	sub x1, x9, 30
    	add x2,x10, 10
    	mov x3, 20
    	mov x4, 20
    	bl cuadrado
    	sub x1, x9, 10
    	add x2,x10, 15
    	mov x3, 5
    	mov x4, 5
    	bl cuadrado
    	sub x1, x9, 20
    	add x2,x10, 30
    	mov x3, 10
    	mov x4, 5
    	bl cuadrado
    	add x1, x9, 10
    	add x2,x10, 20
    	mov x3, 5
    	mov x4, 10
    	bl cuadrado
    	add x1, x9, 15
    	add x2,x10, 20
    	mov x3, 5
    	mov x4, 5
    	bl cuadrado

    	sub x1, x9,25
    	add x2,x10,5
    	mov x3, 10
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 10
    	sub x2,x10, 5
    	mov x3, 30
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 20
    	add x2,x10, 10
    	mov x3, 10
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 40
    	add x2,x10, 20
    	mov x3, 5
    	mov x4, 10
    	bl cuadrado

    	add x1, x9, 45
    	add x2,x10, 20
    	mov x3, 5
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 60
    	add x2,x10, 0
    	mov x3, 5
    	mov x4, 10
    	bl cuadrado

    	add x1, x9, 45
    	sub x2,x10, 5
    	mov x3, 5
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 45
    	add x2,x10, 20
    	mov x3, 5
    	mov x4, 5
    	bl cuadrado

    	add x1, x9, 40
    	sub x2,x10, 30
    	mov x3, 20
    	mov x4, 10
    	bl cuadrado

    	add x1, x9, 60
    	sub x2,x10, 25
    	mov x3, 5
    	mov x4, 5
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

