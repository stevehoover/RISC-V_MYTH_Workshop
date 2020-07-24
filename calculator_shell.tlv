\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/vineet/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\SV
   integer seed;
   reg [2:0] rand_op;
   reg [3:0] rand2;
   reg cnt;
   initial begin
      cnt = 0;
   end
   always@(posedge clk) begin
     cnt <= cnt + 1;
      if(!cnt) begin
        rand_op <= $random + 1'b1;
        rand2 <= $random; end         
      end

\TLV
   |cpu
      @0
         $reset = *reset;
         // YOUR CODE HERE
         // ...

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
      // Macro instantiations for calculator visualization.   
   //m4+cal_viz(@2)
\SV
   endmodule
