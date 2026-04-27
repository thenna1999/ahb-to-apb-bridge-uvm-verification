class apb_driver extends uvm_driver#(apb_txn);

	`uvm_component_utils(apb_driver)

	apb_config apb_cfg;

	virtual apb_if.apb_drv_mp vif;
	
	function new(string name="apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
			`uvm_fatal("apb_DRIVER","cannot get config class have you set it?");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=apb_cfg.vif;
		$display("from driver %p",apb_cfg);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		drive(req);

	endtask

	task drive (apb_txn xtn);
		
		xtn=apb_txn::type_id::create("xtn");
		
		wait(vif.apb_drv_cb.Pselx!==0)
		
		if(vif.apb_drv_cb.Pwrite==0)
			begin
				wait(vif.apb_drv_cb.Penable==1)
				@(vif.apb_drv_cb);

				vif.apb_drv_cb.Prdata<=$urandom;
			end

		repeat(2)
			@(vif.apb_drv_cb);

		`uvm_info("APB_DRIVER","Printing from the APB_Driver",UVM_LOW)
		xtn.print();

	endtask

				
endclass

