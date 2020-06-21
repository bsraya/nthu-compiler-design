      .text
      .file "(null)"
   #  codegen
      .globl main                    # -- Begin function codegen
      .p2align 2 
      .type codegen,@function 
   #    
codegen:
        addi sp,sp,-48 
        sd   ra,40(sp) 
        sd   fp,32(sp) 
        addi fp,sp,48 
         
	// BEGIN PROLOGUE
	sw s0, -4(sp) // save frame pointer
	addi sp, sp, -4
	addi s0, sp, 0 // set new frame
	sw sp, -4(s0)
	sw s1, -8(s0)
	sw s2, -12(s0)
	sw s3, -16(s0)
	sw s4, -20(s0)
	sw s5, -24(s0)
	sw s6, -28(s0)
	sw s7, -32(s0)
	sw s8, -36(s0)
	sw s9, -40(s0)
	sw s10, -44(s0)
	sw s11, -48(s0)
	addi sp, s0, -48 // update stack pointer 
	// END PROLOGUE
        li t0,   1
        addi sp, sp, -4
        sw t0, 0(sp)
        li t0,   2
        addi sp, sp, -4
        sw t0, 0(sp)
        li t0,   1
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        mul  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        add  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        lui     t0,%hi(a)
        lw     t1, %lo(a)(t0)
        addi sp, sp, -4
        sw t1, 0(sp)
        li t0,   3
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        add  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        li t0,   2
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        div  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        jal ra, digitalWrite
	lw ra, 0(sp)
        addi sp, sp, 4
   
        lw  t0, -20(fp) 
        addi sp, sp, -4
        sw t0, 0(sp)
        li t0,   1000
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        mul  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        jal ra, delay
	lw ra, 0(sp)
        addi sp, sp, 4
   
        jal ra, digitalWrite
	lw ra, 0(sp)
        addi sp, sp, 4
   
        lw  t0, -24(fp) 
        addi sp, sp, -4
        sw t0, 0(sp)
        li t0,   1000
        addi sp, sp, -4
        sw t0, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 4
        lw t1, 0(sp)
        addi sp, sp, 4
        mul  t0, t0, t1
        addi sp, sp, -4
        sw t0, 0(sp)
        jal ra, delay
	lw ra, 0(sp)
        addi sp, sp, 4
   
   #    
        ld ra,40(sp) # old ra
        ld fp,32(sp) # old fp
        addi sp,sp,48# pop activiation record
        ret
.Lfunc_codegen_end0:
        .size      codegen, .Lfunc_codegen_end0-codegen 
       
	// BEGIN PROLOGUE
	// restore callee-saved registers
	// s0 at this point should be the same in prologue
	lw s11, -48(s0)
	lw s10, -44(s0)
	lw s9, -40(s0)
	lw s8, -36(s0)
	lw s7, -32(s0)
	lw s6, -28(s0)
	lw s5, -24(s0)
	lw s4, -20(s0)
	lw s3, -16(s0)
	lw s2, -12(s0)
	lw s1, -8(s0)
	lw sp, -4(s0)
	addi sp, sp, 4 
 	lw s0, -4(sp)
	// END PROLOGUE
	
	jalr zero, 0(ra) // return 
        .ident "NTHU Compiler Class Code Generator for RISC-V"
        .section "note.stack","",@progbits
