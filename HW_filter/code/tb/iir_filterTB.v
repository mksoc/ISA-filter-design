module iir_filterTB ();
	localparam NB = 12;

	wire clk_i;
   	wire rst_n_i;
   	wire [NB-1:0] dIn_i;
   	wire vIn_i;
   	wire [3*NB-1:0] b_i;
	wire [2*NB-1:0] a_i;
   	wire [NB-1:0] dOut_i;
   	wire vOut_i;
   	wire end_sim_i;

	initial begin
		`ifdef SYN
			// read saif file
			$read_lib_saif("../saif/NangateOpenCellLibrary.saif");
			$set_gate_level_monitoring("on");
			$set_toggle_region(UUT);
			$toggle_start;
		`endif
	end

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
        .b(b_i),
        .a(a_i),
        .end_sim(end_sim_i)
	);

	iir_filter UUT (
		.clk(clk_i),
        .rst_n(rst_n_i),
        .vIn(vIn_i),
        .dIn(dIn_i),   
        .b(b_i),
        .a(a_i),
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
			`ifdef SYN
				$toggle_stop;
				$toggle_report("../saif/iir_filter_back.saif", 1.0e-9, "iir_filterTB.UUT");
			`endif
			$stop(2);
		end
	end

endmodule

		   