	
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

	
		mov x7,x1
		mov x8, x2
	
	// color cactus #146f15
		mov x1, 210
		mov x2, 230
		movz x5, 0x14, lsl 16
		movk x5, 0x6f15, lsl 00
		bl cactus1


	// color espinas #000

		add x1, x7,0
		add x2, x8,0
		mov x5,xzr
		movz x5, 0x0, lsl 16
		movk x5, 0x0, lsl 00
		bl espinas


	// color relieves #163d13
		add x1, x7,0
		add x2, x8,20		
		mov x5,xzr
		movz x5, 0x16, lsl 16
		movk x5, 0x3d13, lsl 00
		bl relieves

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

