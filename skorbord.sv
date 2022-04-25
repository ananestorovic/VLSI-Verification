`include "uvm_macros.svh"
import uvm_pkg::*;
import transakcija_sv_unit::*;

class skorbord extends uvm_scoreboard;

	`uvm_component_utils(skorbord)

	function new(string name = "skorbord", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	// TODO
	bit[7:0] data = 8'd0;
	bit temp;
	bit serial_output_lsb;
	bit serial_output_msb;
	bit[7:0] parallel_output;

	localparam CLEAR = 15'h0001;
	localparam LOAD = 15'h0002;
	localparam INC = 15'h0004;
	localparam DEC = 15'h0008;
	localparam ADD = 15'h0010;
	localparam SUB = 15'h0020;
	localparam INVERT = 15'h0040;
	localparam SERIAL_INPUT_LSB = 15'h0080;
	localparam SERIAL_INPUT_MSB = 15'h0100;
	localparam SHIFT_LOGICAL_LEFT = 15'h0200;
	localparam SHIFT_LOGICAL_RIGHT = 15'h0400;
	localparam SHIFT_ARITHMETIC_LEFT = 15'h0800;
	localparam SHIFT_ARITHMETIC_RIGHT = 15'h1000;
	localparam ROTATE_LEFT = 15'h2000;
	localparam ROTATE_RIGHT = 15'h4000;

	uvm_analysis_imp #(transakcija,skorbord) imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		imp = new ("imp", this);
	endfunction

	virtual function write(transakcija t);
		// TODO
		if(serial_output_lsb == t.serial_output_lsb && 
			serial_output_msb == t.serial_output_msb &&
			parallel_output == t.parallel_output) begin
			`uvm_info("SCB", $sformatf("PASS! Expected: lsb_out = %0d, msb_out = %0d, parallel_out = %0d, and got: %s",serial_output_lsb, serial_output_msb, parallel_output,t.convert2str()), UVM_NONE)
		end else
			`uvm_error("SCB", $sformatf("ERROR! Expected: lsb_out = %0d, msb_out = %0d, parallel_out = %0d, and got: %s",serial_output_lsb, serial_output_msb, parallel_output, t.convert2str()));
		
		serial_output_lsb = 0;
		serial_output_msb = 0;

		if(t.control & CLEAR) begin
			data =  8'd0;
		end
		else if(t.control & LOAD) begin
			data =  t.parallel_input;
		end
		else if(t.control & INC) begin
			{serial_output_msb, data} =  data + 8'd1;
		end
		else if(t.control & DEC) begin
			{serial_output_msb, data} =  data - 8'd1;
		end
		else if(t.control & ADD) begin
			{serial_output_msb, data} =  data + t.parallel_input;
		end
		else if(t.control & SUB) begin
			{serial_output_msb, data} =  data - t.parallel_input;
		end
		else if(t.control & INVERT) begin
			data =  ~data;
		end
		else if(t.control & SERIAL_INPUT_LSB) begin
			{serial_output_msb, data} = {data ,t.serial_input_lsb};
		end
		else if(t.control & SERIAL_INPUT_MSB) begin
			{data, serial_output_lsb} = {t.serial_input_msb, data};
		end
		else if(t.control & SHIFT_LOGICAL_LEFT) begin
			serial_output_msb = data[7];
			data = data << 1;
		end
		else if(t.control & SHIFT_LOGICAL_RIGHT) begin
			serial_output_lsb = data[0];
			data = data >> 1;
		end
		else if(t.control & SHIFT_ARITHMETIC_LEFT) begin
			serial_output_msb = data[7];
			data = data <<< 1;
		end
		else if(t.control & SHIFT_ARITHMETIC_RIGHT) begin
			serial_output_lsb = data[0];
			temp = data[7]; // arithmetic shift iz nekog razloga ne radi
			data = data >>> 1;
			data[7] = temp;
		end
		else if(t.control & ROTATE_LEFT) begin
			serial_output_msb = data[7];
			temp = data[7];
			data = data << 1;
			data[0] = temp;
		end
		else if(t.control & ROTATE_RIGHT) begin
			serial_output_lsb = data[0];
			temp = data[0];
			data = data >> 1;
			data[7] = temp;
		end

		parallel_output = data;
		
	endfunction

endclass
