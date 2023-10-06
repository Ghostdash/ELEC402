//name John Ye
//student number 43883347
`timescale 1ns/1ps
module tb_elevator();
    logic clk, reset;              
    logic [2:0] in_origin;
    logic [2:0] destination;
    logic emergency_stop;
    logic en;

    logic dooropen, doorclose, idle;

    elevator dut(.*);

    always begin
        clk = 1; #1;
        clk = 0; #1;
    end

    initial begin
        reset = 0;
        #2;
        reset = 1;

        en = 1;
        in_origin = 4;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        @(posedge clk);
	    @(posedge clk);
	    @(posedge clk);
	    @(posedge clk);
        destination = 0;
	    #50;
 
        en = 1;
        in_origin = 1;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        destination = 3;
	    #50;

        en = 1;
        in_origin = 0;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        destination = 2;
        emergency_stop = 1;
        #20;
        emergency_stop = 0;
        #50;

        en = 1;
        in_origin = 2;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        destination = 4;
        #50;

        en = 1;
        in_origin = 4;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        destination = 4;
	    #50;

        $stop;
    end
endmodule