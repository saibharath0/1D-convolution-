`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2024 22:55:34
// Design Name: 
// Module Name: conv
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


module conv ( output [7:0]out,
              output reg done,
             input [3:0]feature,[3:0]filter,
             input clk,rst,
             input [3:0]stride,pad
            );
            
            
parameter n = 3,m=2;//feature size filter size             
reg [3:0] feature_dum [n-1:0];
reg [3:0] filter_dum [m-1:0];
reg [3:0]next_state,state;
parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8;
reg [2:0]counta,countb,countd;
reg [7:0]product;
reg [3:0]countc;
reg [7:0]sum;
reg [7:0]check;
always @(posedge clk)
begin
    if(rst)
        begin
            state <= s0;
        end
    else 
        begin
            state <= next_state;
            if(state==s0)
                begin
                    counta <= 0;
                    countb <= 0;  
                    countc <= 0;
                    countd <= 0;
                    sum <= 0;
                end
                
            else if(state==s1)
                begin
                        if(counta<n-1)
                            begin
                                counta <= counta+1;
                            end
                        else 
                            begin
                                counta <= 0;
                            end            
                end
                
            else if(state==s2) 
                begin
                   feature_dum[counta] <= feature;
                end
            
            else if(state==s3)
                begin
                        if(countb<m-1)
                            begin
                                countb <= countb+1;
                            end
                        else 
                            begin
                                countb <= 0;
                            end
                end
            
            else if(state==s4) filter_dum[countb] <= filter;
            
            else if(state==s5)
                        begin
                            if(countd<m-1)
                                begin
                                    countd <= countd+1;
                                end
                            else 
                                begin
                                    countd <= 0;
                                    countc <= countc+1;
                                    sum <= 0;
                                end
                        end
                        
             else if(state==s6)
                begin
                    if(((countd+countc*stride)<=(pad-1)) || ((countd+countc*stride)>(n+pad-1)))
                        begin
                            product <=0;
                        end
                    else
                        begin
                            product <= feature_dum[countd+countc*stride-pad]*filter_dum[countd];
                        end
                end 
                
             else if(state==s7)
                begin
                    sum <= sum + product;
                    check <= 0;
                end
        end
end

always @(*)
begin
    case(state)
        
        s0: begin
                next_state = s2;
                done = 0;
            end
        s1: begin
                if(counta<n-1) 
                    begin
                        next_state = s2;
                        done = 0;
                    end
                else 
                    begin
                        next_state = s4;
                        done = 0;
                    end
            end
            
        s2: begin
                next_state = s1;
                done = 0;
            end
            
        s3: begin
                if(countb<m-1)
                    begin
                        next_state = s4;
                        done = 0;
                    end
                else 
                    begin
                        next_state = s6;
                        done = 0;
                    end
            end   
            
        s4: begin
                next_state = s3;
                done = 0;
            end
            
        s5: begin//
                if(countd==m-1)
                        begin
                            done = 1;
//                            out = sum;
                            if((countd+countc*stride-pad-1) == n)//
                                begin
                                    next_state = s0;
                                end
                            else 
                                begin
                                    next_state = s6;
                                end
                            
                        end
                else 
                    begin
                        next_state = s6;
                        done = 0;
                    end
            end
        
        s6: begin
                next_state = s7;
                done = 0;
            end
        s7: begin
                next_state = s5;
                done = 0;
            end

        default: begin
                    next_state = s0;
                    done = 0;
                 end
    endcase
end
assign out = sum;
endmodule
