	#Initializing  the game
	addi 1,0,1 	#reg1=1
	lui  2,0x0
	sw   2,0,0x0 	#x=0 y=0
	addi 2,0,0x10
	sw   2,0,0x0	#x=0 y=1
	addi 2,0,0x20
	sw   2,0,0x0	#x=0 y=2
	addi 2,0,0x30
	sw   2,0,0x0	#x=0 y=3
	lui  2,0x1
	sw   2,0,0x0	#x=0 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=5
	addi 2,2,0x10	
	sw   2,0,0x0	#x=0 y=6
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=7
	lui  2,0,0x4
	