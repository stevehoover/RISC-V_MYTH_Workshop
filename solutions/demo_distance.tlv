\m4_TLV_version 1d: tl-x.org
\SV
   `include "sqrt32.v";
   m4_makerchip_module
\TLV
   |calc
      @1
         $aa_sq[7:0] = $aa[3:0] * $aa;
         $bb_sq[7:0] = $bb[3:0] * $bb;
      @2
         $cc_sq[8:0] = $aa_sq + $bb_sq;
      @3
         $cc[4:0] = sqrt($cc_sq);
         
         
!  *passed = *cyc_cnt > 16'd30;

\SV
   endmodule

