`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   04:58:48 02/05/2020
// Design Name:   exe
// Module Name:   /home/rahul/pro/exe_test.v
// Project Name:  pro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: exe
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module exe_test;

	// Inputs
	
	reg clk;

	// Outputs
	wire [31:0] o_p;
	wire [31:0] instr;

	// Instantiate the Unit Under Test (UUT)
	exe uut (
		.clk(clk),
		.instr(instr),
		.o_p(o_p)
	);
	
always#5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		/*instr = 32'b00000000000000100011100000100000;
		#10;
		instr = 32'b00000000111000101111100000100010;
		#10;
		instr = 32'b00000000001000101111100000101010;
		#10;
		//instr = 32'b00000000111000101111100000100010;
		//#10;
		instr = 32'b10101100001000100000000000000000;
		#10;
		instr = 32'b10001100001111110000000000000000;
		#10;
	*/
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here

	end
      
endmodule

