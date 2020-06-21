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
         
