class apb_sequence extends uvm_sequence#(apb_txn);
	
	`uvm_object_utils(apb_sequence)
	
	function new(string name="apb_sequence");
		super.new(name);
	endfunction 
endclass
