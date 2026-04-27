class ahb_sequence extends uvm_sequence#(ahb_txn);
	
	`uvm_object_utils(ahb_sequence)
	
	bit [31:0] haddr;
	bit [2:0]  hburst,hsize;
	bit [1:0]  htrans;
	bit	   hwrite;
	bit [7:0]  length;
	int j;
	int start_address;
	int wrap_address;

	function new(string name="ahb_sequence");
		super.new(name);
	endfunction

endclass

class single_seq extends ahb_sequence;
	
	`uvm_object_utils(single_seq)

	function new(string name="single_seq");
		super.new(name);
	endfunction

	task body();
	repeat(10)
	begin
		req=ahb_txn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { Hburst==3'b000; Hwrite==1; Htrans==2'b10;})
		finish_item(req);
	

	//	`uvm_info("single_seq","Printing from seq of single_seq",UVM_LOW);
	//	req.print;
	end
	endtask

endclass

class incr4_seq extends ahb_sequence;

	`uvm_object_utils(incr4_seq)

	
	function new(string name="incr4_seq");
		super.new(name);
	endfunction

	task body();
		begin
		    req=ahb_txn::type_id::create("req");
			
			start_item(req);
			assert(req.randomize() with {Hburst==3'b011; Hwrite==1; Htrans==2'b10;})
			finish_item(req);

			haddr	= req.Haddr;
			hsize	= req.Hsize;
			htrans	= req.Htrans;
			hwrite	= req.Hwrite;
			hburst	= req.Hburst;
			length	= req.length;
			

			for(int i=0;i<3;i++)
				begin
				start_item(req);
				assert(req.randomize() with {Hburst==hburst; Hsize==hsize; Haddr==haddr+2**hsize; Htrans==2'b11; Hwrite==hwrite;})
				finish_item(req);
				haddr = req.Haddr;				
				end

		end
	endtask
	
endclass
	
class incr8_seq extends ahb_sequence;
	
		`uvm_object_utils(incr8_seq)
		
		function new(string name="incr8_seq");
			super.new(name);
		endfunction
		
		task body;
			begin
				req=ahb_txn::type_id::create("req");
				
				start_item(req);
				assert(req.randomize() with {Hburst==3'b101; Hwrite==1; Htrans==2'b10;});
				finish_item(req);
				
				haddr	= req.Haddr;
				hsize	= req.Hsize;
				htrans	= req.Htrans;
				hwrite	= req.Hwrite;
				hburst	= req.Hburst;
				length	= req.length;
				
				for(int i=0;i<7;i++)
					begin
						start_item(req);
						assert(req.randomize() with {Hburst==hburst; Hsize==hsize; Haddr==haddr+2**hsize; Htrans==2'b11; Hwrite==hwrite;})
						finish_item(req);
						haddr=req.Haddr;
					end
			end
		endtask

endclass

class incr16_seq extends ahb_sequence;

	`uvm_object_utils(incr16_seq)
	
	function new(string name="incr16_seq");
		super.new(name);
	endfunction
	
	task body;
		begin
		
			req=ahb_txn::type_id::create("req");
			
			start_item(req);
			assert(req.randomize() with {Hburst==3'b111; Hwrite==1; Htrans==2'b10;});
			finish_item(req);
			
			haddr	= req.Haddr;
			hsize	= req.Hsize;
			htrans	= req.Htrans;
			hwrite	= req.Hwrite;
			hburst	= req.Hburst;
			length	= req.length;
			
			for(int i=0;i<15;i++)
				begin
					start_item(req);
					assert(req.randomize() with {Hburst==hburst; Hsize==hsize; Htrans==2'b11; Hwrite==hwrite; Haddr==haddr+2**hsize;});
					finish_item(req);
					haddr=req.Haddr;
				end
			
		end
		
	endtask
	
endclass

class wrap_seqs extends ahb_sequence ;
 

 `uvm_object_utils(wrap_seqs);

 

	function new(string name = "wrap_seqs");
 		super.new(name);
	endfunction: new

	task body();
	//repeat(3)
		begin
  			req = ahb_txn::type_id::create("req");
  			start_item(req);
  			assert(req.randomize() with { Htrans == 2'b10;Hburst inside {2,4,6} ;});
 			`uvm_info("WRAP_SEQ",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
  			finish_item(req);

  			haddr	= req.Haddr;
			hsize	= req.Hsize;
			htrans	= req.Htrans;
			hwrite	= req.Hwrite;
			hburst	= req.Hburst;
			length	= req.length;

			start_address=int'((haddr/((2**hsize)*(length+1))))*((2**hsize)*(length+1));



			wrap_address=start_address+((2**hsize)*(length+1));
    				for(int i =0; i < length+1; i++)
   				 begin
					haddr=req.Haddr+(2**hsize);

      					start_item(req);

					if(haddr>=wrap_address)
						haddr=start_address;
  
      					assert(req.randomize() with {Hwrite == hwrite    ;
                                     				     Hburst == hburst    ;
                                     				     Hsize  == hsize     ;
                                     				     Htrans == 2'b11     ;
                                     				     Haddr  == haddr;})  ;

 					finish_item(req);
    					haddr=req.Haddr+(2**hsize);
    				end
		end

	endtask
endclass

