
module RCosc_core_divider( vdd, vss, clkout, clkin, rstb, div_ctrl);
	input vdd, vss;
	input clkin;
	output clkout;
	input rstb;
	input [4:0] div_ctrl;
	reg clkout_reg;
	reg [5:0] count;

    always @(negedge rstb or posedge clkin) begin
		if (rstb==0) begin
			count <= 0;
		    clkout_reg <=  0;
		end else if (count=={1'b0,div_ctrl}) begin
	 	   clkout_reg <= 0;
			count<=count+1;
		end else if (count=={div_ctrl,1'b0})begin
		    clkout_reg <= 1;
			count<= 1;
 	    end else count<=count+1;
	end
	
	assign clkout = clkout_reg;

endmodule

