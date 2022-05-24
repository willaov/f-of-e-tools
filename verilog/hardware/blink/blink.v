`define	kFofE_HFOSC_CLOCK_DIVIDER_FOR_1Hz	24000000
`define kFofE_LFOSC_CLOCK_DIVIDER_FOR_1Hz	5000

module blink(led);
	output		led;

	wire		clk;
	reg		LEDstatus = 1;
	reg [31:0]	count = 0;

	/*
	 *	Creates a 48MHz clock signal from
	 *	internal oscillator of the iCE40
	 */
	// SB_HFOSC OSCInst0 (
	// 	.CLKHFPU(1'b1),
	// 	.CLKHFEN(1'b1),
	// 	.CLKHF(clk)
	// );

	/* Or using low power 10kHz oscillator */
	SB_LFOSC OSCInst1 (
		.CLKLFPU(1'b1),
		.CLKLFEN(1'b1),
		.CLKLF(clk)
	);

	/*
	 *	Blinks LED at approximately 1Hz. The constant kFofE_CLOCK_DIVIDER_FOR_1Hz
	 *	(defined above) is calibrated to yield a blink rate of about 1Hz.
	 */
	always @(posedge clk) begin
		if (count > `kFofE_LFOSC_CLOCK_DIVIDER_FOR_1Hz) begin
			LEDstatus <= !LEDstatus;
			count <= 0;
		end
		else begin
			count <= count + 1;
		end
	end

	/*
	 *	Assign output led to value in LEDstatus register
	 */
	assign	led = LEDstatus;
endmodule
