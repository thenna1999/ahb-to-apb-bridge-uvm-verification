module top;

	import test_pkg::*;

	import uvm_pkg::*;
	
	bit clk;
	
	always
	#5 clk=~clk;
	
	ahb_if a_if(clk);
	apb_if a_if0(clk);
	
	rtl_top  dut(.Hclk(clk),
			.Hresetn(a_if.Hresetn),
			.Htrans(a_if.Htrans),
			.Hsize(a_if.Hsize),
			.Hreadyin(a_if.Hreadyin),
			.Hwdata(a_if.Hwdata),
			.Haddr(a_if.Haddr),
			.Hwrite(a_if.Hwrite),
			.Hrdata(a_if.Hrdata),
			.Hresp(a_if.Hresp),
			.Hreadyout(a_if.Hreadyout),
			.Prdata(a_if0.Prdata),
			.Pselx(a_if0.Pselx),
			.Pwrite(a_if0.Pwrite),
			.Penable(a_if0.Penable),
			.Paddr(a_if0.Paddr),
			.Pwdata(a_if0.Pwdata));

	initial
		begin
		
			uvm_config_db#(virtual ahb_if)::set(null,"*","ahb_if",a_if);
			uvm_config_db#(virtual apb_if)::set(null,"*","apb_if",a_if0);
			run_test();
		end
endmodule

