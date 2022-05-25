/*
	Authored 2018-2019, Ryan Voo.

	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:

	*	Redistributions of source code must retain the above
		copyright notice, this list of conditions and the following
		disclaimer.

	*	Redistributions in binary form must reproduce the above
		copyright notice, this list of conditions and the following
		disclaimer in the documentation and/or other materials
		provided with the distribution.

	*	Neither the name of the author nor the names of its
		contributors may be used to endorse or promote products
		derived from this software without specific prior written
		permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/



/*
 *	Description:
 *
 *		This module implements an adder for use by the branch unit
 *		and program counter increment among other things.
 */



module adder(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	assign		out = input1 + input2;
endmodule

module hard_adder(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	// Things it needs
	wire clk;	// Doesn't actually need a clock as all unregistered
	assign clk = 1'b1;
	
	wire ce;
	assign ce = 1'b1;
	wire ahold;
	assign ahold = 1'b0;
	wire bhold;
	assign bhold = 1'b0;
	wire irsttop;
	assign irsttop = 1'b0;
	wire orsttop;
	assign orsttop = 1'b0;
	wire oholdtop;
	assign oholdtop = 1'b0;
	wire irstbot;
	assign irstbot = 1'b0;
	wire orstbot;
	assign orstbot = 1'b0;
	wire oholdbot;
	assign oholdbot = 1'b0;
	wire ci;
	assign ci = 1'b0;
	wire co;
	wire signextin;
	assign signextin = 1'b0;
	wire signextout;


	SB_MAC16 i_sbmac16(
		.CLK(clk),
		.CE(ce),
		.A(input1[31:16]),
		.AHOLD(ahold),
		.B(input1[15:0]),
		.BHOLD(bhold),
		.C(input2[31:16]),
		.CHOLD(),
		.D(input2[15:0]),
		.DHOLD(),
		.IRSTTOP(irsttop),
		.ORSTTOP(orsttop),
		.OLOADTOP(),
		.ADDSUBTOP(),
		.OHOLDTOP(oholdtop),
		.IRSTBOT(),
		.ORSTBOT(),
		.ADDSUBBOT(),
		.O(out),
		.CI(ci),
		.CO(co),
		.ACCUMCI(),
		.ACCUMCO(),
		.SIGNEXTIN(signextin),
		.SIGNEXTOUT(signextout)
	);

	defparam i_sbmac16.TOPADDSUB_UPPERINPUT = 1'b1;
	defparam i_sbmac16.BOTADDSUB_UPPERINPUT = 1'b1;
endmodule

module hard_subtractor(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	// Things it needs
	wire clk;	// Doesn't actually need a clock as all unregistered
	assign clk = 1'b1;
	
	wire ce;
	assign ce = 1'b0;
	wire ahold;
	assign ahold = 1'b0;
	wire bhold;
	assign bhold = 1'b0;
	wire irsttop;
	assign irsttop = 1'b0;
	wire orsttop;
	assign orsttop = 1'b0;
	wire oholdtop;
	assign oholdtop = 1'b0;
	wire irstbot;
	assign irstbot = 1'b0;
	wire orstbot;
	assign orstbot = 1'b0;
	wire oholdbot;
	assign oholdbot = 1'b0;
	wire ci;
	assign ci = 1'b0;
	wire co;
	wire signextin;
	assign signextin = 1'b0;
	wire signextout;


	SB_MAC16 i_sbmac16(
		.CLK(clk),
		.CE(ce),
		.A(input1[31:16]),
		.AHOLD(ahold),
		.B(input1[15:0]),
		.BHOLD(bhold),
		.C(input2[31:16]),
		.CHOLD(),
		.D(input2[15:0]),
		.DHOLD(),
		.IRSTTOP(irsttop),
		.ORSTTOP(orsttop),
		.OLOADTOP(),
		.ADDSUBTOP(1'b1),
		.OHOLDTOP(oholdtop),
		.IRSTBOT(),
		.ORSTBOT(),
		.ADDSUBBOT(1'b1),
		.O(out),
		.CI(ci),
		.CO(co),
		.ACCUMCI(),
		.ACCUMCO(),
		.SIGNEXTIN(signextin),
		.SIGNEXTOUT(signextout)
	);

	defparam i_sbmac16.TOPADDSUB_UPPERINPUT = 1'b1;
	defparam i_sbmac16.BOTADDSUB_UPPERINPUT = 1'b1;
endmodule