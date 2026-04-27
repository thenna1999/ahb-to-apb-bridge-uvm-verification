class apb_txn extends uvm_sequence_item;

	`uvm_object_utils(apb_txn)

	function new(string name="apb_txn");
		super.new(name);
	endfunction

		bit		Presetn;
		bit [2:0]	Pselx;
		bit 		Pwrite;
		bit		Penable;
		bit		Pready;
		bit [31:0] 	Paddr;
		bit [31:0]	Pwdata;
	rand	bit [31:0]	Prdata;
		bit		Pslverr;

	function void do_print(uvm_printer printer);
		super.do_print(printer);
	
		printer.print_field("Presetn",	this.Presetn,	$bits(Presetn),	UVM_DEC);
		printer.print_field("Pselx",	this.Pselx,	$bits(Pselx),	UVM_DEC);
		printer.print_field("Pwrite",	this.Pwrite,	$bits(Pwrite),	UVM_DEC);
		printer.print_field("Penable", 	this.Penable,	$bits(Penable),	UVM_DEC);
		printer.print_field("Pready",	this.Pready,	$bits(Pready),	UVM_DEC);
		printer.print_field("Paddr",	this.Paddr,	$bits(Paddr),	UVM_DEC);
		printer.print_field("Pwdata",	this.Pwdata,	$bits(Pwdata),	UVM_DEC);
		printer.print_field("Prdata",	this.Prdata,	$bits(Prdata),	UVM_DEC);

	endfunction
	
endclass

