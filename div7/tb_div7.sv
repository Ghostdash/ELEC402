module tb_div7();

logic clk, clk_out, reset;
div7 dut(.*);

logic negclk;

always begin
    clk = 1; #1;
    clk = 0; #1;
end

always begin
    negclk = 0; #1;
    negclk = 1; #1;
end


initial begin
    reset = 1;
    #5;
    reset = 0;
    #500;
    $stop;
end


endmodule