class env extends uvm_env;

	`uvm_component_utils(env)

	ahb_agt_top 	ahb_agtth;
	apb_agt_top 	apb_agtth;
	scoreboard		sb_h;

	function new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		ahb_agtth=ahb_agt_top::type_id::create("ahb_agtth",this);
		apb_agtth=apb_agt_top::type_id::create("apb_agtth",this);
		sb_h   =scoreboard::type_id::create("sb_h",this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

endclass

