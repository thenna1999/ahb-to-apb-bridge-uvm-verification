class test extends uvm_test;

	`uvm_component_utils(test)

	function new(string name="test",uvm_component parent);
		super.new(name,parent);
	endfunction

	int no_magt=1;
	int no_sagt=1;

	ahb_config 	ahb_cfg[];
	apb_config 	apb_cfg[];
	env_config 	env_cfg;
	env       	env_h;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

	env_cfg=env_config::type_id::create("env_cfg");


	ahb_cfg=new[no_magt];
	env_cfg.ahb_cfg=new[no_magt];
	foreach(ahb_cfg[i])
		begin
			ahb_cfg[i]=ahb_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
			if(!uvm_config_db#(virtual ahb_if)::get(this,"","ahb_if",ahb_cfg[i].vif))
				`uvm_fatal("TEST","Cannot get virtual interface in ahb have you set it or not?");
			ahb_cfg[i].is_active=UVM_ACTIVE;
			env_cfg.ahb_cfg[i]=ahb_cfg[i];
		end

	
	apb_cfg=new[no_sagt];
	env_cfg.apb_cfg=new[no_sagt];
		foreach(apb_cfg[i])
			begin
				apb_cfg[i]=apb_config::type_id::create($sformatf("apb_cfg[%0d]",i));
				if(!uvm_config_db#(virtual apb_if)::get(this,"","apb_if",apb_cfg[i].vif))
				`uvm_fatal("TEST","Cannot get virtual interface in ahb have you set it or not?");
				apb_cfg[i].is_active=UVM_ACTIVE;
				env_cfg.apb_cfg[i]=apb_cfg[i];
			end

		env_cfg.no_magt=no_magt;
		env_cfg.no_sagt=no_sagt;

		uvm_config_db#(env_config)::set(this,"*","env_config",env_cfg);
		env_h=env::type_id::create("env_h",this);

	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

endclass

class single_test extends test;

	`uvm_component_utils(single_test)

	single_seq s_seq;

	function new(string name="single_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);

		s_seq=single_seq::type_id::create("s_seq");

		//repeat(10)
		//	begin
				phase.raise_objection(this);
				s_seq.start(env_h.ahb_agtth.ahb_agth[0].ahb_seqrh);
				phase.drop_objection(this);
		//	end
	endtask

endclass

class incr4_test extends test;

	`uvm_component_utils(incr4_test)

	incr4_seq incr4_h;

	function new(string name="incr4_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	
		incr4_h=incr4_seq::type_id::create("incr4_h");

		phase.raise_objection(this);
		incr4_h.start(env_h.ahb_agtth.ahb_agth[0].ahb_seqrh);
		#100;
		phase.drop_objection(this);

	endtask

endclass

class incr8_test extends test;

	`uvm_component_utils(incr8_test)
	
	incr8_seq incr8_h;
	
	function new(string name="incr8_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		
		incr8_h=incr8_seq::type_id::create("incr8_h");
		
		phase.raise_objection(this);
		incr8_h.start(env_h.ahb_agtth.ahb_agth[0].ahb_seqrh);
		#100;
		phase.drop_objection(this);
		
	endtask
	
endclass

class incr16_test extends test;

	`uvm_component_utils(incr16_test)
	
	incr16_seq incr16_h;
	
	function new(string name="incr16_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		
		incr16_h=incr16_seq::type_id::create("incr16_h");
		
		phase.raise_objection(this);
		incr16_h.start(env_h.ahb_agtth.ahb_agth[0].ahb_seqrh);
		#100;
		phase.drop_objection(this);
		
	endtask
	
endclass
	
	
	

