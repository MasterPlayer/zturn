`timescale 1ns / 1ps

module switch_ctrlr_x4_filter (
    input              clk   ,
    input              resetn,
    input        [3:0] sw    ,
    output logic [3:0] SW_F
);


    logic [ 3:0] d_sw = '{default:0};
    logic [31:0] hold_cnt = '{default:0};
    logic sig0;

    always_ff @(posedge clk) begin : d_sw_processing
        d_sw <= sw;
    end 

    always_ff @(posedge clk) begin : hold_cnt_processing 
        if (!resetn)
            hold_cnt <= '{default:0};
        else
            if (hold_cnt < 10000000 && hold_cnt > 0) 
                hold_cnt <= hold_cnt + 1;
            else
                if (hold_cnt == 0) begin
                    if (d_sw != sw) 
                        hold_cnt <= hold_cnt + 1;
                end else
                    hold_cnt <= '{default:0};
    end 

    always_ff @(posedge clk) begin
        if (!hold_cnt)
            SW_F <= sw;
    end 



endmodule : switch_ctrlr_x4_filter