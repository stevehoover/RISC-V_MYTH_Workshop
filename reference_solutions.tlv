\m4_TLV_version 1d: tl-x.org
\SV

   // ==========================================
   // For use in Makerchip for the MYTH Workshop
   // Provides reference solutions
   // without visibility to source code.
   // ==========================================
   
   // ----------------------------------
   // Instructions:
   //    - When stuck on a particular lab, provide the slide number of the lab as the
   //      parameter to the m4+solutions macro instantiation below, and compile/simulate.
   //    - A reference solution will build, but the source code will not be
   //      visible.
   //    - You may use waveforms, diagrams, and visualization to understand the proper circuit, but you
   //      will have to come up with the code. Logic expression syntax can be found by hovering over the
   //      signal assignment in the diagram.
   //    - Also reference https://github.com/stevehoover/RISC-V_MYTH_Workshop/blob/master/README.md
   //      for updated information during the workshop as well as live support links.
   // ----------------------------------

   // Default Makerchip TL-Verilog Code Template
   m4_include_makerchip_hidden(['myth_workshop_solutions.private.tlv'])

   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   m4+solution(100)
   m4+cpu_viz(@4)
\SV
   endmodule
