\m4_TLV_version 1d: tl-x.org
\SV
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/warp-v_includes/3cd6ba9eb71dc7c302b508a892584cab4001d2e2/risc-v_defs.tlv'])
m4+definitions(['
   m4_define(['m4_no_op5_localparams'], 1)
   m4_define(['m4_no_opcode_localparams'], 1)
   m4_define_vector(['M4_WORD'], 32)
   m4_define(['M4_EXT_I'], 1)

   m4_define(['M4_NUM_INSTRS'], 0)
   
   m4_echo(m4tlv_riscv_gen__body())
'])
\TLV myth_shell()
   \SV_plus
      // The program in an instruction memory.
      logic [M4_INSTR_RANGE] instrs [0:M4_NUM_INSTRS-1];
      logic [40*8-1:0] instr_strs [0:M4_NUM_INSTRS];
      
      assign instrs = '{
         m4_instr0['']m4_forloop(['m4_instr_ind'], 1, M4_NUM_INSTRS, [', m4_echo(['m4_instr']m4_instr_ind)'])
      };
      
      // String representations of the instructions for debug.
      assign instr_strs = '{m4_asm_mem_expr "END                                     "};
