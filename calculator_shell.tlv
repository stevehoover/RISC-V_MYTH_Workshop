\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/vineet/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0
         $reset = *reset;
         
         // YOUR CODE HERE
         // ...
         


      // Note: Because of the magic we are using for visualisation, if visualisation is enabled below,
      //       you'll get strange error messages for any unassigned signals (which you might be using for random inputs).
      //       You can, however, safely use these specific random signals as described in the videos:
      //  o $rand1[3:0]
      //  o $rand2[3:0]
      //  o $rand_op[1:0] or $rand_op[2:0]

   // Macro instantiations for calculator visualization.
   // Uncomment to enable visualisation.
   //m4+cal_viz(@3) // Arg: Pipeline stage represented by viz.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
