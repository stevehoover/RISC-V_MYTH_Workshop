\m4_TLV_version 1d: tl-x.org
\SV
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/warp-v_includes/2d6d36baa4d2bc62321f982f78c8fe1456641a43/risc-v_defs.tlv'])

m4+definitions(['
   m4_define_vector(['M4_WORD'], 32)
   m4_define(['M4_EXT_I'], 1)

   m4_define(['M4_NUM_INSTRS'], 0)
   
   m4_echo(m4tlv_riscv_gen__body())
'])
\TLV myth_shell()
   // ==========
   // MYTH Shell (Provided)
   // ==========
   \SV_plus
      // The program in an instruction memory.
      logic [31:0] instrs [0:M4_NUM_INSTRS-1];
      
      assign instrs = '{
         m4_instr0['']m4_forloop(['m4_instr_ind'], 1, M4_NUM_INSTRS, [', m4_echo(['m4_instr']m4_instr_ind)'])
      };
      
      // String representations of the instructions for debug.
   |cpu
      @1
         /M4_IMEM_HIER
            $instr[31:0] = *instrs\[#imem\];

\TLV cpu_viz(@_stage)
   \SV_plus
      logic [40*8-1:0] instr_strs [0:M4_NUM_INSTRS];
      assign instr_strs = '{m4_asm_mem_expr "END                                     "};
   |vizcpu
      @1
         $ANY = /top|cpu$ANY;
         /imem[m4_eval(M4_NUM_INSTRS-1):0]  // TODO: Cleanly report non-integer ranges.
            $ANY = /top|cpu/imem$ANY;
            $instr_str[40*8-1:0] = *instr_strs[imem];
            \viz_alpha
               renderEach: function() {
                  // Instruction memory is constant, so just create it once.
                  if (!global.instr_mem_drawn) {
                     global.instr_mem_drawn = [];
                  }
                  if (!global.instr_mem_drawn[this.getIndex()]) {
                     global.instr_mem_drawn[this.getIndex()] = true;
                     let instr_str = '$instr_str'.asString() + ": " + '$instr'.asBinaryStr(NaN);
                     this.getCanvas().add(new fabric.Text(instr_str, {
                        top: 18 * this.getIndex(),  // TODO: Add support for '#instr_mem'.
                        left: -580,
                        fontSize: 14,
                        fontFamily: "monospace"
                     }));
                  }
               }
      @_stage
         /defaults
            $ANY = /top|cpu/defaults$ANY;
            {$is_lui, $is_auipc, $is_jal, $is_jalr, $is_beq, $is_bne, $is_blt, $is_bge, $is_bltu, $is_bgeu, $is_lb, $is_lh, $is_lw, $is_lbu, $is_lhu, $is_sb, $is_sh, $is_sw} = '0;
            {$is_addi, $is_slti, $is_sltiu, $is_xori, $is_ori, $is_andi, $is_slli, $is_srli, $is_srai, $is_add, $is_sub, $is_sll, $is_slt, $is_sltu, $is_xor} = '0;
            {$is_srl, $is_sra, $is_or, $is_and, $is_csrrw, $is_csrrs, $is_csrrc, $is_csrrwi, $is_csrrsi, $is_csrrci} = '0;
            $valid = 1'b1;
            $rd[4:0] = '0;
            $rs1[4:0] = '0;
            $rs2[4:0] = '0;
            $rs1_value[31:0] = '0;
            $rs2_value[31:0] = '0;
            $result[31:0] = '0;
            $pc[31:0] = '0;
            $imm[31:0] = '0;
            $is_s_instr = 1'b0;
            $rd_valid = 1'b0;
            $rs1_valid = 1'b0;
            $rs2_valid = 1'b0;
            
            /xreg[31:0]
               $value[31:0] = '0;
               `BOGUS_USE($value)
               $dummy[0:0] = 1'b0;
            /dmem[15:0]
               $value[31:0] = '0;
               `BOGUS_USE($value)
               $dummy[0:0] = 1'b0;
            `BOGUS_USE($is_lui $is_auipc $is_jal $is_jalr $is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_lb $is_lh $is_lw $is_lbu $is_lhu $is_sb $is_sh $is_sw)
            `BOGUS_USE($is_addi $is_slti $is_sltiu $is_xori $is_ori $is_andi $is_slli $is_srli $is_srai $is_add $is_sub $is_sll $is_slt $is_sltu $is_xor)
            `BOGUS_USE($is_srl $is_sra $is_or $is_and $is_csrrw $is_csrrs $is_csrrc $is_csrrwi $is_csrrsi $is_csrrci)
            `BOGUS_USE($valid $rd $rs1 $rs2 $rs1_value $rs2_value $result $pc $imm)
            `BOGUS_USE($is_s_instr $rd_valid $rs1_valid $rs2_valid)
            $dummy[0:0] = 1'b0;
         $ANY = /defaults$ANY;
         `BOGUS_USE($dummy)
         /xreg[31:0]
            $ANY = |vizcpu/defaults/xreg$ANY;
            `BOGUS_USE($dummy)
         /dmem[15:0]
            $ANY = |vizcpu/defaults/dmem$ANY;
            `BOGUS_USE($dummy)
         
         // m4_mnemonic_expr is build for WARP-V signal names, which are slightly different. Correct them.
         m4_define(['m4_modified_mnemonic_expr'], ['m4_patsubst(m4_mnemonic_expr, ['_instr'], [''])'])
         $mnemonic[10*8-1:0] = m4_modified_mnemonic_expr "ILLEGAL   ";
         \viz_alpha
            //
            renderEach: function() {
               debugger;
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
                         `  = ${'$mnemonic'.asString()}${srcStr(1, '$rs1_valid', '$rs1', '$rs1_value')}${srcStr(2, '$rs2_valid', '$rs2', '$rs2_value')}\n` +
                         `      i[${'$imm'.asInt(NaN)}]`;
               let instrWithValues = new fabric.Text(str, {
                  top: 70,
                  left: 90,
                  fill: color,
                  fontSize: 14,
                  fontFamily: "monospace"
               });
               return {objects: [pcPointer, instrWithValues]};
            }
         //
         // Register file
         //
         /xreg[31:0]
            \viz_alpha
               initEach: function() {
                  let regname = new fabric.Text("Reg File", {
                        top: -20,
                        left: 367,
                        fontSize: 14,
                        fontFamily: "monospace"
                     });
                  let reg = new fabric.Text("", {
                     top: 18 * this.getIndex(),
                     left: 375,
                     fontSize: 14,
                     fontFamily: "monospace"
                  });
                  return {objects: {regname: regname, reg: reg}};
               },
               renderEach: function() {
                  let mod = '|vizcpu$rd_valid'.asBool(false) && ('|vizcpu$rd'.asInt(-1) == this.getScope("xreg").index);
                  let reg = parseInt(this.getIndex());
                  let regIdent = reg.toString();
                  let oldValStr = mod ? `(${'$value'.asInt(NaN).toString()})` : "";
                  this.getInitObject("reg").setText(
                     regIdent + ": " +
                     '$value'.step(1).asInt(NaN).toString() + oldValStr);
                  this.getInitObject("reg").setFill(mod ? "blue" : "black");
               }
         //
         // DMem
         //
         /dmem[15:0]
            \viz_alpha
               initEach: function() {
                  let memname = new fabric.Text("Mini DMem", {
                        top: -20,
                        left: 460,
                        fontSize: 14,
                        fontFamily: "monospace"
                     });
                  let mem = new fabric.Text("", {
                     top: 18 * this.getIndex(),
                     left: 468,
                     fontSize: 14,
                     fontFamily: "monospace"
                  });
                  return {objects: {memname: memname, mem: mem}};
               },
               renderEach: function() {
                  let mod = '|vizcpu$is_s_instr'.asBool(false) && ('|vizcpu$result'.asInt(-1) == this.getScope("dmem").index);
                  let mem = parseInt(this.getIndex());
                  let memIdent = mem.toString();
                  let oldValStr = mod ? `(${'$value'.asInt(NaN).toString()})` : "";
                  this.getInitObject("mem").setText(
                     memIdent + ": " +
                     '$value'.step(1).asInt(NaN).toString() + oldValStr);
                  this.getInitObject("mem").setFill(mod ? "blue" : "black");
               }
