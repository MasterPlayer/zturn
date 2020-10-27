`timescale 1ns / 1ps

module sw_ctrlr_x4 (
    input              clk         ,
    input              resetn      ,
    input              enable_irq  ,
    input        [3:0] sw_mask     ,
    input        [3:0] sw_event_ack,
    output logic [3:0] sw_event    ,
    output logic [3:0] sw_state    ,
    output logic       irq         ,
    input        [3:0] SW
);

    logic [3 : 0] d_sw = '{default:0};
    logic [3 : 0] on_differ = '{default:0};
    logic [3 : 0] on_differ_masked = '{default:0};

    logic [ 31 : 0] on_hold_0 = '{default:0};
    logic [  3 : 0] delayed_sw;

    always_ff @(posedge clk) begin : d_sw_processing
        d_sw <= SW;
    end 

    always_ff @(posedge clk) begin : on_differ_processing 
        on_differ <= d_sw ^ SW;
    end 

    always_ff @(posedge clk) begin : on_differ_masked_processing 
        on_differ_masked <= on_differ & sw_mask;
    end 

    always_ff @(posedge clk) begin : irq_processing
        if (!resetn)
            irq <= 1'b0;
        else
            if (enable_irq) 
                if (on_differ_masked) 
                    irq <= 1'b1;
                else begin 
                    if (sw_event == sw_event_ack)
                        irq <= 1'b0;
                end 
            else 
                irq <= 1'b0;
    end

    always_ff @(posedge clk) begin : sw_event_ack_processing
        if (!resetn)
            sw_event <= '{default:0};
        else
            if (d_sw != SW)
                sw_event <= d_sw ^ SW;
            else
                if (sw_event == sw_event_ack)
                    sw_event <= '{default:0};
    end 

    always_ff @(posedge clk) begin : sw_state_processing 
        sw_state <= SW;
    end 

endmodule : sw_ctrlr_x4