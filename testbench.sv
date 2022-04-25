`include "uvm_macros.svh"
import uvm_pkg::*;
import test_sv_unit::*;

module testbench;

	reg clk;

	// TODO
	interfejs i(clk);
	register dut_inst(.clk(clk),.rst_n(i.rst_n),.control(i.control),
		.serial_input_lsb(i.serial_input_lsb),.serial_input_msb(i.serial_input_msb),
		.parallel_input(i.parallel_input), 
		.serial_output_lsb(i.serial_output_lsb),.serial_output_msb(i.serial_output_msb),
		.parallel_output(i.parallel_output)
	);


	initial begin
		clk <= 0;
		uvm_config_db#(virtual interfejs)::set(null, "*", "i", i);
		run_test("test");
	end

	always
		#10 clk = ~clk;

endmodule
