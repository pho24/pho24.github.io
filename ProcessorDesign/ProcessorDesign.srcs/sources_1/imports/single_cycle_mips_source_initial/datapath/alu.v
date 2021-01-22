module alu (
        input  wire [2:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output        zero,
        output reg  [31:0] y
    );

    assign zero = (y == 0);

    always @ (op, a, b) begin
        case (op)
            //update
            3'b011: y = b << a; //sll
            3'b100: y = b >> a; //slr
            
            //initial design
            3'b000: y = a & b;
            3'b001: y = a | b;
            3'b010: y = a + b;
            3'b110: y = a - b;
            
            3'b111: y = (a < b) ? 1 : 0;
        endcase
    end

endmodule