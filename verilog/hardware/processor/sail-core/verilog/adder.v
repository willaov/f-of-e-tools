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

	// hard_adder internal(
	// 	.input1(input1),
	// 	.input2(input2),
	// 	.out(out)
	// );

	// lookahead_32bit_adder internal(
	// 	.a(input1),
	// 	.b(input2),
	// 	.out(out)
	// );

	// full_32bit_adder internal(
	// 	.a(input1),
	// 	.b(input2),
	// 	.out(out)
	// );

	assign		out = input1 + input2;
endmodule

/* 	This carry_lookahead_adder_4_bit module is downloaded
*	from http://www.nandland.com/, and then modified for
*	our purposes
*/
module carry_lookahead_adder_4_bit 
  	(
		input [3:0]  a,
		input [3:0]  b,
		input cin,
		output [3:0] out,
		output cout,
   	);
     
	wire [4:0]    w_C;
	wire [3:0]    w_G, w_P, w_SUM;
	
	full_adder full_adder_bit_0
		( 
		.a(a[0]),
		.b(b[0]),
		.cin(w_C[0]),
		.out(w_SUM[0]),
		.cout()
		);
	
	full_adder full_adder_bit_1
		( 
		.a(a[1]),
		.b(b[1]),
		.cin(w_C[1]),
		.out(w_SUM[1]),
		.cout()
		);
	
	full_adder full_adder_bit_2
		( 
		.a(a[2]),
		.b(b[2]),
		.cin(w_C[2]),
		.out(w_SUM[2]),
		.cout()
		);
	
	full_adder full_adder_bit_3
		( 
		.a(a[3]),
		.b(b[3]),
		.cin(w_C[3]),
		.out(w_SUM[3]),
		.cout()
		);
	
	// Create the Generate (G) Terms:  Gi=Ai*Bi
	assign w_G[0] = a[0] & b[0];
	assign w_G[1] = a[1] & b[1];
	assign w_G[2] = a[2] & b[2];
	assign w_G[3] = a[3] & b[3];
	
	// Create the Propagate Terms: Pi=Ai+Bi
	assign w_P[0] = a[0] | b[0];
	assign w_P[1] = a[1] | b[1];
	assign w_P[2] = a[2] | b[2];
	assign w_P[3] = a[3] | b[3];
	
	// Create the Carry Terms:
	assign w_C[0] = cin;
	assign w_C[1] = w_G[0] | (w_P[0] & w_C[0]);
	assign w_C[2] = w_G[1] | (w_P[1] & w_C[1]);
	assign w_C[3] = w_G[2] | (w_P[2] & w_C[2]);
	assign w_C[4] = w_G[3] | (w_P[3] & w_C[3]);
	
	assign out = w_SUM;
	assign cout = w_C[4];
	
endmodule

module lookahead_32bit_adder(a, b, cin, out, cout);
	input [31:0] 	a;
	input [31:0]	b;
	input cin;
	output [31:0]	out;
	output cout;

	wire c1, c2, c3, c4, c5, c6, c7;

	carry_lookahead_adder_4_bit add1(
		.a(a[3:0]),
		.b(b[3:0]),
		.out(out[3:0]),
		.cin(cin),
		.cout(c1)
	);
	carry_lookahead_adder_4_bit add2(
		.a(a[7:4]),
		.b(b[7:4]),
		.out(out[7:4]),
		.cin(c1),
		.cout(c2)
	);
	carry_lookahead_adder_4_bit add3(
		.a(a[11:8]),
		.b(b[11:8]),
		.out(out[11:8]),
		.cin(c2),
		.cout(c3)
	);
	carry_lookahead_adder_4_bit add4(
		.a(a[15:12]),
		.b(b[15:12]),
		.out(out[15:12]),
		.cin(c3),
		.cout(c4)
	);
	carry_lookahead_adder_4_bit add5(
		.a(a[19:16]),
		.b(b[19:16]),
		.out(out[19:16]),
		.cin(c4),
		.cout(c5)
	);
	carry_lookahead_adder_4_bit add6(
		.a(a[23:20]),
		.b(b[23:20]),
		.out(out[23:20]),
		.cin(c5),
		.cout(c6)
	);
	carry_lookahead_adder_4_bit add7(
		.a(a[27:24]),
		.b(b[27:24]),
		.out(out[27:24]),
		.cin(c6),
		.cout(c7)
	);
	carry_lookahead_adder_4_bit add8(
		.a(a[31:28]),
		.b(b[31:28]),
		.out(out[31:28]),
		.cin(c7),
		.cout(cout)
	);
endmodule

module full_32bit_adder(a, b, cin, out, cout);
	input [31:0] 	a;
	input [31:0]	b;
	input cin;
	output [31:0]	out;
	output cout;

	wire c1, c2, c3, c4, c5, c6, c7;

	full_4bit_adder add1(
		.a(a[3:0]),
		.b(b[3:0]),
		.out(out[3:0]),
		.cin(cin),
		.cout(c1)
	);
	full_4bit_adder add2(
		.a(a[7:4]),
		.b(b[7:4]),
		.out(out[7:4]),
		.cin(c1),
		.cout(c2)
	);
	full_4bit_adder add3(
		.a(a[11:8]),
		.b(b[11:8]),
		.out(out[11:8]),
		.cin(c2),
		.cout(c3)
	);
	full_4bit_adder add4(
		.a(a[15:12]),
		.b(b[15:12]),
		.out(out[15:12]),
		.cin(c3),
		.cout(c4)
	);
	full_4bit_adder add5(
		.a(a[19:16]),
		.b(b[19:16]),
		.out(out[19:16]),
		.cin(c4),
		.cout(c5)
	);
	full_4bit_adder add6(
		.a(a[23:20]),
		.b(b[23:20]),
		.out(out[23:20]),
		.cin(c5),
		.cout(c6)
	);
	full_4bit_adder add7(
		.a(a[27:24]),
		.b(b[27:24]),
		.out(out[27:24]),
		.cin(c6),
		.cout(c7)
	);
	full_4bit_adder add8(
		.a(a[31:28]),
		.b(b[31:28]),
		.out(out[31:28]),
		.cin(c7),
		.cout(cout)
	);
endmodule

module full_4bit_adder(a, b, cin, out, cout);
	input [3:0]	a;
	input [3:0]	b;
	input cin;
	output [3:0]	out;
	output cout;

	wire c1, c2, c3;

	full_adder add1(
		.a(a[0]),
		.b(b[0]),
		.out(out[0]),
		.cin(cin),
		.cout(c1)
	);

	full_adder add2(
		.a(a[1]),
		.b(b[1]),
		.out(out[1]),
		.cin(c1),
		.cout(c2)
	);

	full_adder add3(
		.a(a[2]),
		.b(b[2]),
		.out(out[2]),
		.cin(c2),
		.cout(c3)
	);

	full_adder add4(
		.a(a[3]),
		.b(b[3]),
		.out(out[3]),
		.cin(c3),
		.cout(cout)
	);
endmodule

module full_adder(a, b, cin, out, cout);
	input a;
	input b;
	input cin;
	output out;
	output cout;

	wire axb;
	wire anb;
	wire axbncin;

	assign axb = a ^ b;
	assign anb = a & b;
	assign axbncin = axb & cin;
	assign out = axb ^ cin;
	assign cout = anb | axbncin;
endmodule

module hard_adder(input1, input2, out);
	input [31:0]	input1;
	input [31:0]	input2;
	output [31:0]	out;

	// Things it needs
	reg clk = 1'b1;	// Doesn't actually need a clock as all unregistered
	reg ce = 1'b0;
	reg irsttop = 1'b0;
	reg irstbot = 1'b0;
	reg osrttop = 1'b0;
	reg orstbot = 1'b0;
	reg ahold = 1'b0;
	reg bhold = 1'b0;
	reg chold = 1'b0;
	reg dhold = 1'b0;
	reg oholdtop = 1'b0;
	reg oholdbot = 1'b0;
	reg oloadtop = 1'b0;
	reg oloadbot = 1'b0;
	reg addsubtop = 1'b0;
	reg addsubbot = 1'b0;
	reg ci = 1'b0;
	// reg co = 1'b0;
	reg signextin = 1'b0;
	// reg signextout = 1'b0;


	SB_MAC16 i_sbmac16(
		.A(input1[31:16]),
		.B(input1[15:0]),
		.C(input2[31:16]),
		.D(input2[15:0]),
		.O(out),
		.CLK(clk),
		.CE(ce),
		.IRSTTOP(irsttop),
		.IRSTBOT(irstbot),
		.ORSTTOP(osrttop),
		.ORSTBOT(orstbot),
		.AHOLD(ahold),
		.BHOLD(bhold),
		.CHOLD(chold),
		.DHOLD(dhold),
		.OHOLDTOP(oholdtop),
		.OHOLDBOT(oholdbot),
		.OLOADTOP(oloadtop),
		.OLOADBOT(oloadbot),
		.ADDSUBTOP(addsubtop),
		.ADDSUBBOT(addsubbot),
		.CI(ci),
		.SIGNEXTIN(signextin)
	);

	defparam i_sbmac16.NEG_TRIGGER = 1'b0;
	defparam i_sbmac16.C_REG = 1'b0;
	defparam i_sbmac16.A_REG = 1'b0;
	defparam i_sbmac16.B_REG = 1'b0;
	defparam i_sbmac16.D_REG = 1'b0;

	defparam i_sbmac16.TOP_8x8_MULT_REG = 1'b0;
	defparam i_sbmac16.BOT_8x8_MULT_REG = 1'b0;
	defparam i_sbmac16.PIPELINE_16x16_MULT_REG1 = 1'b0;
	defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b0;

	defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b00;
	defparam i_sbmac16.TOPADDSUB_LOWERINPUT = 2'b00;
	defparam i_sbmac16.TOPADDSUB_UPPERINPUT = 1'b1;
	defparam i_sbmac16.TOPADDSUB_CARRYSELECT = 2'b11;
	defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b00;
	defparam i_sbmac16.BOTADDSUB_LOWERINPUT = 2'b00;
	defparam i_sbmac16.BOTADDSUB_UPPERINPUT = 1'b1;
	defparam i_sbmac16.BOTADDSUB_CARRYSELECT = 2'b00;
	defparam i_sbmac16.MODE_8x8 = 1'b0;
	defparam i_sbmac16.A_SIGNED = 1'b0;
	defparam i_sbmac16.B_SIGNED = 1'b0;
endmodule
