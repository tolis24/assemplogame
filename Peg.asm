			addi 	1,0,0x2 	#set register1 the value to send to fb
			addi 	2,0,-64 	# set r2 to count for the loop (i=-64)
			lui 	7,0x40 	#r7=1000000 (address of frame buffer)
			addi	6,0,2	#r6=2
loop:			sw 	1,7,0	# send value of r1 to fb
			sw 	6,1,0
			addi	1,1,0x10	# go to the next tile
			addi	2,2,0x1	# increase r2(i) by one
			beq	0,2,loop	
			lui 	1,0x0
			sw 	1,7,0  	# 0,0,0
			sw 	0,1,0
			addi	1,1,0x10
			sw 	1,7,0  	# 0,1,0
			sw 	0,1,0
			addi	1,1,0x3f	
			addi	1,1,1	
			sw 	1,7,0  	# 0,5,0
			sw 	0,1,0
			addi	1,1,0x10
			sw 	1,7,0  	# 0,6,0
			sw 	0,1,0
			lui 	1,0x80
			sw 	1,7,0  	# 1,0,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 1,1,0
			sw 	0,1,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 1,5,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 1,6,0
			sw 	0,1,0
			lui 	1,0x280
			sw 	1,7,0  	# 5,0,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 5,1,0
			sw 	0,1,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 5,5,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 5,6,0
			sw 	0,1,0
			addi 	1,1,0x20
			sw 	1,7,0  	# 6,0,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 6,1,0
			sw 	0,1,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 6,5,0
			sw 	0,1,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 6,6,0
			sw 	0,1,0
			addi 	1,1,0x20
			sw 	1,7,0  	#7,0,0
			sw 	0,1,0
			addi 	2,0,-7
line:			addi	1,1,0x10
			sw 	1,7,0  	#7,1-7,0
			sw 	0,1,0
			addi 	2,2,1
			beq 	0,2,line
			lui 	4,0x80
			lui	1,0x40
			addi 	1,1,0x30
			sw 	1,7,0  	#0,7,0
			sw 	0,1,0
			addi 	2,0,-7
column:			add	1,1,4
			sw 	1,7,0  	#1-7,7,0
			sw 	0,1,0
			addi 	2,2,1
			beq 	0,2,column
			lui   	1,0x180
			addi	1,1,0x31
			sw 	1,7,0  	#3,3,1
			movi	3,0x1
			sw 	3,1,0
			
			
			
			
			
			
			
			# loupa ateleiwti
			addi 	3,0,3
infinite:			beq       0,3,infinite