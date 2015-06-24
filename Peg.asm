			addi 	1,0,0x2 	#set register1 the value to send to fb
			addi 	2,0,-64 	# set r2 to count for the loop (i=-64)
			lui 	7,0x40 	#r7=1000000 (address of frame buffer)
			addi	6,0,2	#r6=2
			addi	5,0,0
loop:			sw 	1,7,0	# send value of r1 to fb
			sw 	6,5,0
			addi	5,5,1
			addi	1,1,0x10	# go to the next tile
			addi	2,2,0x1	# increase r2(i) by one
			beq	0,2,loop	
			lui 	1,0x0
			sw 	1,7,0  	# 0,0,0
			sw 	0,0,0
			movi	5,1
			addi	1,1,0x10
			sw 	1,7,0  	# 0,1,0
			sw 	0,5,0
			addi	1,1,0x3f	
			addi	1,1,1	
			sw 	1,7,0  	# 0,5,0
			addi 	5,5,4
			sw 	0,5,0
			addi	1,1,0x10
			sw 	1,7,0  	# 0,6,0
			addi 	5,5,1
			sw 	0,5,0
			lui 	1,0x80
			sw 	1,7,0  	# 1,0,0
			addi 	5,5,2
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 1,1,0
			addi 	5,5,1
			sw 	0,5,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 1,5,0
			addi 	5,5,4
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 1,6,0
			addi 	5,5,1
			sw 	0,5,0
			lui 	1,0x280
			sw 	1,7,0  	# 5,0,0
			addi 	5,5,26
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 5,1,0
			addi 	5,5,1
			sw 	0,5,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 5,5,0
			addi 	5,5,4
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 5,6,0
			addi 	5,5,1
			sw 	0,5,0
			addi 	1,1,0x20
			sw 	1,7,0  	# 6,0,0
			addi 	5,5,2
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 6,1,0
			addi 	5,5,1
			sw 	0,5,0
			addi	1,1,0x3f	
			addi	1,1,1
			sw 	1,7,0  	# 6,5,0
			addi 	5,5,4
			sw 	0,5,0
			addi 	1,1,0x10
			sw 	1,7,0  	# 6,6,0
			addi 	5,5,1
			sw 	0,5,0
			addi 	1,1,0x20
			sw 	1,7,0  	#7,0,0
			addi 	5,5,2
			sw 	0,5,0
			addi 	2,0,-7
line:			addi	1,1,0x10
			sw 	1,7,0  	#7,1-7,0
			addi 	5,5,1
			sw 	0,5,0
			addi 	2,2,1
			beq 	0,2,line
			lui 	4,0x80
			lui	1,0x40
			addi 	1,1,0x30
			sw 	1,7,0  	#0,7,0
			movi	5,7
			sw 	0,5,0
			addi 	2,0,-7
column:			add	1,1,4
			sw 	1,7,0  	#1-7,7,0
			addi 	5,5,8
			sw 	0,5,0
			addi 	2,2,1
			beq 	0,2,column
			lui   	1,0x180
			addi	1,1,0x34
			sw 	1,7,0  	#3,3,1
			movi	3,4
			movi 	5,27
			sw 	3,5,0
			sw	5,7,20 #cursor in the center
			sw	0,7,21 #select in 0,0
			
			movi r3, 96		#set IntEn = 1 and WintEn = 1 which means Software Interrupts are enabled
			sw r3, r7, 1	#send it to IntController
			
			
			# loupa ateleiwti
			addi 	3,0,3
infinite:	beq       0,3,infinite
			
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
			
			########################################
			########### Interrupt Handler ###########
			########################################
			
			lui r7, 0x40		#set r7 to 64 (DataMem Offset)
			sw r1, r7, 3		#store normal flow registers to DataMem at 64(r7) + offset (3)
			sw r2, r7, 4
			sw r3, r7, 5
			sw r4, r7, 6
			sw r5, r7, 7
			sw r6, r7, 8
			sw r7, r7, 9
			
<<<<<<< HEAD
			lw r1, r7,1			#load intVector to r1
			
			addi r2, r0, 1		#set r2 mask for up "00...01"
			nand r2, r1, r2
			nand r2, r2, r2		#if r2 is not 0 then up is pressed
			
			beq r0, r2, gotoup	#if r3 not 0 gotoup where uphandler address is set to r3 for jalr to goto uphandler
			movi r3, uphop
			jalr r0, r3			#if r2 is 0 avoid goto uphandler
gotoup:		movi r3, uphandler
			jalr r0, r3			#current pc is not stored(r0) and goto uphandler
			
uphop:		addi r2, r0, 2		#set r2 mask for down "00...10"
			nand r2, r1, r2
			nand r2, r2, r2	
			beq r0, r2, gotodown	#As Above
			movi r3, downhop
			jalr r0, r3			
gotodown:	movi r3, downhandler
			jalr r0, r3		
			
downhop:	addi r2, r0, 4		#set r2 mask for lft "00...100"
			nand r2, r1, r2
			nand r2, r2, r2	
			
			beq r0, r2, gotolft
			movi r3, lfthop
			jalr r0, r3
gotolft:	movi r3, lfthandler
			jalr r0, r3
			
lfthop:		addi r2, r0, 8		#set r2 mask for rght "00...1000"
			nand r2, r1, r2
			nand r2, r2, r2	
			
			beq r0, r2, gotorght
			movi r3, rghthop
			jalr r0, r3
gotorght:	movi r3, rghthandler
			jalr r0, r3
			
rghthop:	addi r2, r0, 16		#set r2 mask for slct "00...10000"
			nand r2, r1, r2
			nand r2, r2, r2	
			
			beq r0, r2, gotoslct
			movi r3, slcthop
			jalr r0, r3
gotoslct:	movi r3, slcthandler
			jalr r0, r3
			
slcthop:	movi r3 , intend	#if reach this point no interrupt is handled so goto in ending
			jalr r0, r3
			
uphandler:	lw 		r1, r7, 20		#Get cursor address
			addi	r3, r1, -8		#Get address above cursor !!caution Add mask after substruction
#			addi	r4, r0, 63		#Set mask for new address "00...0111111" (keep last 6bits)
#			nand	r3, r3, r4
#			nand	r3, r3, r3
			
			lw		r2, r1, 0		#Get value(tile) of cursor
			addi	r2, r2, -3		#uncursor it
			add 	r1, r1, r1
			add 	r1, r1, r1
			add 	r1, r1, r1
			add 	r1, r1, r1		#r1(cursor address) << 4
			add		r2, r1, r2
			sw		r2, r7, 0  		#Update cursors tile
			
			lw		r2, r3, 0		#Get value of new cursor
			addi	r2, r2, 3		#cursor the value
			add 	r3, r3, r3
			add 	r3, r3, r3
			add 	r3, r3, r3
			add 	r3, r3, r3		# r3 << 4
			add		r2, r3, r2
			sw		r2, r7, 0  		#sent tofb cursored icon
			
			movi r3, 97  		#Enable SWint and rst upflag
			sw r3, r7, 1
			
			movi r3, intend
			jalr r0, r3			#jumps to intend

downhandler: nop

lfthandler:	nop

rghthandler: nop

slcthandler: nop

intend:		lui r7, 0x40		#set r7 to 64 (DataMem Offset) # closing interrupt Handler
			lw r1, r7, 3		#load normal flow registers to DataMem at 64(r7) + offset (3)
			lw r2, r7, 4
			lw r3, r7, 5
			lw r4, r7, 6
			lw r5, r7, 7
			lw r6, r7, 8
			
			lw r7, r7, 2		#load hook address of normal flow at r7
			jalr r0, r7			#Wheeee back to the normal flow
			

=======
			# loupa ateleiwti
			addi 	3,0,3
infinite:			beq       0,3,infinite

			#uphandler
uphandler:		lw 	1,7,20	#cursor address
			addi	3,1,-8	#upped cursor address
			lw	2,1,0	#value now
			addi	2,2,-3
			add 	1,1,1
			add 	1,1,1
			add 	1,1,1
			add 	1,1,1
			add	2,1,2
			sw	2,7,0  	#sent tofb uncursored icon
			lw	2,3,0	#value upped cursor
			addi	2,2,3
			add 	3,3,3
			add 	3,3,3
			add 	3,3,3
			add 	3,3,3
			add	2,3,2
			sw	2,7,0  	#sent tofb cursored icon
>>>>>>> origin/assembly
			