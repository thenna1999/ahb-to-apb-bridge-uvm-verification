class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	function new(string name="env_config");
		super.new(name);
	endfunction

	ahb_config ahb_cfg[];
	apb_config apb_cfg[];

	int no_magt;
	int no_sagt;

endclass

