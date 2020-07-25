\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/vineet/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |cpu
      @0
         $reset = *reset;
         // YOUR CODE HERE
         // ...
         
         
      // Macro instantiations for calculator visualization(disabled by default).
      //First Argument is the initial stage (where we assign the input operands) 
      //Second Argument is the last stage (where we assign the output results)
   //m4+cal_viz(@1, @2)
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
