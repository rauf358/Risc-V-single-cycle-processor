module program_counter(
  input [63:0] PC_in,
  input clk,
  input reset,
  input stall, 
  output reg [63:0] PC_out);
  
  always @(posedge clk or posedge reset)
    begin
      if (reset==1'b1)
        begin        
          PC_out = 64'd0;
        end
      else if (stall == 1'b0) 
        begin 
          PC_out = PC_in;
        end
    end
endmodule


module instruction_memory(
  input [63:0] inst_address,
  output reg [31:0] instruction);
  reg [7:0] inst_mem[87:0];
  
  initial
    begin
      {inst_mem[3], inst_mem[2], inst_mem[1], inst_mem[0]} = 32'h00000913;//1
      {inst_mem[7], inst_mem[6], inst_mem[5], inst_mem[4]} = 32'h00000433;//2
      {inst_mem[11], inst_mem[10], inst_mem[9], inst_mem[8]} = 32'h04b40863;//3
      {inst_mem[15], inst_mem[14], inst_mem[13], inst_mem[12]} = 32'h00800eb3;//4
      {inst_mem[19], inst_mem[18], inst_mem[17], inst_mem[16]} = 32'h000409b3;//5	
      {inst_mem[23], inst_mem[22], inst_mem[21], inst_mem[20]} = 32'h013989b3;//6
      {inst_mem[27], inst_mem[26], inst_mem[25], inst_mem[24]} = 32'h013989b3;//7
      {inst_mem[31], inst_mem[30], inst_mem[29], inst_mem[28]} = 32'h013989b3;//8
      {inst_mem[35], inst_mem[34], inst_mem[33], inst_mem[32]} = 32'h02be8663;//9
      {inst_mem[39], inst_mem[38], inst_mem[37], inst_mem[36]} = 32'h001e8e93;//10	
      {inst_mem[43], inst_mem[42], inst_mem[41], inst_mem[40]} = 32'h00898993;//11
      {inst_mem[47], inst_mem[46], inst_mem[45], inst_mem[44]} = 32'h00093d03;//12
      {inst_mem[51], inst_mem[50], inst_mem[49], inst_mem[48]} = 32'h0009bd83;//13
      {inst_mem[55], inst_mem[54], inst_mem[53], inst_mem[52]} = 32'h01bd4463;//14
      {inst_mem[59], inst_mem[58], inst_mem[57], inst_mem[56]} = 32'hfe0004e3;//15
      {inst_mem[63], inst_mem[62], inst_mem[61], inst_mem[60]} = 32'h01a002b3;//16
      {inst_mem[67], inst_mem[66], inst_mem[65], inst_mem[64]} = 32'h01b93023;//17
      {inst_mem[71], inst_mem[70], inst_mem[69], inst_mem[68]} = 32'h0059b023;//18
      {inst_mem[75], inst_mem[74], inst_mem[73], inst_mem[72]} = 32'hfc000ce3;//19
      {inst_mem[79], inst_mem[78], inst_mem[77], inst_mem[76]} = 32'h00140413;//20
      {inst_mem[83], inst_mem[82], inst_mem[81], inst_mem[80]} = 32'h00890913;//21
      {inst_mem[87], inst_mem[86], inst_mem[85], inst_mem[84]} = 32'hfa000ae3;//22
    end
  always @ (inst_address)
    begin
      instruction[7:0] = inst_mem[inst_address+0];
      instruction[15:8] = inst_mem[inst_address+1];
      instruction[23:16] = inst_mem[inst_address+2];
      instruction[31:24] = inst_mem[inst_address+3];
    end
endmodule

module registerFile(
  input clk,
  input reset,
  input [4:0] rs1,
  input [4:0] rs2,
  input [4:0] rd,
  input [63:0] writedata,
  input reg_write,
  output reg [63:0] readdata1,
  output reg[63:0] readdata2,
  output [63:0] r8,
  output [63:0] r19,
  output [63:0] r20,
  output [63:0] r21,
  output [63:0] r22
);
  integer i;
  reg [63:0] registers [31:0];
  initial
    begin
      registers[0] = 64'd0;
      registers[1] = 64'd0;
      registers[2] = 64'd0;
      registers[3] = 64'd0;
      registers[4] = 64'd0;
      registers[5] = 64'd0;
      registers[6] = 64'd0;
      registers[7] = 64'd0;
      registers[8] = 64'd0;
      registers[9] = 64'd0;
      registers[10] = 64'd0;
      registers[11] = 64'd8;
      registers[12] = 64'd0;
      registers[13] = 64'd0;
      registers[14] = 64'd0;
      registers[15] = 64'd0;
      registers[16] = 64'd0;
      registers[17] = 64'd0;
      registers[18] = 64'd0;
      registers[19] = 64'd0;
      registers[20] = 64'd0;
      registers[21] = 64'd0;
      registers[22] = 64'd0;
      registers[23] = 64'd0;
      registers[24] = 64'd0;
      registers[25] = 64'd0;
      registers[26] = 64'd0;
      registers[27] = 64'd0;
      registers[28] = 64'd0;
      registers[29] = 64'd0;
      registers[30] = 64'd0;
      registers[31] = 64'd0;
    end
  assign r8 = registers[8];
  assign r19 = registers[19];
  assign r20 = registers[20];
  assign r21 = registers[26];
  assign r22 = registers[27];
 
  always @ (*)
    begin
      if (reset == 1'b1)
        begin
          readdata1 = 64'd0;
          readdata2 = 64'd0;
        end
      else
        begin
          readdata1 = registers[rs1];
          readdata2 = registers[rs2];
        end
    end
  always@(negedge clk)
    begin
      if (reg_write == 1)
        registers[rd] = writedata;
    end
endmodule

module CU(
  input [6:0] opcode,
  input stall, 
  
  output reg branch,
  output reg memread,
  output reg memtoreg,
  output reg memwrite,
  output reg aluSrc,
  output reg regwrite,
  output reg [1:0] Aluop);
  
  always @(*)
    begin
      
      if (opcode == 7'b0000011)
        begin
          aluSrc = 1'b1;
          memtoreg = 1'b1;
          regwrite = 1'b1;
          memread = 1'b1;
          memwrite = 1'b0;
          branch = 1'b0;
          Aluop =2'b00;
        end
      
      else if (opcode == 7'b0100011)
        begin
          aluSrc = 1'b1;
          memtoreg = 1'bx;
          regwrite = 1'b0;
          memread = 1'b0;
          memwrite = 1'b1;
          branch = 1'b0;
          Aluop =2'b00;
        end
      
      else if (opcode == 7'b0110011)
        begin
          aluSrc = 1'b0;
          memtoreg = 1'b0;
          regwrite = 1'b1;
          memread = 1'b0;
          memwrite = 1'b0;
          branch = 1'b0;
          Aluop =2'b10;
        end
      
      else if (opcode == 7'b1100011)
        begin
          aluSrc = 1'b0;
          memtoreg = 1'bx;
          regwrite = 1'b0;
          memread = 1'b0;
          memwrite = 1'b0;
          branch = 1'b1;
          Aluop =2'b01;
        end
      else if (opcode == 7'b0010011)
        begin
          aluSrc = 1'b1;
          memtoreg = 1'b0;
          regwrite = 1'b1;
          memread = 1'b0;
          memwrite = 1'b0;
          branch = 1'b0;
          Aluop =2'b00;
        end
      
      else //default case
        begin
          aluSrc = 1'b0;
          memtoreg = 1'b0;
          regwrite = 1'b0;
          memread = 1'b0;
          memwrite = 1'b0;
          branch = 1'b0;
          Aluop =2'b00;
        end
      
      if (stall == 1'b1)
        begin
          aluSrc = 1'b0;
          memtoreg = 1'b0;
          regwrite = 1'b0;
          memread = 1'b0;
          memwrite = 1'b0;
          branch = 1'b0;
          Aluop =2'b00;
        end
 
    end
endmodule

module data_memory
  (input [63:0] write_data,
   input [63:0] address,
   input memorywrite, clk,memoryread,
   output reg [63:0] read_data,
  output [63:0] element1,
  output [63:0] element2,
  output [63:0] element3,
  output [63:0] element4,
  output [63:0] element5,
  output [63:0] element6,
  output [63:0] element7,
  output [63:0] element8);
  
  reg [7:0] mem [63:0]; //memory array
  integer i;
  initial
    begin
      for (i=0; i<64; i=i+1)
        begin
          mem[i] = 0;
    
        end
      mem[0] = 8'd1;
      mem[8] = 8'd2;
      mem[16] = 8'd3;
      mem[24] = 8'd4;
      mem[32] = 8'd5;
      mem[40] = 8'd6;
      mem[48] = 8'd7;
      mem[56] = 8'd8;
    end
  
  
  assign element1 = {mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]};
  assign element2 = {mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8]};
  assign element3 = {mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16]};
  assign element4 = {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24]};
  assign element5 = {mem[39],mem[38],mem[37],mem[36],mem[35],mem[34],mem[33],mem[32]};
  assign element6 = {mem[47],mem[46],mem[45],mem[44],mem[43],mem[42],mem[41],mem[40]};
  assign element7 = {mem[55],mem[54],mem[53],mem[52],mem[51],mem[50],mem[49],mem[48]};
  assign element8 = {mem[63],mem[62],mem[61],mem[60],mem[59],mem[58],mem[57],mem[56]};
  
  always @ (*)
    begin
      if (memoryread)
        begin
          read_data[7:0] = mem[address+0];
          read_data[15:8] = mem[address+1];
          read_data[23:16] = mem[address+2];
          read_data[31:24] = mem[address+3];
          read_data[39:32] = mem[address+4];
          read_data[47:40] = mem[address+5];
          read_data[55:48] = mem[address+6];
          read_data[63:56] = mem[address+7];
        end
    end
  always @(posedge clk)
    begin
      if (memorywrite)
        begin
          mem[address] = write_data[7:0];
          mem[address+1] = write_data[15:8];
          mem[address+2] = write_data[23:16];
          mem[address+3] = write_data[31:24];
          mem[address+4] = write_data[39:32];
          mem[address+5] = write_data[47:40];
          mem[address+6] = write_data[55:48];
          mem[address+7] = write_data[63:56];
        end
    end
endmodule
module data_extractor
 (
    input [31:0] instruction,
    output reg [63:0] imm_data
  );
  
  always @(*)
    begin
      case (instruction[6:5])
       2'b00:
          begin
            imm_data[11:0] = instruction[31:20];
          end
        2'b01:
          begin
            imm_data[11:0] = {instruction[31:25], instruction[11:7]};
          end
        2'b11:
          begin
            imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
          end
      endcase
      imm_data = {{52{imm_data[11]}},{imm_data[11:0]}};
    end  
  
endmodule

module twox1Mux(
  input [63:0] A,B,
  input SEL,
  output reg[63:0] Y);
  always @ (A or B or SEL)
    begin 
      if (SEL==0)
        Y=A;
      else
        Y=B;
    end
endmodule

module ThreebyOneMux
  (
    input[63:0] a,
    input[63:0] b,
    input[63:0] c,
    input [1:0] sel,
    output reg [63:0] out
  );
  always @(*)
    begin
      case(sel[1:0])
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
      endcase
    end
endmodule

module adder(
  input [63:0] p,
  input [63:0] q,
  output [63:0] out);
  
  assign out = p+q;
endmodule

module IDEX(
  input clk,reset,
  input [3:0] funct4_in,//funct4 of instruction from instruction memory
  input [63:0] A_in,//adder input, ouput of IFID carried forward
  input [63:0] readdata1_in, //from regwrite
  input [63:0] readdata2_in,//from regwrite
  input [63:0] imm_data_in,//from data extractor
  input [4:0] rs1_in,//from instruction parser
  input [4:0] rs2_in, //from instruction parser
  input [4:0] rd_in, //from instruction parser
  input branch_in,memread_in,memtoreg_in,memwrite_in,aluSrc_in,regwrite_in, //from control unit
  input [1:0] Aluop_in,
  input flush, 
  output reg [63:0] a,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [4:0] rd,
  output reg [63:0] imm_data,
  output reg [63:0] readdata1, //2bit mux
  output reg [63:0] readdata2, //2bit mux
  output reg [3:0] funct4_out,
  output reg Branch,Memread,Memtoreg, Memwrite, Regwrite,Alusrc, 
  output reg [1:0] aluop
);
  
  always @ (posedge clk)
    begin
      if (reset == 1'b1 || flush == 1'b1)
        begin
          a = 64'b0;
          rs1 = 5'b0;
          rs2 = 5'b0;
          rd = 5'b0;
          imm_data = 64'b0;
          readdata1 = 64'b0;
          readdata2 = 64'b0;
          funct4_out = 4'b0;
          Branch = 1'b0;
          Memread = 1'b0;
          Memtoreg =1'b0;
          Memwrite = 1'b0;
          Regwrite = 1'b0;
          Alusrc = 1'b0;
          aluop = 2'b0;
        end
      else
        begin
          a = A_in;
          rs1 = rs1_in;
          rs2 = rs2_in;
          rd = rd_in;
          imm_data = imm_data_in;
          readdata1 = readdata1_in;
          readdata2 = readdata2_in;
          funct4_out = funct4_in; //when connecting in top module Funct4 is wire containing this section of 31 bit instruction {instruction[30],instruction[14:12]}
          Branch = branch_in;
          Memread = memread_in;
          Memtoreg = memtoreg_in;
          Memwrite = memwrite_in;
          Regwrite = regwrite_in;
          Alusrc = aluSrc_in;
          aluop = Aluop_in;
          
        end
    end
endmodule

module IFID
  (
    input clk,
    input reset,
    input [31:0] instruction,
    input [63:0] A, //a
    input flush, 
    input IFIDWrite, 
    output reg [31:0] inst,//instruction out,
    output reg [63:0] a_out
  );
  always @(posedge clk)
    begin
      if (reset == 1'b1 || flush == 1'b1)
        begin
          inst = 32'b0;
          a_out = 64'b0;
        end
      else if (IFIDWrite == 1'b0)
        begin
          inst = instruction;
          a_out = A;
        end
    end
endmodule

module MEMWB(
  input clk,reset,
  input [63:0] read_data_in,
  input [63:0] result_alu_in, //2 bit 2by1 mux input b
  input [4:0]Rd_in, //EX MEM output
  input memtoreg_in, regwrite_in, //ex mem output as mem wb inputs
  output reg [63:0] readdata, //1bit
  output reg [63:0] result_alu_out,//1bit
  output reg [4:0] rd,
  output reg Memtoreg, Regwrite
);
  
  always @(posedge clk)
    begin
      if (reset == 1'b1)
        begin
          readdata = 63'b0;
          result_alu_out = 63'b0;
          rd = 5'b0;
          Memtoreg = 1'b0;
          Regwrite = 1'b0;
          
        end
      else
        begin
         readdata = read_data_in;
          result_alu_out = result_alu_in;
          rd = Rd_in;
          Memtoreg = memtoreg_in;
          Regwrite = regwrite_in;
        end
    end
endmodule

          
module EXMEM(
  input clk,reset,
  input [63:0] Adder_out, //adder output
  input [63:0] Result_in_alu,//64bit alu output
  input Zero_in,//64bit alu output
  input [63:0] writedata_in, //2 bit mux2by1 output
  input [4:0] Rd_in, //IDEX output
  input branch_in,memread_in,memtoreg_in,memwrite_in,regwrite_in, //IDEXX outputs
  input flush, 
  input addermuxselect_in,
  output reg [63:0] Adderout,
  output reg zero,
  output reg [63:0] result_out_alu,
  output reg [63:0] writedata_out,
  output reg [4:0]rd,
  output reg Branch,Memread,Memtoreg, Memwrite, Regwrite,
  output reg addermuxselect);
  
  always @ (posedge clk)
    begin
      if (reset == 1'b1 || flush == 1'b1)
        begin
          Adderout = 64'b0;
          zero = 1'b0;
          result_out_alu = 63'b0;
          writedata_out = 64'b0;
          rd = 5'b0;
          Branch = 1'b0;
          Memread = 1'b0;
          Memtoreg =1'b0;
          Memwrite = 1'b0;
          Regwrite = 1'b0;
          addermuxselect = 1'b0;
        end
      else
        begin
          Adderout = Adder_out;
          zero = Zero_in;
          result_out_alu = Result_in_alu;
          writedata_out = writedata_in;
          rd = Rd_in;
          Branch = branch_in;
          Memread = memread_in;
          Memtoreg = memtoreg_in;
          Memwrite = memwrite_in;
          Regwrite = regwrite_in;
          addermuxselect = addermuxselect_in;
        end
    end
endmodule

module hazard_detection_unit
  (
    input Memread,
    input [31:0] inst,
    input [4:0] Rd,
    output reg stall
  );
  
  initial
    begin
      stall = 1'b0;
    end
  
  always @(*)
    begin
      if (Memread == 1'b1 && ((Rd == inst[19:15]) || (Rd == inst[24:20])))
        stall = 1'b1;
      else
        stall = 1'b0;
    end
endmodule

module data_extractor
 (
    input [31:0] instruction,
    output reg [63:0] imm_data
  );
  
  always @(*)
    begin
      case (instruction[6:5])
       2'b00:
          begin
            imm_data[11:0] = instruction[31:20];
          end
        2'b01:
          begin
            imm_data[11:0] = {instruction[31:25], instruction[11:7]};
          end
        2'b11:
          begin
            imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
          end
      endcase
      imm_data = {{52{imm_data[11]}},{imm_data[11:0]}};
    end  
  
endmodule

module Parser(
  input [31:0] instruction,
  output [6:0] opcode,
  output [4:0] rd,
  output [2:0] funct3,
  output [4:0] rs1,
  output [4:0] rs2,
  output [6:0] funct7
  );
  
  assign opcode = instruction[6:0];
  assign rd = instruction[11:7];
  assign funct3 = instruction[14:12];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign funct7 = instruction[31:25];
  
endmodule

module pipeline_flush
  (
    input branch,
    output reg flush
  );
  
  initial
    begin
      flush = 1'b0;
    end
  
  always @(*)
    begin
      if (branch == 1'b1)
        flush = 1'b1;
      else
        flush = 1'b0;
    end
  
endmodule

module branching_unit
  (
   input [2:0] funct3,
    input [63:0] readData1,
    input [63:0] b,
   output reg addermuxselect
  );
  
  initial
    begin
      addermuxselect = 1'b0;
    end
  
  always @(*)
	begin
      case (funct3)
        3'b000:
          begin
            if (readData1 == b)
              addermuxselect = 1'b1;
            else
              addermuxselect = 1'b0;
            end
         3'b100:
    		begin
              if (readData1 < b)
              addermuxselect = 1'b1;
            else
              addermuxselect = 1'b0;
            end
        3'b101:
          begin
            if (readData1 > b)
          	addermuxselect = 1'b1;
           else
              addermuxselect = 1'b0;
          end    
      endcase
     end
endmodule

module alu_control(
  input [1:0] Aluop,
  input [3:0] funct,
  output reg [3:0] operation);
  
  always @ (*)
    begin
      if (Aluop==2'b01)
        begin
          operation = 4'b0110;
        end
      if (Aluop==2'b00)
        begin
          operation = 4'b0010;
        end
      if (Aluop==2'b10)
        begin
          if (funct == 4'b0000)
            begin
              operation = 4'b0010;
            end
          if (funct == 4'b0111)
            begin
              operation = 4'b0000;
            end
          if (funct == 4'b1000)
            begin
              operation = 4'b0110;
            end
          if (funct == 4'b0110)
            begin
              operation = 4'b0001;
            end
        end
    end
endmodule

module Alu64
  (
    input [63:0] a,b,
    input [3:0] ALuop,
    output reg [63:0] Result,
    output reg zero
    
  );
  
  always @(*)
    begin
      case (ALuop)
        4'b0000: Result = a & b;
        4'b0001: Result = a | b;
        4'b0010: Result = a + b;
        4'b0110: Result = a - b;
        4'b1100: Result = ~(a | b); //nor
      endcase
      if (Result == 0)
        zero = 1;
      else
        zero = 0;
    end
endmodule

module ForwardingUnit
  (
    input [4:0] RS_1, //ID/EX.RegisterRs1
    input [4:0] RS_2, //ID/EX.RegisterRs2
    input [4:0] rdMem, //EX/MEM.Register Rd
    input [4:0] rdWb, //MEM/WB.RegisterRd
    
    input regWrite_Wb, //MEM/WB.RegWrite
    input regWrite_Mem, // EX/MEM.RegWrite
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
 );
  
  always @(*)
    begin
    	if ( (rdMem == RS_1) & (regWrite_Mem != 0 & rdMem !=0))
          begin
          	Forward_A = 2'b10;
          end
      	else
          begin 
            // Not condition for MEM hazard 
            if ((rdWb== RS_1) & (regWrite_Wb != 0 & rdWb != 0) & ~((rdMem == RS_1) &(regWrite_Mem != 0 & rdMem !=0)  )  )
              begin
                Forward_A = 2'b01;
              end
            else
              begin
                Forward_A = 2'b00;
              end
          end
      
        if ( (rdMem == RS_2) & (regWrite_Mem != 0 & rdMem !=0) )
          begin
            Forward_B = 2'b10;
          end
        else
          begin
            // Not condition for MEM Hazard 
            if ( (rdWb == RS_2) & (regWrite_Wb != 0 & rdWb != 0) &  ~((regWrite_Mem != 0 & rdMem !=0 ) & (rdMem == RS_2) ) )
              begin
                Forward_B = 2'b01;
              end
            else
              begin
                Forward_B = 2'b00;
              end
          end
    end
endmodule


module RISC_V_Processor(
  input clk,
  input reset,
  input wire[63:0] element1,
  input wire[63:0] element2,
  input wire[63:0] element3,
  input wire[63:0] element4,
  input wire[63:0] element5,
  input wire[63:0] element6,
  input wire[63:0] element7,
  input wire[63:0] element8,
  input stall, flush);
  
  // CU wires
  wire branch;
  wire memread;
  wire memtoreg;
  wire memwrite;
  wire ALUsrc;
  wire regwrite;
  wire [1:0] ALUop;
  
  //regfile
  wire regwrite_memwb_out;
  wire [63:0] readdata1, readdata2;
  wire [63:0] r8, r19, r20, r21, r22;
  wire [63:0] write_data;
  
   //PC wires
  wire [63:0] pc_in;
  wire [63:0] pc_out;
  
  // adders
  wire [63:0] adderout1;
  wire [63:0] adderout2;
  
  // inst mem wire
  wire [31:0] instruction;
  wire[31:0] inst_ifid_out;
  
  //Parser
  wire [6:0] opcode;
  wire [4:0] rd, rs1, rs2;
  wire [2:0] funct3;
  wire [6:0] funct7;
  
  
  // Immediate Data Extractor
  wire [63:0] imm_data;
  
  //ifid wires
 
  wire [63:0] random;
  
  //id ex wires
 
  wire [63:0] a1;
  wire [4:0] RS1;
  wire [4:0] RS2;
  wire [4:0] RD;
  wire [63:0] d, M1, M2;
  wire Branch;
  wire Memread;
  wire Memtoreg;
  wire Memwrite;
  wire Regwrite;
  wire Alusrc;
  wire [1:0] aluop;
  wire [3:0] funct4_out;
  
  //mux wires
  wire [63:0] threeby1_out1;
  wire[63:0] threeby1_out2;
  wire[63:0]  alu_64_b;
  
   //ex mem wires
  wire [63:0] write_Data;
  wire [63:0] exmem_out_adder;
  wire exmem_out_zero;
  wire [63:0] exmem_out_result;
  wire [4:0] exmemrd;
  wire BRANCH,MEMREAD,MEMTOREG,MEMEWRITE,REGWRITE;   
  
   // ALU 64
  wire [63:0] AluResult;
  wire zero;
  
  
  // ALU Control
  wire [3:0] operation;
  
  // Data Memory
  wire [63:0] readdata;
 
  
  
  
  //memwb wires
  wire[63:0] muxin1,muxin2;
  wire [4:0] memwbrd;
  wire memwb_memtoreg;
  wire memwb_regwrite;
  
  //forwarding unit wires
  wire [1:0] forwardA;
  wire [1:0] forwardB;
  
  // Branch
  wire addermuxselect;
  wire branch_final;
  
  
  pipeline_flush p_flush
  (
    .branch(branch_final & BRANCH),
    .flush(flush)
  );
  
  
  hazard_detection_unit hu
  (
    .Memread(Memread),
    .inst(inst_ifid_out),
    .Rd(RD),
    .stall(stall)
  );

  
  program_counter pc 
  (
    .PC_in(pc_in),
    .stall(stall),
    .clk(clk),
    .reset(reset),
    .PC_out(pc_out)
  );
  
  instruction_memory im
  (
    .inst_address(pc_out),
    .instruction(instruction)
  );
  
  
  adder adder1
  (
    .p(pc_out),
    .q(64'd4),
    .out(adderout1)
  );
  
   IFID i1 
  (
    .clk(clk),
    .reset(reset),
    .IFIDWrite(stall),
    .instruction(instruction),
    .A(pc_out),
    .inst(inst_ifid_out),
    .a_out(random),
    .flush(flush)
  );
  
  Parser ip
  (
    .instruction(inst_ifid_out),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
  
  CU cu
  (
    .opcode(opcode),
    .branch(branch),
    .memread(memread),
    .memtoreg(memtoreg),
    .memwrite(memwrite),
    .aluSrc(ALUsrc),
    .regwrite(regwrite),
    .Aluop(ALUop),
    .stall(stall)
  );
  
  data_extractor immextr
  (
    .instruction(inst_ifid_out),
    .imm_data(imm_data)
  );
  
  
  registerFile regfile 
  (
    .clk(clk),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    .rd(memwbrd),
    .writedata(write_data),
    .reg_write(memwb_regwrite),
    .readdata1(readdata1),
    .readdata2(readdata2),
    .r8(r8),
    .r19(r19),
    .r20(r20),
    .r21(r21),
    .r22(r22)
  );
  
  IDEX i2
  (
    .clk(clk),
    .flush(flush),
    .reset(reset),
    .funct4_in({inst_ifid_out[30],inst_ifid_out[14:12]}),
    .A_in(random),
    .readdata1_in(readdata1),
    .readdata2_in(readdata2),
    .imm_data_in(imm_data),
    .rs1_in(rs1),.rs2_in(rs2),.rd_in(rd),
    .branch_in(branch),.memread_in(memread),.memtoreg_in(memtoreg),
    .memwrite_in(memwrite),.aluSrc_in(ALUsrc),.regwrite_in(regwrite),.Aluop_in(ALUop),
    .a(a1),.rs1(RS1),.rs2(RS2),.rd(RD),.imm_data(d),.readdata1(M1),.readdata2(M2),
    .funct4_out(funct4_out),.Branch(Branch),.Memread(Memread),.Memtoreg(Memtoreg),
    .Memwrite(Memwrite),.Regwrite(Regwrite),.Alusrc(Alusrc),.aluop(aluop)
  );
  adder adder2
  (
    .p(a1),
    .q(d << 1),
    .out(adderout2)
  );
  
  
  ThreebyOneMux m1
  (
    .a(M1),.b(write_data),.c(exmem_out_result),.sel(forwardA),.out(threeby1_out1)
  );
  
  ThreebyOneMux m2
  (
    .a(M2),.b(write_data),.c(exmem_out_result),.sel(forwardB),.out(threeby1_out2)
  );
  
  twox1Mux mux1
  (
    .A(threeby1_out2),.B(d),.SEL(Alusrc),.Y(alu_64_b)
  );
  
  Alu64 alu
  (
    .a(threeby1_out1),
    .b(alu_64_b),
    .ALuop(operation),
    .Result(AluResult),
    .zero(zero)
  );
  
   alu_control ac
  (
    .Aluop(aluop),
    .funct(funct4_out),
    .operation(operation)
  );
  
 
  
  EXMEM i3
  (
    .clk(clk),.reset(reset),.Adder_out(adderout2),.Result_in_alu(AluResult),.Zero_in(zero),.flush(flush),
    .writedata_in(threeby1_out2),.Rd_in(RD), .addermuxselect_in(addermuxselect),
    .branch_in(Branch),.memread_in(Memread),.memtoreg_in(Memtoreg),.memwrite_in(Memwrite),.regwrite_in(Regwrite),
    .Adderout( exmem_out_adder),.zero(exmem_out_zero),.result_out_alu(exmem_out_result),.writedata_out(write_Data),
    .rd(exmemrd),.Branch(BRANCH),.Memread(MEMREAD),.Memtoreg(MEMTOREG),.Memwrite(MEMEWRITE),.Regwrite(REGWRITE), .addermuxselect(branch_final)
  );
    
  data_memory datamem
  (
    .write_data(write_Data),
    .address(exmem_out_result),
    .memorywrite(MEMEWRITE),
    .clk(clk),
    .memoryread(MEMREAD),
    .read_data(readdata),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8)
  );
  
  
  twox1Mux mux2
  (
    .A(adderout1),.B(exmem_out_adder),.SEL(BRANCH & branch_final),.Y(pc_in) // ??
  );

 
  MEMWB i4
  
  (
    .clk(clk),.reset(reset),.read_data_in(readdata),
    .result_alu_in(exmem_out_result),.Rd_in(exmemrd),.memtoreg_in(MEMTOREG),.regwrite_in(REGWRITE),
    .readdata(muxin1),.result_alu_out(muxin2),.rd(memwbrd),.Memtoreg(memwb_memtoreg),.Regwrite(memwb_regwrite)
  );
  
   twox1Mux mux3
  (
    .A(muxin2),.B(muxin1),.SEL(memwb_memtoreg),.Y(write_data)
  );
  
  
   ForwardingUnit f1
  (
    .RS_1(RS1),.RS_2(RS2),.rdMem(exmemrd),
    .rdWb(memwbrd),.regWrite_Wb(memwb_regwrite),
    .regWrite_Mem(REGWRITE),
    .Forward_A(forwardA),.Forward_B(forwardB)
  );
  
  
  branching_unit branc
  (
    .funct3(funct4_out[2:0]),.readData1(M1),.b(alu_64_b),.addermuxselect(addermuxselect)
  );

        
endmodule 

module tb();
  reg clk, reset;
  wire [63:0] element1;
  wire [63:0] element2;
  wire [63:0] element3;
  wire [63:0] element4;
  wire [63:0] element5;
  wire [63:0] element6;
  wire [63:0] element7;
  wire [63:0] element8;
  wire stall;
  wire flush;
  
  RISC_V_Processor r1
  (
    .clk(clk),
    .reset(reset),
    .element1(element1),
    .element2(element2),
    .element3(element3),
    .element4(element4),
    .element5(element5),
    .element6(element6),
    .element7(element7),
    .element8(element8),
    .stall(stall),
    .flush(flush)
  );
  
  initial 
    begin
      
      $dumpfile("dump.vcd");
      $dumpvars(1, tb);
		
      clk = 1'b0;
      reset = 1'b1;
      
      #7 
      reset = 1'b0;
      #7000
      $finish;
      
    end
  
  always
    begin
      #5
      clk = ~clk;
    end
endmodule
