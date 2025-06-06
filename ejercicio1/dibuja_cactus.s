	
	.globl dibuja_cactus

	dibuja_cactus:
		
		sub sp, sp, 48

    	//guardo valores con los que se trabaja fuera del proc
		stur x30,[sp,40]
		stur x8,[sp,32]
		stur x7,[sp,24]
		stur x5,[sp,16]
		stur x2,[sp,8]
		stur x1,[sp,0]

	
		mov x7,210
		mov x8, 230
	
	// color cactus #146f15
		mov x1, x7
		mov x2, x8
		mov x5, x10
		bl cactus1


	// color relieves #163d13
		add x1, x7,0
		add x2, x8,20		
		mov x5,xzr
		mov x5,x11
		bl relieves

		// color espinas #000

		add x1, x7,0
		add x2, x8,0
		mov x5,xzr
		mov x5, x12
		bl espinas

		ldr x1, [sp, 0]
    	ldr x2, [sp, 8]
    	ldr x5, [sp, 16]
    	ldr x7, [sp, 24]
    	ldr x8, [sp, 32]
    	ldr x30, [sp, 40]

    	//vuelvo el valor original del stack
    	add sp, sp, 48

    	//vuelvo a punto donde habia quedado antes de ser llamado el proc
    	br x30

