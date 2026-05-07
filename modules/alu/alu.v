module alu(
input[4:0]a,b,
input[2:0]sel,
output[4:0]c,
);

case(sel);
   2'b00: c=a+b;
   2'b00: c=a-b;
   2'b00: c=a*b;
   2'b00: c=a/b;
   default: c=5'b00000;
endcase
   
endmodule
