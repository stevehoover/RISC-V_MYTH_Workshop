\m5_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   |comp
      @1
         $err1 = $bad_input || $illegal_op;
      @3
         $err2 = $err1 || $over_flow;
      @6
         $err3 = $err2 || $div_by_zero;
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
