`include "uvm_macros.svh"
import uvm_pkg::*;

class transakcija extends uvm_sequence_item;

	// TODO
	randc bit[14:0] control;
	rand bit serial_input_lsb;
	rand bit serial_input_msb;
	bit serial_output_lsb;
	bit serial_output_msb;
	rand bit[7:0] parallel_input;
	bit[7:0] parallel_output;

	`uvm_object_utils_begin(transakcija)
		// TODO
		`uvm_field_int(control, UVM_ALL_ON)
		`uvm_field_int(serial_input_lsb, UVM_ALL_ON)
		`uvm_field_int(serial_input_msb, UVM_ALL_ON)
		`uvm_field_int(serial_output_lsb, UVM_ALL_ON)
		`uvm_field_int(serial_output_msb, UVM_ALL_ON)
		`uvm_field_int(parallel_input, UVM_ALL_ON)
		`uvm_field_int(parallel_output, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "transakcija");
		super.new(name);
	endfunction

	// TODO
	virtual function string convert2str();
		return $sformatf("control = %b, [serial_in_lsb = %b, serial_out_lsb = %b], [serial_in_msb = %b, serial_out_msb = %b], [parallel_in = %0d, parallel_out = %0d]",
			control, serial_input_lsb, serial_output_lsb, serial_input_msb, serial_output_msb, parallel_input, parallel_output);
	endfunction

	// MOZE DA POBOLJSA POJAVLJIVANJE OP NIZEG PRIORITETA
	//constraint c { foreach(control[i]) { control[i] dist {1:=i+1, 0:=15-i}; }}

	// DA BI SE SIGURNO DESILA SVAKA MOZE OVO + randc NA control
	//constraint ctrl1 { control inside { 15'h0001, 15'h0002, 15'h0004, 15'h0008, 15'h0010, 15'h0020, 15'h0040, 15'h0080, 
	//			15'h0100, 15'h0200, 15'h0400, 15'h0800, 15'h1000, 15'h2000, 15'h4000 }; }

	// ISPROBAS POSEBNO ZA SVAKU OPERACIJU KOJA SE NE JAVI KAO ERROR KADA SU SVE INCLUDED
	//constraint ctrl2 { control inside { 15'h2000, 15'h0002 }; control dist { 15'h2000:=80, 15'h0002:=20 };}

endclass
