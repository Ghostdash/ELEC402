//name John Ye
//student number 43883347
`define newrequest 3'd0
`define waitrequest 3'd1
`define ground 3'd2
`define two 3'd3
`define three 3'd4
`define four 3'd5
`define five 3'd6
`define stop 3'd7

`define RESET 3'd0
`define OPEND 3'd1
`define WAITO 3'd2
`define CLOSE 3'd3
`define WAITC 3'd4
`define READY 3'd5

module elevator (input logic clk, input logic reset,                 
    input logic [2:0] in_origin,
    input logic [2:0] destination,
    input logic emergency_stop,
    input logic en,

    output logic dooropen,
    output logic doorclose,
    output logic idle);

    logic [2:0] origin;
    logic [2:0] currentfloor;
    logic en_doorcontrol; 
    logic carrying_passenger;
    logic out;

    doorcontrol sys (clk, en_doorcontrol, reset, emergency_stop, dooropen, doorclose, out);
    logic [2:0] state;
    
    always_ff @(posedge clk) begin
        if (reset == 0) begin
            state <= `newrequest;
            currentfloor <= 0;
            carrying_passenger <= 0;
        end
        else begin case (state) 
            `newrequest: begin
                if (en) begin
                    state <= `waitrequest;
                    idle <= 0;
                    origin <= in_origin;
                end
                else begin
                    state <= `newrequest;
                    idle <= 1;
                end
            end
            `waitrequest: begin
                if (currentfloor != origin) begin
                    en_doorcontrol <= 0;
                    if (currentfloor == 0) state <= `ground;
                    else if(currentfloor == 1) state <= `two;
                    else if(currentfloor == 2) state <= `three;
                    else if(currentfloor == 3) state <= `four;
                    else if(currentfloor == 4) state <= `five;
                end
                else begin
                    state <= `stop;             
                    en_doorcontrol <= 1;
                end
            end
            `ground: begin
                if (!carrying_passenger) begin
                    if (currentfloor < origin) begin
                        state <= `two;
                        currentfloor <= 1;
                    end
                    else if (currentfloor > origin) begin
                        state <= `ground;
                        currentfloor <= 0;
                    end
                    else if (currentfloor == origin) begin
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end
                else begin
                    if (currentfloor < destination) begin
                        state <= `two;
                        currentfloor <= 1;
                    end
                    else if (currentfloor > destination) begin
                        state <= `ground;
                        currentfloor <= 0;     
                    end
                    else if (currentfloor == destination) begin      
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end       
            end
            `two: begin
                if (!carrying_passenger) begin
                    if (currentfloor < origin) begin
                        state <= `three;
                        currentfloor <= 2;                        
                    end
                    else if (currentfloor > origin) begin
                        state <= `ground;
                        currentfloor <= 0;                         
                    end
                    else if (currentfloor == origin) begin
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end
                else begin
                    if (currentfloor < destination) begin
                        state <= `three;
                        currentfloor <= 2;
                         
                    end
                    else if (currentfloor > destination) begin
                        state <= `ground;
                        currentfloor <= 0;                         
                    end
                    else if (currentfloor == destination)        
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end       
                end
            `three: begin
                if (!carrying_passenger) begin
                    if (currentfloor < origin) begin
                        state <= `four;
                        currentfloor <= 3;                         
                    end
                    else if (currentfloor > origin) begin
                        state <= `two;
                        currentfloor <= 1;                        
                    end
                    else if (currentfloor == origin) begin
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end
                else begin
                    if (currentfloor < destination) begin
                        state <= `four;
                        currentfloor <= 3;                        
                    end
                    else if (currentfloor > destination) begin
                        state <= `two;
                        currentfloor <= 1;                         
                    end
                    else if (currentfloor == destination) begin    
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end       
                end
            end
            `four: begin
                if (!carrying_passenger) begin
                    if (currentfloor < origin) begin
                        state <= `five;
                        currentfloor <= 4;                         
                    end
                    else if (currentfloor > origin) begin
                        state <= `three;
                        currentfloor <= 2;                         
                    end
                    else if (currentfloor == origin) begin
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end
                else begin
                    if (currentfloor < destination) begin
                        state <= `five;
                        currentfloor <= 4;                         
                    end
                    else if (currentfloor > destination) begin
                        state <= `three;
                        currentfloor <= 2;                        
                    end
                    else if (currentfloor == destination) begin      
                        state <= `stop;
                        en_doorcontrol <= 1; 
                    end
                end
            end
            `five: begin
                if (!carrying_passenger) begin
                    if (currentfloor < origin) begin
                        state <= `five;
                        currentfloor <= 4;                        
                    end
                    else if (currentfloor > origin) begin
                        state <= `four;
                        currentfloor <= 3;                         
                    end
                    else if (currentfloor == origin) begin
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end
                end
                else begin
                    if (currentfloor < destination) begin
                        state <= `five;
                        currentfloor <= 4;                        
                    end
                    else if (currentfloor > destination) begin
                        state <= `four;
                        currentfloor <= 3;                         
                    end
                    else if (currentfloor == destination) begin       
                        state <= `stop;
                        en_doorcontrol <= 1;
                    end       
                end
            end
            `stop: begin
                if (out) begin
                    carrying_passenger <= ~carrying_passenger;
                    en_doorcontrol <= 0;
                    if (currentfloor == destination) state <= `newrequest;
                    else if(currentfloor == 0) state <= `ground;
                    else if(currentfloor == 1) state <= `two;
                    else if(currentfloor == 2) state <= `three;
                    else if(currentfloor == 3) state <= `four;
                    else if(currentfloor == 4) state <= `five;
                end
            end
            default: state <= `newrequest;
        endcase
        end
    end
endmodule


module doorcontrol (input logic clk, 
input logic en,  
input logic reset,
input logic emergency_stop, 
output logic dooropen, 
output logic doorclose,
output logic out);
    logic [2:0] state;

    always_ff @(posedge clk) begin
        if (reset == 0 || en == 0) state <= `RESET;
        else if (emergency_stop == 1) state <= `OPEND;
        else if (en) begin 
            case(state)
                `RESET: state <= `OPEND;
                `OPEND: state <= `WAITO;
                `WAITO: state <= `CLOSE;
                `CLOSE: state <= `WAITC;
                `WAITC: state <= `READY;
                `READY: state <= `READY;
            default: state <= `RESET;
            endcase
        end
        else state <= `RESET;
    end

    always_comb begin
        case(state) 
            `RESET: begin
                dooropen = 0;
                doorclose = 1;
                out = 0;
            end
            `OPEND: begin
                dooropen = 1;
                doorclose = 0;
                out = 0;
            end
            `WAITO:begin
                dooropen = 1;
                doorclose = 0;
                out = 0;
            end
            `CLOSE: begin
                dooropen = 0;
                doorclose = 1;
                out = 0;
            end
            `WAITC: begin
                dooropen = 0;
                doorclose = 1;
                out = 0;
            end
            `READY: begin
                dooropen = 0;
                doorclose = 1;
                out = 1;
            end
            default: begin
                dooropen = 0;
                doorclose = 1;
                out = 0;                
            end
        endcase
    end
endmodule