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
 *		Branch Predictor FSM
 */

module branch_predictor(
		clk,
		actual_branch_decision,
		branch_decode_sig,
		branch_mem_sig,
		in_addr,
		offset,
		branch_addr,
		prediction
	);

	/*
	 *	inputs
	 */
	input		clk;

	// outcome from last predicted instruction
	input		actual_branch_decision;

	// 1 if instruction currently in IF stage is a branch
	input		branch_decode_sig;

	// 1 if instruction currently in MA stage is a branch
	input		branch_mem_sig;

	// Pc of the instruction currently in IF stage
	input [31:0]	in_addr;

	// Imm offset of the branch instruction currently in IF stage
	input [31:0]	offset;

	// Global history shift register
	reg [5:0]	history_shift_reg;

	// Pattern history table
	reg [1:0]	pattern_history_table[0:63];

	/*
	 *	outputs
	 */
	// PC address of the current pc + branch offset
	output [31:0]	branch_addr;
	
	// 1 if we predict a branch for the instruction currently in IF stage
	output		prediction;

	reg		branch_mem_sig_reg;
	
	// state indexed by pattern_history_table
	reg [1:0]	s;

	/*
	 *	The `initial` statement below uses Yosys's support for nonzero
	 *	initial values:
	 *
	 *		https://github.com/YosysHQ/yosys/commit/0793f1b196df536975a044a4ce53025c81d00c7f
	 *
	 *	Rather than using this simulation construct (`initial`),
	 *	the design should instead use a reset signal going to
	 *	modules in the design and to thereby set the values.
	 */
	initial begin
		history_shift_reg = 6'b0;
		branch_mem_sig_reg = 1'b0;
	end

	// store if instruction currently in MA stage is a branch
	always @(negedge clk) begin
		branch_mem_sig_reg <= branch_mem_sig;
	end

	/*
	 *	Using this microarchitecture, branches can't occur consecutively
	 *	therefore can use branch_mem_sig as every branch is followed by
	 *	a bubble, so a 0 to 1 transition
	 */
	// update the FSM based on the outcome of the prediction of the branch currently in 
	always @(posedge clk) begin
		s <= pattern_history_table[history_shift_reg];
		if (branch_mem_sig_reg) begin
			s[1] <= (s[1]&s[0]) | (s[0]&actual_branch_decision) | (s[1]&actual_branch_decision);
			s[0] <= (s[1]&(!s[0])) | ((!s[0])&actual_branch_decision) | (s[1]&actual_branch_decision);
			pattern_history_table[history_shift_reg] <= s;
			history_shift_reg <= history_shift_reg << 1 + actual_branch_decision;
		end
	end

	// address of next instruction if branch taken
	assign branch_addr = in_addr + offset;
	// only predict a branch if in state 10 or 11 and the instruction in IF is a branch
	assign prediction = s[1] & branch_decode_sig;
endmodule
