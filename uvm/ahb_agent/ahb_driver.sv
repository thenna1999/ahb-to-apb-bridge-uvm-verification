class ahb_driver extends uvm_driver#(ahb_txn);

	`uvm_component_utils(ahb_driver)
	
	ahb_config ahb_cfg;
	
	virtual ahb_if.ahb_drv_mp vif;

	function new(string name="ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ahb_config)::get(this,"","ahb_config",ahb_cfg))
			`uvm_fatal("AHB_DRIVER","Cannot get config in ahb_driver have u set it or not? ");
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=ahb_cfg.vif;
		$display("from driver %p",ahb_cfg);
	endfunction

	task run_phase(uvm_phase phase);

		@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.Hresetn<=1'b0;
		@(vif.ahb_drv_cb);
		vif.ahb_drv_cb.Hresetn<=1'b1;

		forever
			begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done;
			end
	endtask

	task drive(ahb_txn xtn);

		while(vif.ahb_drv_cb.Hreadyout!==1'b1)
			@(vif.ahb_drv_cb);

		vif.ahb_drv_cb.Haddr<=xtn.Haddr;
		vif.ahb_drv_cb.Hburst<=xtn.Hburst;
		vif.ahb_drv_cb.Hsize<=xtn.Hsize;
		vif.ahb_drv_cb.Htrans<=xtn.Htrans;
		vif.ahb_drv_cb.Hwrite<=xtn.Hwrite;
		vif.ahb_drv_cb.Hreadyin<=1'b1;
			@(vif.ahb_drv_cb);

		while(vif.ahb_drv_cb.Hreadyout!==1'b1)
			@(vif.ahb_drv_cb);

		if(xtn.Hwrite==1'b1)
			vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
		else
			vif.ahb_drv_cb.Hwdata<=32'b0;

		`uvm_info("DRIVER","Printing from Driver",UVM_NONE);
		 xtn.print();


	endtask

endclass

