`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.03.2024 00:18:11
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb( );
wire [7:0]out;
reg [3:0]feature;
reg [3:0]filter;
reg clk,rst;
reg [3:0]stride,pad;
wire check;
conv c2( out,check,feature,filter,clk,rst,stride,pad);

initial 
begin
clk = 1;
forever #5 clk = ~clk;
end

initial
begin
rst = 1;
#100
rst = 0;
pad = 2; stride = 1;
feature = 4'd3; filter = 4'd0;
#20 feature = 4'd2; filter = 4'd0;
#20 feature = 4'd1; filter = 4'd0;

#20 feature = 4'd0; filter = 4'd1;
#20 feature = 4'd0; filter = 4'd2;


end
endmodule
