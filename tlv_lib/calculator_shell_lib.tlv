\m4_TLV_version 1d: tl-x.org
\SV

// Visualization for calculator
// The @_initial_stage should be the FIRST cycle of execution(place where Inputs are defined).
// The @_last_stage should be the LAST cycle of execution(place where Outputs are defined).
\TLV cal_viz(@_initial_stage, @_last_stage)
   m4_ifelse_block(m4_sp_graph_dangerous, 1, [''], ['
   |calc
      @_initial_stage
         $ANY = /top|tb/default<>0$ANY;
         `BOGUS_USE($dummy $rand2 $rand_op)
   |tb
      @_initial_stage
         /default
            $valid = 1;
            $op1[2:0] = '0;
            $val1[31:0] = '0;
            $val2[31:0] = '0;
            $out[31:0] = '0;
            $mem[31:0] = '0;
            m4_rand($rand_op_temp, 2, 0)
            m4_rand($rand2_temp, 3, 0)
            $rand_op[2:0] = $rand_op_temp;
            $rand2[3:0] = $rand2_temp;
            $dummy = 0;
            `BOGUS_USE($out $mem $valid $op1 $val1 $val2 $dummy)
      @_last_stage   
         $ANY = /top|calc<>0$ANY;

         $op_viz[2:0] = $op1;
         $is_op_sum     = ($valid && ($op_viz[2:0] == 3'b000)); // sum
         $is_op_diff    = ($valid && ($op_viz[2:0] == 3'b001)); // diff
         $is_op_prod    = ($valid && ($op_viz[2:0] == 3'b010)); // prod
         $is_op_quot    = ($valid && ($op_viz[2:0] == 3'b011)); // quot
         $is_op_recall  = ($valid && ($op_viz[2:0] == 3'b100)); // recall(retrieving from memory)
         $is_op_mem     = ($valid && ($op_viz[2:0] == 3'b101)); // mem(storing to memory)
         $is_invalid_op = ($valid && ($op_viz[2:0] == 3'b110 || $op_viz[2:0] == 3'b111)); // invalid operation?

         //These signal represents the change in value's and is used to generate colours in \viz according.
         $val1_changed = $valid && !$is_op_recall && !$is_invalid_op;
         $val2_changed = $valid && !$is_op_recall && !$is_op_mem && !$is_invalid_op;
         $out_changed  = $valid && ($out_modified || !(|$out_modified)) && !$is_invalid_op && !$is_op_mem;
         $out_modified[31:0] = ($out > ((1 << 31) - 1)) ? (~$out + 1) : $out;
         $is_neg_num = ($out > ((1 << 31) - 1));

         \viz_alpha
            initEach: function() {
            let calbox = new fabric.Rect({
              left: 150,
              top: 150,
              fill: "#eeeeeeff",
              width: 316,
              height: 366,
              stroke: "black",
              strokeWidth: 1,
            });
            let val1box = new fabric.Rect({
              left: 150 + 28,
              top: 150 + 83,
              fill: "#eeeeeeff",
              width: 254 + 14,
              height: 40,
              stroke: "black",
              strokeWidth: 1,
            });
            let val1num = new fabric.Text("", {
              left: 150 + 28 + 30,
              top: 150 + 89,
              fontSize: 22,
              fontFamily: "Times",
            });
            let val2box = new fabric.Rect({
              left: 150 + 187,
              top: 150 + 221,
              fill: "#eeeeeeff",
              width: 109,
              height: 40,
              stroke: "black",
              strokeWidth: 1,
            });
            let val2num = new fabric.Text("", {
              left: 150 + 187 + 1,
              top: 150 + 221 + 7,
              fontSize: 22,
              fontFamily: "Times",
            });
            let outbox = new fabric.Rect({
              left: 150 + 97,
              top: 150 + 300,
              fill: "#eeeeeeff",
              width: 199,
              height: 40,
              stroke: "black",
              strokeWidth: 1,
            });
            let outnum = new fabric.Text("", {
              left: 150 + 97 + 20,
              top: 150 + 300 + 8,
              fontSize: 22,
              fontFamily: "Times",
            });
            let outnegsign = new fabric.Text("-", {
              left: 150 + 97 + 8,
              top: 150 + 300 + 6,
              fontSize: 22,
              fontFamily: "Times",
              fill : "#eeeeeeff",
            });
            let equalname = new fabric.Text("=", {
              left: 150 + 38,
              top: 150 + 306,
              fontSize: 28,
              fontFamily: "Times",
            });
              let sumbox = new fabric.Rect({
              left: 150 + 28,
              top: 150 + 148,
              fill: "#eeeeeeff",
              width: 64,
              height: 64,
              stroke: "black",
              strokeWidth: 1
            });
            let prodbox = new fabric.Rect({
              left: 150 + 28,
              top: 150 + 222,
              fill: "#eeeeeeff",
              width: 64,
              height: 64,
              stroke: "black",
              strokeWidth: 1
            });
            let minbox = new fabric.Rect({
              left: 150 + 105,
              top: 150 + 148,
              fill: "#eeeeeeff",
              width: 64,
              height: 64,
              stroke: "black",
              strokeWidth: 1
            });
            let quotbox = new fabric.Rect({
              left: 150 + 105,
              top: 150 + 222,
              fill: "#eeeeeeff",
              width: 64,
              height: 64,
              stroke: "black",
              strokeWidth: 1
            });
            let sumicon = new fabric.Text("+", {
              left: 150 + 28 + 26,
              top: 150 + 148 + 22,
              fontSize: 22,
              fontFamily: "Times",
            });
            let prodicon = new fabric.Text("*", {
              left: 150 + 28 + 26,
              top: 150 + 222 + 22,
              fontSize: 22,
              fontFamily: "Times",
            });
            let minicon = new fabric.Text("-", {
              left: 150 + 105 + 26,
              top: 150 + 148 + 22,
              fontSize: 22,
              fontFamily: "Times",
            });
            let quoticon = new fabric.Text("/", {
              left: 150 + 105 + 26,
              top: 150 + 222 + 22,
              fontSize: 22,
              fontFamily: "Times",
            });
              let membox = new fabric.Rect({
              left: 105 + 150,
              top: 150 + 25,
              fill: "#eeeeeeff",
              width: 191,
              height: 23,
              stroke: "black",
              strokeWidth: 1,
            });
            let memname = new fabric.Text("mem", {
              left: 150 + 28,
              top: 150 + 25,
              fontSize: 22,
              fontFamily: "Times",
            });
            let memarrow = new fabric.Text("->", {
              left: 150 + 32 + 47,
              top: 150 + 25,
              fill: "#eeeeeeff",
              fontSize: 22,
              fontFamily: "monospace",
            });
            let recallarrow = new fabric.Text("->", {
              left: 150 + 38 + 28,
              top: 150 + 308,
              fill: "#eeeeeeff",
              fontSize: 22,
              fontFamily: "monospace",
            });
            let memnum = new fabric.Text("", {
              left: 150 + 105 + 30,
              top: 150 + 25,
              fontSize: 22,
              fontFamily: "Times",
            });
            let membuttonbox = new fabric.Rect({
              left: 150 + 187,
              top: 150 + 151,
              fill: "#eeeeeeff",
              width: 45,
              height: 40,
              stroke: "black",
              strokeWidth: 1
            });
            let recallbuttonbox = new fabric.Rect({
              left: 150 + 245,
              top: 150 + 151,
              fill: "#eeeeeeff",
              width: 51,
              height: 40,
              stroke: "black",
              strokeWidth: 1
            });
            let membuttonname = new fabric.Text("mem", {
              left: 150 + 187 + 1,
              top: 150 + 151 + 7,
              fontSize: 22,
              fontFamily: "Times",
            });
            let recallbuttonname = new fabric.Text("recall", {
              left: 150 + 245 + 1,
              top: 150 + 151 + 7,
              fontSize: 22,
              fontFamily: "Times",
            });
            return {objects: {calbox: calbox, val1box: val1box, val1num: val1num, val2box: val2box, val2num: val2num, outbox: outbox, outnum: outnum, equalname: equalname, sumbox: sumbox, minbox: minbox, prodbox: prodbox, quotbox: quotbox, sumicon: sumicon, prodicon: prodicon, minicon: minicon, quoticon: quoticon, outnegsign: outnegsign,  membox: membox, memname: memname, memnum: memnum, membuttonbox: membuttonbox, recallbuttonbox: recallbuttonbox, membuttonname: membuttonname, recallbuttonname: recallbuttonname, memarrow: memarrow, recallarrow: recallarrow}};
            },
            renderEach: function() {
               let colorsum =  '$is_op_sum'.asBool(false);
               let colorprod = '$is_op_prod'.asBool(false);
               let colormin = '$is_op_diff'.asBool(false);
               let colorquot = '$is_op_quot'.asBool(false);
               let colormembutton = '$is_op_mem'.asBool(false);
               let colorrecallbutton = '$is_op_recall'.asBool(false);
               let colormemarrow = '$is_op_mem'.asBool(false);
               let colorrecallarrow = '$is_op_recall'.asBool(false);
               let recallmod = '$is_op_recall'.asBool(false);
               let val1mod = '$val1_changed'.asBool(false);
               let val2mod = '$val2_changed'.asBool(false);
               let outmod = '$out_changed'.asBool(false);
               let colornegnum = '$is_neg_num'.asBool(false);
               let oldvalval1 = ""; // for debugging
               let oldvalval2 = ""; // for debugging
               let oldvalout = ""; // for debugging
               let oldvalrecall = ""; // for debugging
               this.getInitObject("val1num").setText(
                  '$val1'.asInt(NaN).toString() + oldvalval1);
               this.getInitObject("val1num").setFill(val1mod ? "blue" : "grey");
               this.getInitObject("val2num").setText(
                  '$val2'.asInt(NaN).toString() + oldvalval2);
               this.getInitObject("val2num").setFill(val2mod ? "blue" : "grey");
               this.getInitObject("outnum").setText(
                  '$out_modified'.asInt(NaN).toString() + oldvalout);
               this.getInitObject("outnum").setFill(outmod ? "blue" : "grey");
               this.getInitObject("memnum").setText(
                  '$mem'.asInt(NaN).toString() + oldvalrecall);
               this.getInitObject("memnum").setFill((recallmod || colormembutton) ? "blue" : "grey");
               this.getInitObject("outnegsign").setFill(colornegnum ?  "blue" : "#eeeeeeff");
               this.getInitObject("sumbox").setFill(colorsum ?  "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("minbox").setFill(colormin ?  "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("prodbox").setFill(colorprod ? "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("quotbox").setFill(colorquot ?  "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("membuttonbox").setFill(colormembutton ? "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("recallbuttonbox").setFill(colorrecallbutton ?  "#9fc5e8ff" : "#eeeeeeff");
               this.getInitObject("memarrow").setFill(colormemarrow ? "blue" : "#eeeeeeff");
               this.getInitObject("recallarrow").setFill(colorrecallarrow ?  "blue" : "#eeeeeeff");
             }
   '])
