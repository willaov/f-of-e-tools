module clk_divider (in_clk, out_clk);
    output reg out_clk;
    input in_clk;
    always @(posedge in_clk) begin
            out_clk <= ~out_clk;
    end
endmodule
