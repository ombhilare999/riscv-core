.global _start

_start:	
	#Immediate Instructions test
	addi	x4, x3, 0x666
        slti	x4, x3, 0x666
        sltiu	x4, x3, 0x666
        xori 	x4, x3, 0x666
        ori 	x4, x3, 0x666
        andi 	x4, x3, 0x666
        slli 	x4, x3, 6
        srli 	x4, x3, 6
        srai 	x4, x3, 6 
		
.end

