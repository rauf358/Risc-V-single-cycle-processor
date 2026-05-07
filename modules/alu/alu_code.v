module alu(
input[4:0]a,b,
input[1:0]sel,
output reg [4:0]c
);

always @(*) begin
case(sel)
   2'b00: c=a+b;
   2'b01: c=a-b;
   2'b10: c=a*b;
   2'b11: c=a/b;
   default: c=5'b00000;
endcase
end
endmodule