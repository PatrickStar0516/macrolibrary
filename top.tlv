\m4_TLV_version 1d: tl-x.org
\SV
   // <Your permissive open-source license here>

   // A starting template/example for developing a TL-Verilog library file, including a description of how
   // to use such a file from a Verilog/SystemVerilog project.
   //
   // This file contains:
   //   o fib(): A tiny example macro definition.
   //   o A dirt-simple example Makerchip-based testbench for that macro.
   //
   // Makerchip can be used for rapid path-clearing of the macro logic.
   //
   // The resulting macro(s) can be used outside of Makerchip in a Verilog/SystemVerilog project by
   // enabling TL-Verilog in the including file by:
   //   o using the necessary "\m4_TLV_version", "\SV", and "\TLV" regions
   //   o including this file
   //   o instantiating the macro
   // such as:
   //
   // ------------------------------------
   // \m4_TLV_version 1d: tl-x.org
   // \SV
   //    m4_include_lib(['this_file.tlv'])
   // 
   //    // Existing Verilog/SystemVerilog code, including a module definition containing an instantiation
   //    //   of this dut macro, such as:
   //    module fib(input logic clk, input logic reset, input logic run, output logic[31:0] val);
   // \TLV
   //       $run = *run;
   //       $reset = *reset;
   //       m4+fib()
   //       *val = $val;
   // \SV
   //    endmodule
   // -------------------------------------
   //
   // This above file can be converted to Verilog using SandPiper(TM) (locally or as a free service:
   //   http://redwoodeda.com/products).




//----------------------------
// A TLV macro definition, in this case, a Fibonacci sequence generator.

\TLV fib()
   $val[31:0] = ($reset || ! $run) ? 1 : >>1$val + >>2$val;




//----------------------------
// Makerchip testbench instantiating DUT.

\SV
   // Declare the Verilog module interface by which Makerchip and the testbench control simulation (using an m4 macro).
   m4_makerchip_module   // Compile within Makerchip to see expanded module definition.

// The testbench to provide stimulus and checking.
\TLV
   // Stimulus (drive inputs).
   $reset = *reset;
   $run = 1'b1;
   // Instantiate the DUT
   m4+fib()
   // Check outputs.
   *passed = *cyc_cnt == 20 && $val == 32'h452f; // Just pass.
   *failed = *cyc_cnt > 40;
\SV
   endmodule
