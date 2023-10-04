//name John Ye
//student number 43883347

`timescale 1 ps / 1 ps
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
        wait (dut.currentfloor == 4);
        destination = 0;
        wait (dut.currentfloor == 0);
        wait (dut.idle == 1);
 
        en = 1;
        in_origin = 1;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        wait (dut.currentfloor == 1);
        destination = 3;
        wait (dut.currentfloor == 3)
        wait (dut.idle == 1);

        en = 1;
        in_origin = 0;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        wait (dut.currentfloor == 0)
        destination = 2;
        wait (doorclose == 1)
        emergency_stop = 1;
        #20;
        emergency_stop = 0;
        wait (dut.idle == 1);

        en = 1;
        in_origin = 2;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        wait (dut.currentfloor == 2)
        destination = 4;
        wait (dut.idle == 1);

        #30;
        en = 1;
        in_origin = 4;
        @(posedge clk);
        @(posedge clk);
        en = 0;
        wait (dut.currentfloor == 4)
        destination = 4;
        wait (dut.idle == 1);

        $stop;
    end
endmodule