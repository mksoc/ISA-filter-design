module iir_filterTB ();
	localparam NB = 12;
	localparam WL = 24;

	wire clk_i;
   	wire rst_n_i;
   	wire [NB-1:0] dIn_i;
   	wire vIn_i;
	wire [2*WL-1:0] coeffs_fb_i;
   	wire [4*WL-1:0] coeffs_ff_i;
   	wire [NB-1:0] dOut_i;
   	wire vOut_i;
   	wire end_sim_i;

	// this initial block is needed only for the post-synthesis simulation,
	// not for the basic architercure or the post P&R simulation
	`ifdef SYN
		initial begin		
			// read saif file
			$read_lib_saif("../saif/NangateOpenCellLibrary.saif");
			$set_gate_level_monitoring("on");
			$set_toggle_region(UUT);
			$toggle_start;		
		end
	`endif

	clk_gen CG (
		.end_sim(end_sim_i),
        .clock(clk_i),  
        .reset_n(rst_n_i)
	);

	data_maker DM (
		.clock(clk_i),
        .reset_n(rst_n_i),
        .vOut(vIn_i),
        .dOut(dIn_i),  
		.coeffs_fb(coeffs_fb_i),
		.coeffs_ff(coeffs_ff_i),
        .end_sim(end_sim_i)
	);

	iir_filter UUT (
		.clk(clk_i),
        .rst_n(rst_n_i),
        .vIn(vIn_i),
        .dIn(dIn_i),   
		.coeffs_fb(coeffs_fb_i),
		.coeffs_ff(coeffs_ff_i),
        .dOut(dOut_i),
        .vOut(vOut_i)
	);

	data_sink DS (
		.clock(clk_i),
        .reset_n(rst_n_i), 
        .vIn(vOut_i),     
        .dIn(dOut_i)     	
	);

	always @(end_sim_i) begin
		if (end_sim_i) begin
			// this initial block is needed only for the post-synthesis simulation,
			// not for the basic architercure or the post P&R simulation
			`ifdef SYN
				$toggle_stop;
				$toggle_report("../saif/iir_filter_back.saif", 1.0e-9, "iir_filterTB.UUT");
			`endif
			`ifdef NO_GUI
				$finish(2);
			`else
				$stop(2);
			`endif
		end
	end

endmodule

		   