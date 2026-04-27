class apb_monitor extends uvm_monitor;

	`uvm_component_utils(apb_monitor)
	
	apb_config apb_cfg;
	virtual apb_if.apb_mon_mp vif;

	uvm_analysis_port #(apb_txn) ap;

	apb_txn xtn;

	function new(string name="apb_monitor",uvm_component parent);
		super.new(name,parent);
		ap=new("ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
			`uvm_fatal("APB_MONITOR","cannot get config class have you set it?");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=apb_cfg.vif;
		$display("from monitor %p",apb_cfg);
	endfunction

	task run_phase(uvm_phase phase);

		forever
			begin
				sample();
			end
	endtask
	
	task sample();							
	
	xtn = apb_txn :: type_id :: create("xtn");
	
	while(vif.apb_mon_cb.Penable === 1'b0) 
		@(vif.apb_mon_cb);

		xtn.Pwrite = vif.apb_mon_cb.Pwrite;
		xtn.Paddr = vif.apb_mon_cb.Paddr;
		xtn.Pselx = vif.apb_mon_cb.Pselx;
		xtn.Penable = vif.apb_mon_cb.Penable;
	
	if(vif.apb_mon_cb.Pwrite === 1'b1)
		xtn.Pwdata = vif.apb_mon_cb.Pwdata;
	else 
		xtn.Prdata = vif.apb_mon_cb.Prdata;
	
	ap.write(xtn);	
	
	`uvm_info("APB_MONITOR","this is apb monitor",UVM_LOW)
		xtn.print();


	repeat(1)
	@(vif.apb_mon_cb);

	endtask

endclass

