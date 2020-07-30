\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/52a6b52c5961e511615dc7bc9835cb30ffaf35ea/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0
         $reset = *reset;
         
         
         // YOUR CODE HERE
         // ...
         

   // Macro instantiations for calculator visualization.
   // Uncomment to enable visualisation, and also,
   // NOTE: If visualization is enabled, $op must be defined to the proper width using the expression below.
   //       (Any signals other than $rand1, $rand2 that are not explicitly assigned will result in strange errors.)
   |calc
      @0
         //m4_rand($op, 1, 0)  // or 2, 0 for [2:0]
   //m4+cal_viz(@3) // Arg: Pipeline stage represented by viz.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
