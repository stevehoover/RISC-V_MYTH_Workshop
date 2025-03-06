\m4_TLV_version 1d: tl-x.org
\SV
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/warp-v_includes/2d6d36baa4d2bc62321f982f78c8fe1456641a43/risc-v_defs.tlv'])

m4+definitions(['
m4_ifelse_block(M4_MAKERCHIP, 1,['
   m4_define_vector(['M4_WORD'], 32)
   m4_define(['M4_EXT_I'], 1)
   m4_define(['M4_NUM_INSTRS'], 0)
   m4_echo(m4tlv_riscv_gen__body())
'],['
   m4_define(['m4_asm'], )
   m4_define(['M4_NUM_INSTRS'], 1073741824)
   m4_define(['m4_makerchip_module'], ['module riscv(input clk, input reset, input [31:0] idata0, idata1, idata2, idata3, idata4, idata5, idata6, idata7, idata8, idata9, idata10, idata11, idata12, idata13, idata14, idata15, idata16, idata17, idata18, idata19, idata20, idata21, idata22, idata23, idata24, idata25, idata26, idata27, idata28, idata29, idata30, idata31, output reg [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31); wire cyc_cnt; wire passed; wire failed; assign cyc_cnt = 100; // cyc_cnt, passed and failed signals are valid only when running on makerchip, not valid here!'])
'])
'])

// Instruction memory in |cpu at the given stage.
\TLV imem(@_stage)
   // Instruction Memory containing program defined by m4_asm(...) instantiations.
   @_stage
      m4_ifelse_block(M4_MAKERCHIP, 1,['
      \SV_plus
         // The program in an instruction memory.
         wire [31:0] instrs [0:M4_NUM_INSTRS-1];
         assign instrs[0] = m4_instr0;m4_forloop(['m4_instr_ind'], 1, M4_NUM_INSTRS, [' assign instrs[m4_instr_ind] = m4_echo(['m4_instr']m4_instr_ind);'])
      /M4_IMEM_HIER
         $instr[31:0] = *instrs\[#imem\];
      ?$imem_rd_en
         $imem_rd_data[31:0] = /imem[$imem_rd_addr]$instr;
      '],['
      
      ?$imem_rd_en
         $imem_rd_data[31:0] = ($imem_rd_addr[31:0] == 0) ? *idata0 :
                        ($imem_rd_addr[31:0] == 1) ? *idata1 :
                        ($imem_rd_addr[31:0] == 2) ? *idata2 :
                        ($imem_rd_addr[31:0] == 3) ? *idata3 :
                        ($imem_rd_addr[31:0] == 4) ? *idata4 :
                        ($imem_rd_addr[31:0] == 5) ? *idata5 :
                        ($imem_rd_addr[31:0] == 6) ? *idata6 :
                        ($imem_rd_addr[31:0] == 7) ? *idata7 :
                        ($imem_rd_addr[31:0] == 8) ? *idata8 :
                        ($imem_rd_addr[31:0] == 9) ? *idata9 :
                        ($imem_rd_addr[31:0] == 10) ? *idata10 :
                        ($imem_rd_addr[31:0] == 11) ? *idata11 :
                        ($imem_rd_addr[31:0] == 12) ? *idata12 :
                        ($imem_rd_addr[31:0] == 13) ? *idata13 :
                        ($imem_rd_addr[31:0] == 14) ? *idata14 :
                        ($imem_rd_addr[31:0] == 15) ? *idata15 :
                        ($imem_rd_addr[31:0] == 16) ? *idata16 :
                        ($imem_rd_addr[31:0] == 17) ? *idata17 :
                        ($imem_rd_addr[31:0] == 18) ? *idata18 :
                        ($imem_rd_addr[31:0] == 19) ? *idata19 :
                        ($imem_rd_addr[31:0] == 20) ? *idata20 :
                        ($imem_rd_addr[31:0] == 21) ? *idata21 :
                        ($imem_rd_addr[31:0] == 22) ? *idata22 :
                        ($imem_rd_addr[31:0] == 23) ? *idata23 :
                        ($imem_rd_addr[31:0] == 24) ? *idata24 :
                        ($imem_rd_addr[31:0] == 25) ? *idata25 :
                        ($imem_rd_addr[31:0] == 26) ? *idata26 :
                        ($imem_rd_addr[31:0] == 27) ? *idata27 :
                        ($imem_rd_addr[31:0] == 28) ? *idata28 :
                        ($imem_rd_addr[31:0] == 29) ? *idata29 :
                        ($imem_rd_addr[31:0] == 30) ? *idata30 :
                        ($imem_rd_addr[31:0] == 31) ? *idata31 :
                        31'b0 ;
      '])  
    

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
      \SV_plus
         m4_ifelse_block(M4_MAKERCHIP, 1,[''],['
         always @ (posedge clk) begin    
            *reg0  = |cpu/xreg[0]>>5$value;          
            *reg1  = |cpu/xreg[1]>>5$value;
            *reg2  = |cpu/xreg[2]>>5$value;
            *reg3  = |cpu/xreg[3]>>5$value;
            *reg4  = |cpu/xreg[4]>>5$value;
            *reg5  = |cpu/xreg[5]>>5$value;      
            *reg6  = |cpu/xreg[6]>>5$value;
            *reg7  = |cpu/xreg[7]>>5$value;
            *reg8  = |cpu/xreg[8]>>5$value;          
            *reg9  = |cpu/xreg[9]>>5$value;
            *reg10 = |cpu/xreg[10]>>5$value;
            *reg11 = |cpu/xreg[11]>>5$value;
            *reg12 = |cpu/xreg[12]>>5$value;
            *reg13 = |cpu/xreg[13]>>5$value;      
            *reg14 = |cpu/xreg[14]>>5$value;
            *reg15 = |cpu/xreg[15]>>5$value;
            *reg16 = |cpu/xreg[16]>>5$value;          
            *reg17 = |cpu/xreg[17]>>5$value;
            *reg18 = |cpu/xreg[18]>>5$value;
            *reg19 = |cpu/xreg[19]>>5$value;
            *reg20 = |cpu/xreg[20]>>5$value;
            *reg21 = |cpu/xreg[21]>>5$value;      
            *reg22 = |cpu/xreg[22]>>5$value;
            *reg23 = |cpu/xreg[23]>>5$value;
            *reg24 = |cpu/xreg[24]>>5$value;          
            *reg25 = |cpu/xreg[25]>>5$value;
            *reg26 = |cpu/xreg[26]>>5$value;
            *reg27 = |cpu/xreg[27]>>5$value;
            *reg28 = |cpu/xreg[28]>>5$value;
            *reg29 = |cpu/xreg[29]>>5$value;      
            *reg30 = |cpu/xreg[30]>>5$value;
            *reg31 = |cpu/xreg[31]>>5$value;
         end
         '])

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
      logic [40*8-1:0] instr_strs [0:M4_NUM_INSTRS];
      assign instr_strs = '{m4_asm_mem_expr "END                                     "};
   |cpuviz
      @1
         /imem[m4_eval(M4_NUM_INSTRS-1):0]  // TODO: Cleanly report non-integer ranges.
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
            $imem_rd_addr[M4_IMEM_INDEX_CNT-1:0] = {M4_IMEM_INDEX_CNT{1'b0}};
            
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

         // m4_mnemonic_expr is build for WARP-V signal names, which are slightly different. Correct them.
         m4_define(['m4_modified_mnemonic_expr'], ['m4_patsubst(m4_mnemonic_expr, ['_instr'], [''])'])
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
                  return valid ? `r${regNum} (${regValue})` : `rX`;
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