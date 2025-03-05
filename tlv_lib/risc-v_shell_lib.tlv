\m5_TLV_version 1d: tl-x.org
\m5
   use(m5-1.0)
   
   define_vector(WORD, 32)
   var(NUM_INSTRS, 0)
\SV
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/warp-v_includes/450357b4993fa480e7fca57dc346e39cba21b6bc/risc-v_defs.tlv'])


// Instruction memory in |cpu at the given stage.
\TLV imem(@_stage)
   // Instruction Memory containing program defined by m4_asm(...) instantiations.
   @_stage
      \SV_plus
         // The program in an instruction memory.
         logic [31:0] instrs [0:m5_NUM_INSTRS-1];
         m5_repeat(m5_NUM_INSTRS, ['assign instrs[m5_LoopCnt] = m5_eval(m5_eval(m5_get(['instr']m5_LoopCnt))); '])
      /m5_IMEM_HIER
         $instr[31:0] = *instrs\[#imem\];
      ?$imem_rd_en
         $imem_rd_data[31:0] = /imem[$imem_rd_addr]$instr;


// A 2-rd 1-wr register file in |cpu that reads and writes in the given stages. If read/write stages are equal, the read values reflect previous writes.
// Reads earlier than writes will require bypass.
\TLV rf(@_rd, @_wr)
   // Reg File
   @_wr
      /xreg[31:0]
         $wr = |cpu$rf_wr_en && (|cpu$rf_wr_index != 5'b0) && (|cpu$rf_wr_index == #xreg);
         $value[31:0] = |cpu$reset ?   #xreg           :
                        $wr        ?   |cpu$rf_wr_data :
                                       $RETAIN;
   @_rd
      ?$rf_rd_en1
         $rf_rd_data1[31:0] = /xreg[$rf_rd_index1]>>m4_stage_eval(@_wr - @_rd + 1)$value;
      ?$rf_rd_en2
         $rf_rd_data2[31:0] = /xreg[$rf_rd_index2]>>m4_stage_eval(@_wr - @_rd + 1)$value;
      `BOGUS_USE($rf_rd_data1 $rf_rd_data2) 


// A data memory in |cpu at the given stage. Reads and writes in the same stage, where reads are of the data written by the previous transaction.
\TLV dmem(@_stage)
   // Data Memory
   @_stage
      /dmem[15:0]
         $wr = |cpu$dmem_wr_en && (|cpu$dmem_addr == #dmem);
         $value[31:0] = |cpu$reset ?   #dmem :
                        $wr        ?   |cpu$dmem_wr_data :
                                       $RETAIN;
                                  
      ?$dmem_rd_en
         $dmem_rd_data[31:0] = /dmem[$dmem_addr]>>1$value;
      `BOGUS_USE($dmem_rd_data)

\TLV myth_fpga(@_stage)
   @_stage

\TLV cpu_viz(@_stage)
   m4_ifelse_block(M4_MAKERCHIP, 1,['
   m4_ifelse_block(m4_sp_graph_dangerous, 1, [''], ['
   |cpu
      // for pulling default viz signals into CPU
      // and then back into viz
      @0
         $ANY = /top|cpuviz/defaults<>0$ANY;
         `BOGUS_USE($dummy)
         /xreg[31:0]
            $ANY = /top|cpuviz/defaults/xreg<>0$ANY;
         /dmem[15:0]
            $ANY = /top|cpuviz/defaults/dmem<>0$ANY;
   // String representations of the instructions for debug.
   \SV_plus
      logic [40*8-1:0] instr_strs [0:m5_NUM_INSTRS];
      // String representations of the instructions for debug.
      m5_repeat(m5_NUM_INSTRS, ['assign instr_strs[m5_LoopCnt] = "m5_eval(['m5_get(['instr_str']m5_LoopCnt)'])"; '])
      assign instr_strs[m5_NUM_INSTRS] = "END                                     ";
   |cpuviz
      @1
         /imem[m5_calc(m5_NUM_INSTRS-1):0]  // TODO: Cleanly report non-integer ranges.
            $instr[31:0] = /top|cpu/imem<>0$instr;
            $instr_str[40*8-1:0] = *instr_strs[imem];
            \viz_js
               box: {width: 500, height: 18, strokeWidth: 0},
               onTraceData() {
                  let instr_str = '$instr_str'.asString() + ": " + '$instr'.asBinaryStr(NaN);
                  return {objects: {instr_str: new fabric.Text(instr_str, {
                     top: 0,
                     left: 0,
                     fontSize: 14,
                     fontFamily: "monospace"
                  })}};
               },
               where: {left: -580, top: 0}
             
      @0
         /defaults
            {$is_lui, $is_auipc, $is_jal, $is_jalr, $is_beq, $is_bne, $is_blt, $is_bge, $is_bltu, $is_bgeu, $is_lb, $is_lh, $is_lw, $is_lbu, $is_lhu, $is_sb, $is_sh, $is_sw} = '0;
            {$is_addi, $is_slti, $is_sltiu, $is_xori, $is_ori, $is_andi, $is_slli, $is_srli, $is_srai, $is_add, $is_sub, $is_sll, $is_slt, $is_sltu, $is_xor} = '0;
            {$is_srl, $is_sra, $is_or, $is_and, $is_csrrw, $is_csrrs, $is_csrrc, $is_csrrwi, $is_csrrsi, $is_csrrci} = '0;
            {$is_load, $is_store} = '0;

            $valid               = 1'b1;
            $rd[4:0]             = 5'b0;
            $rs1[4:0]            = 5'b0;
            $rs2[4:0]            = 5'b0;
            $src1_value[31:0]    = 32'b0;
            $src2_value[31:0]    = 32'b0;

            $result[31:0]        = 32'b0;
            $pc[31:0]            = 32'b0;
            $imm[31:0]           = 32'b0;

            $is_s_instr          = 1'b0;

            $rd_valid            = 1'b0;
            $rs1_valid           = 1'b0;
            $rs2_valid           = 1'b0;
            $rf_wr_en            = 1'b0;
            $rf_wr_index[4:0]    = 5'b0;
            $rf_wr_data[31:0]    = 32'b0;
            $rf_rd_en1           = 1'b0;
            $rf_rd_en2           = 1'b0;
            $rf_rd_index1[4:0]   = 5'b0;
            $rf_rd_index2[4:0]   = 5'b0;

            $ld_data[31:0]       = 32'b0;
            $imem_rd_en          = 1'b0;
            $imem_rd_addr[m5_IMEM_INDEX_CNT-1:0] = {m5_IMEM_INDEX_CNT{1'b0}};
            
            /xreg[31:0]
               $value[31:0]      = 32'b0;
               $wr               = 1'b0;
               `BOGUS_USE($value $wr)
               $dummy[0:0]       = 1'b0;
            /dmem[15:0]
               $value[31:0]      = 32'b0;
               $wr               = 1'b0;
               `BOGUS_USE($value $wr) 
               $dummy[0:0]       = 1'b0;
            `BOGUS_USE($is_lui $is_auipc $is_jal $is_jalr $is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_lb $is_lh $is_lw $is_lbu $is_lhu $is_sb $is_sh $is_sw)
            `BOGUS_USE($is_addi $is_slti $is_sltiu $is_xori $is_ori $is_andi $is_slli $is_srli $is_srai $is_add $is_sub $is_sll $is_slt $is_sltu $is_xor)
            `BOGUS_USE($is_srl $is_sra $is_or $is_and $is_csrrw $is_csrrs $is_csrrc $is_csrrwi $is_csrrsi $is_csrrci)
            `BOGUS_USE($is_load $is_store)
            `BOGUS_USE($valid $rd $rs1 $rs2 $src1_value $src2_value $result $pc $imm)
            `BOGUS_USE($is_s_instr $rd_valid $rs1_valid $rs2_valid)
            `BOGUS_USE($rf_wr_en $rf_wr_index $rf_wr_data $rf_rd_en1 $rf_rd_en2 $rf_rd_index1 $rf_rd_index2 $ld_data)
            `BOGUS_USE($imem_rd_en $imem_rd_addr)
            
            $dummy[0:0]          = 1'b0;
      @_stage
         $ANY = /top|cpu<>0$ANY;
         
         /xreg[31:0]
            $ANY = /top|cpu/xreg<>0$ANY;
            `BOGUS_USE($dummy)
         
         /dmem[15:0]
            $ANY = /top|cpu/dmem<>0$ANY;
            `BOGUS_USE($dummy)

         // m5_mnemonic_expr is build for WARP-V signal names, which are slightly different. Correct them.
         m4_define(['m4_modified_mnemonic_expr'], ['m4_patsubst(m5_mnemonic_expr, ['_instr'], [''])'])
         $mnemonic[10*8-1:0] = m4_modified_mnemonic_expr $is_load ? "LOAD      " : $is_store ? "STORE     " : "ILLEGAL   ";
         \viz_js
            box: {left: -600, top: -20, width: 2000, height: 1000, strokeWidth: 0},
            render() {
               //
               // PC instr_mem pointer
               //
               let $pc = '$pc';
               let color = !('$valid'.asBool()) ? "gray" :
                                                  "blue";
               let pcPointer = new fabric.Text("->", {
                  top: 18 * ($pc.asInt() / 4),
                  left: -600,
                  fill: color,
                  fontSize: 14,
                  fontFamily: "monospace"
               });
               //
               //
               // Fetch Instruction
               //
               // TODO: indexing only works in direct lineage.  let fetchInstr = new fabric.Text('|fetch/instr_mem[$Pc]$instr'.asString(), {  // TODO: make indexing recursive.
               //let fetchInstr = new fabric.Text('$raw'.asString("--"), {
               //   top: 50,
               //   left: 90,
               //   fill: color,
               //   fontSize: 14,
               //   fontFamily: "monospace"
               //});
               //
               // Instruction with values.
               //
               let regStr = (valid, regNum, regValue) => {
                  return valid ? `x${regNum} (${regValue})` : `xX`;
               };
               let srcStr = ($src, $valid, $reg, $value) => {
                  return $valid.asBool(false)
                             ? `\n      ${regStr(true, $reg.asInt(NaN), $value.asInt(NaN))}`
                             : "";
               };
               let str = `${regStr('$rd_valid'.asBool(false), '$rd'.asInt(NaN), '$result'.asInt(NaN))}\n` +
                         `  = ${'$mnemonic'.asString()}${srcStr(1, '$rs1_valid', '$rs1', '$src1_value')}${srcStr(2, '$rs2_valid', '$rs2', '$src2_value')}\n` +
                         `      i[${'$imm'.asInt(NaN)}]`;
               let instrWithValues = new fabric.Text(str, {
                  top: 70,
                  left: 90,
                  fill: color,
                  fontSize: 14,
                  fontFamily: "monospace"
               });
               return [pcPointer, instrWithValues];
            }
         //
         // Register file
         //
         /xreg[31:0]           
            \viz_js
               box: {width: 90, height: 18, strokeWidth: 0},
               all: {
                  box: {strokeWidth: 0},
                  init() {
                     let regname = new fabric.Text("Reg File", {
                        top: -20, left: 2,
                        fontSize: 14,
                        fontFamily: "monospace"
                     });
                     return {regname};
                  }
               },
               init() {
                  let reg = new fabric.Text("", {
                     top: 0, left: 0,
                     fontSize: 14,
                     fontFamily: "monospace"
                  });
                  return {reg};
               },
               render() {
                  let mod = '$wr'.asBool(false);
                  let reg = parseInt(this.getIndex());
                  let regIdent = reg.toString();
                  let oldValStr = mod ? `(${'>>1$value'.asInt(NaN).toString()})` : "";
                  this.getObjects().reg.set({
                     text: regIdent + ": " + '$value'.asInt(NaN).toString() + oldValStr,
                     fill: mod ? "blue" : "black"});
               },
               where: {left: 365, top: -20},
               where0: {left: 0, top: 0}
         //
         // DMem
         //
         /dmem[15:0]
            \viz_js
               box: {width: 100, height: 18, strokeWidth: 0},
               all: {
                  box: {strokeWidth: 0},
                  init() {
                  let memname = new fabric.Text("Mini DMem", {
                        top: -20,
                        left: 2,
                        fontSize: 14,
                        fontFamily: "monospace"
                     });
                     return {memname};
                  }
               },
               init() {
                  let mem = new fabric.Text("", {
                     top: 0,
                     left: 10,
                     fontSize: 14,
                     fontFamily: "monospace"
                  });
                  return {mem};
               },
               render() {
                  let mod = '$wr'.asBool(false);
                  let mem = parseInt(this.getIndex());
                  let memIdent = mem.toString();
                  let oldValStr = mod ? `(${'>>1$value'.asInt(NaN).toString()})` : "";
                  this.getObjects().mem.set({
                     text: memIdent + ": " + '$value'.asInt(NaN).toString() + oldValStr,
                     fill: mod ? "blue" : "black"});
               },
               where: {left: 458, top: -20},
               where0: {left: 0, top: 0}
   '])    
   '])
\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\m5
   
   TLV_fn(riscv_sum_prog, {
      ~assemble(['
         # /====================\
         # | Sum 1 to 9 Program |
         # \====================/
         #
         # Program for RISC-V Workshop to test RV32I
         # Add 1,2,3,...,9 (in that order).
         #
         # Regs:
         #  x10 (a0): In: 0, Out: final sum
         #  x12 (a2): 10
         #  x13 (a3): 1..10
         #  x14 (a4): Sum
         # 
         # External to function:
         reset:
            ADD x10, x0, x0             # Initialize r10 (a0) to 0.
         # Function:
            ADD x14, x10, x0            # Initialize sum register a4 with 0x0
            ADDI x12, x10, 10            # Store count of 10 in register a2.
            ADD x13, x10, x0            # Initialize intermediate sum register a3 with 0
         loop:
            ADD x14, x13, x14           # Incremental addition
            ADDI x13, x13, 1            # Increment count register by 1
            BLT x13, x12, loop          # If a3 is less than a2, branch to label named <loop>
         done:
            ADD x10, x14, x0            # Store final result to register a0 so that it can be read by main program

         # Optional:
            JAL x7, 00000000000000000000  # Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
      '])
   })
   
   

\TLV
   m5+riscv_gen()
   m5+riscv_sum_prog()
   m5_define_hier(IMEM, m5_NUM_INSTRS)
   |cpu
      @0
         $reset = *reset;



      // YOUR CODE HERE
      // ...

      // Note: Because of the magic we are using for visualisation, if visualisation is enabled below,
      //       be sure to avoid having unassigned signals (which you might be using for random inputs)
      //       other than those specifically expected in the labs. You'll get strange errors for these.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
   // Macro instantiations for:
   //  o instruction memory
   //  o register file
   //  o data memory
   //  o CPU visualization
   |cpu
      m4+imem(@1)    // Args: (read stage)
      //m4+rf(@1, @1)  // Args: (read stage, write stage) - if equal, no register bypass is required
      //m4+dmem(@4)    // Args: (read/write stage)

   m4+cpu_viz(@4)    // For visualisation, argument should be at least equal to the last stage of CPU logic. @4 would work for all labs.
\SV
   endmodule
