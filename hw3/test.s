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
         
        lw  t0, -24(fp) 
        addi sp, sp, -4
        sw t0, 0(sp)
   #    
        ld ra,40(sp) # old ra
        ld fp,32(sp) # old fp
        addi sp,sp,48# pop activiation record
        ret
.Lfunc_codegen_end0:
        .size      codegen, .Lfunc_codegen_end0-codegen 
       
 
        .ident "NTHU Compiler Class Code Generator for RISC-V"
        .section "note.stack","",@progbits
