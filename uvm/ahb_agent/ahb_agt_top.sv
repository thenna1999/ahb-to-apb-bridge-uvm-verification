class ahb_agt_top extends uvm_env;

	`uvm_component_utils(ahb_agt_top)

	env_config e_cfg;
	ahb_agent ahb_agth[];

	function new(string name="ahb_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("ahb_agt_TOP","Cannot get config have you set it or not?");

		ahb_agth=new[e_cfg.no_magt];
		foreach(ahb_agth[i])
			begin
				uvm_config_db #(ahb_config)::set(this,$sformatf("ahb_agth[%0d]*",i),"ahb_config",e_cfg.ahb_cfg[i]);
				ahb_agth[i]=ahb_agent::type_id::create($sformatf("ahb_agth[%0d]",i),this);
			end
	endfunction

endclass

