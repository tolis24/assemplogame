	addi 1,0,1 		#reg1=1
	lui  2,0x0
	sw   2,0,0x0 	#x=0 y=0 V=0
	addi 2,0,0x10
	sw   2,0,0x0	#x=0 y=1
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=3
	lui  2,0x40
	sw   2,0,0x0	#x=0 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=5
	addi 2,2,0x10	
	sw   2,0,0x0	#x=0 y=6
	addi 2,2,0x10
	sw   2,0,0x0	#x=0 y=7
	lui  2,0x100
	sw   2,0,0x0	#x=1 y=0 V=0
	addi 2,2,0x10	
	sw   2,0,0x0	#x=1 y=1
	addi 2,2,0x10
	sw   2,0,0x0	#x=1 y=2
	addi 2,2,0x12
	sw   2,0,0x0	#x=1 y=3 V=2
	addi 2,2,0x10	
	sw   2,0,0x0	#x=1 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=1 y=5
	addi 2,2,0xe
	sw   2,0,0x0	#x=1 y=6 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=1 y=7
	lui  2,0x200
	sw   2,0,0x0	#x=2 y=0 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=2 y=1
	addi 2,2,0x10
	sw   2,0,0x0	#x=2 y=2
	addi 2,2,0x12
	sw   2,0,0x0	#x=2 y=3 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=2 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=2 y=5
	addi 2,2,0xe
	sw   2,0,0x0	#x=2 y=6 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=2 y=7
	lui  2,0x300
	sw   2,0,0x0	#x=3 y=0 V=0
	addi 2,2,0x12
	sw   2,0,0x0	#x=3 y=1 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=3
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=5
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=6
	addi 2,2,0x10
	sw   2,0,0x0	#x=3 y=7
	lui  2,0x400
	sw   2,0,0x0	#x=4 y=0 V =0
	addi 2,2,0x12
	sw   2,0,0x0	#x=4 y=1 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=4 y=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=4 y=3
	addi 2,2,0xf
	sw   2,0,0x0	#x=4 y=4 V=1
	addi 2,2,0x11
	sw   2,0,0x0	#x=4 y=5 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=4 y=6
	addi 2,2,0x10
	sw   2,0,0x0	#x=4 y=7
	lui  2,0x500
	sw   2,0,0x0	#x=5 y=0 V= 0
	addi 2,2,0x12
	sw   2,0,0x0	#x=5 y=1 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=3
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=5
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=6
	addi 2,2,0x10
	sw   2,0,0x0	#x=5 y=7
	lui  2,0x600
	sw   2,0,0x0	#x=6 y=0 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=6 y=1 
	addi 2,2,0x10
	sw   2,0,0x0	#x=6 y=2
	addi 2,2,0x12
	sw   2,0,0x0	#x=6 y=3 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=6 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=6 y=5
	addi 2,2,0xe
	sw   2,0,0x0	#x=6 y=6 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=6 y=7
	lui  2,0x700
	sw   2,0,0x0	#x=7 y=0 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=7 y=1
	addi 2,2,0x10
	sw   2,0,0x0	#x=7 y=2
	addi 2,2,0x12
	sw   2,0,0x0	#x=7 y=3 V=2
	addi 2,2,0x10
	sw   2,0,0x0	#x=7 y=4
	addi 2,2,0x10
	sw   2,0,0x0	#x=7 y=5
	addi 2,2,0xe
	sw   2,0,0x0	#x=7 y=6 V=0
	addi 2,2,0x10
	sw   2,0,0x0	#x=7 y=7
	
	addi 1,0,1
	addi 2,0,1
loop: addi 1,1,1
	sw 1,0,0
	beq 2,0,loop
	
	
	