class ahb_monitor extends uvm_monitor;

	`uvm_component_utils(ahb_monitor)

	uvm_analysis_port #(ahb_txn) ap;

	ahb_txn xtn;
	
	ahb_config ahb_cfg;
	virtual ahb_if.ahb_mon_mp vif;

	function new(string name="ahb_monitor",uvm_component parent);
		super.new(name,parent);
		ap=new("ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
		`uvm_fatal("AHB_MONITOR","Cannot get config have you set it or not");
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=ahb_cfg.vif;
		$display("from monitor %p",ahb_cfg);
	endfunction

	task sample();
		xtn=ahb_txn::type_id::create("xtn");
	//	$display("**************************1");
		while(vif.ahb_mon_cb.Hreadyout!==1'b1)
			@(vif.ahb_mon_cb);

		while(vif.ahb_mon_cb.Htrans !== 2'b11 && vif.ahb_mon_cb.Htrans !== 2'b10)
			@(vif.ahb_mon_cb);
	//	$display("**************************2");
		xtn.Haddr=vif.ahb_mon_cb.Haddr;
		xtn.Hsize=vif.ahb_mon_cb.Hsize;
		xtn.Hburst=vif.ahb_mon_cb.Hburst;
		xtn.Htrans=vif.ahb_mon_cb.Htrans;
		xtn.Hwrite=vif.ahb_mon_cb.Hwrite;
		xtn.Hreadyin=vif.ahb_mon_cb.Hreadyin;
		@(vif.ahb_mon_cb);
	//	$display("**************************3");

		while(vif.ahb_mon_cb.Hreadyout!==1'b1)
			@(vif.ahb_mon_cb);
	//	$display("**************************3");
		if(xtn.Hwrite==1'b1)
			xtn.Hwdata=vif.ahb_mon_cb.Hwdata;
		else
			xtn.Hrdata=vif.ahb_mon_cb.Hrdata;

		`uvm_info("MONITOR","Printing from Monitor",UVM_LOW)
			xtn.print();
			ap.write(xtn);


	endtask

	task run_phase(uvm_phase phase);

		forever
			sample();
	endtask


endclass

