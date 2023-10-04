module div7 (input logic clk, input logic reset, output logic clk_out);

logic [2:0] state, nextstate;
logic en1, en2, out1, out2;

tff1 t1 (clk,reset,en1,out1);
tff2 t2 (clk,reset,en2,out2); //neg edge

assign en1 = (state == 3'b000)? 1'b1 : 1'b0;
assign en2 = (state == 3'b100)? 1'b1 : 1'b0;

always_ff @(posedge clk)
    if (reset) state <= 3'b000;
    else state <= nextstate;

always_comb begin
    case(state)
        3'b000: nextstate = 3'b001;
        3'b001: nextstate = 3'b010;
        3'b010: nextstate = 3'b011;
        3'b011: nextstate = 3'b100;
        3'b100: nextstate = 3'b101;
        3'b101: nextstate = 3'b110;
        3'b110: nextstate = 3'b000;
        default: nextstate = 3'b000;
    endcase
end

assign clk_out = out1 ^ out2;

endmodule

module tff1 ( input logic clk, input logic rstn, input logic en, output logic out);
    always @(posedge clk) begin
        if (rstn) out <= 0;
        else 
            if (en) out <= ~out;
            else out <= out;
    end
endmodule

module tff2 ( input logic clk, input logic rstn, input logic en, output logic out);
    always @(negedge clk) begin
        if (rstn) out <= 0;
        else 
            if (en) out <= ~out;
            else out <= out;
    end
endmodule
