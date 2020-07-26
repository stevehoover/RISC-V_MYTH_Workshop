\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/db3724fc34c36306ed45b44024aaa09b7acbea2d/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0
         $reset = *reset;
         // YOUR CODE HERE
         // ...
         


      // Use these random signals with proper widths as needed.
      //  o $rand_op --- for random $op1
      //  o $rand2   --- for random $val2

      // Macro instantiations for calculator visualization(disabled by default).
   //m4+cal_viz(@1, @3) // Args: (read(first), write(last) stage).
                        // For visualisation, write(last) stage should be at least equal to the last stage of CALC logic

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
