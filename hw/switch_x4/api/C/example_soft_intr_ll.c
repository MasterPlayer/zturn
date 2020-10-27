#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "axi_sw_ctrlr.h"

#include <xscugic.h>


#define CPU_BASEADDR        XPAR_SCUGIC_0_CPU_BASEADDR
#define DIST_BASEADDR       XPAR_SCUGIC_0_DIST_BASEADDR

#define GIC_DEVICE_INT_MASK_SW        0x02010001

#define DEFAULT_PRIORITY    0xa0a0a0a0UL
#define DEFAULT_TARGET    0x01010101UL


void setup_interrupt_system();

void low_interrupt_handler_sw(u32 callback_ref);

static void gic_dist_init(u32 baseaddr);

static void gic_cpu_init(u32 baseaddr);

static axi_sw_ctrlr axi_sw_ctrl;



int main() {
    init_platform();


    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);

    axi_sw_ctrlr_init(&axi_sw_ctrl, XPAR_AXI_SW_CTRLR_VHD_0_BASEADDR);

//    axi_sw_ctrlr_set_mask(&axi_sw_ctrl, SW0_MASK );
    xil_printf("current mask : 0x%02x\r\n", axi_sw_ctrlr_get_mask(&axi_sw_ctrl));

    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);

    /*Software interrupt*/
    gic_dist_init(DIST_BASEADDR);
    gic_cpu_init(CPU_BASEADDR);

    setup_interrupt_system();
    XScuGic_WriteReg(DIST_BASEADDR, XSCUGIC_ENABLE_SET_OFFSET, 0x0000FFFF);

    while(1){
        uint32_t acked = axi_sw_ctrlr_get_event_reg(&axi_sw_ctrl);
        if (axi_sw_ctrlr_has_switched(&axi_sw_ctrl, SW0_MASK | SW1_MASK | SW2_MASK | SW3_MASK))
            XScuGic_WriteReg(DIST_BASEADDR, XSCUGIC_SFI_TRIG_OFFSET, GIC_DEVICE_INT_MASK_SW);
    }

    cleanup_platform();
    return 0;
}


void setup_interrupt_system(void) {
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT, (Xil_ExceptionHandler) low_interrupt_handler_sw, (void *)CPU_BASEADDR);
    Xil_ExceptionEnable();
}



void low_interrupt_handler_sw(u32 callback_ref) {
    u32 baseaddr;
    u32 intr_id;
    baseaddr = callback_ref;
    intr_id = XScuGic_ReadReg(baseaddr, XSCUGIC_INT_ACK_OFFSET) & XSCUGIC_ACK_INTID_MASK;
    if (XSCUGIC_MAX_NUM_INTR_INPUTS < intr_id){
        return;
    }

    uint32_t sw_number = axi_sw_ctrlr_get_event_mask(&axi_sw_ctrl);
    uint32_t sw_mask  = 0;
    switch(sw_number){
    case 0x00000001 :
    	sw_mask = 0;
    	break;

    case 0x00000002 :
    	sw_mask = 1;
    	break;

    case 0x00000004 :
    	sw_mask = 2;
    	break;

    case 0x00000008 :
    	sw_mask = 3;
    	break;

    default:
    	return -1;
    }

    xil_printf("sw[%d] activated : switched state to %d\r\n", sw_mask, axi_sw_ctrlr_has_asserted(&axi_sw_ctrl, sw_number));

    axi_sw_ctrlr_event_ack(&axi_sw_ctrl, axi_sw_ctrlr_get_event_mask(&axi_sw_ctrl));

    XScuGic_WriteReg(baseaddr, XSCUGIC_EOI_OFFSET, intr_id);
}




static void gic_dist_init(u32 baseaddr) {
    u32 intr_id;

    XScuGic_WriteReg(baseaddr, XSCUGIC_DIST_EN_OFFSET, 0UL);

    for(intr_id = 32; intr_id < XSCUGIC_MAX_NUM_INTR_INPUTS; intr_id+=16) {
        XScuGic_WriteReg(baseaddr, XSCUGIC_INT_CFG_OFFSET + (intr_id * 4)/16, 0UL);
    }

    for(intr_id = 0; intr_id < XSCUGIC_MAX_NUM_INTR_INPUTS; intr_id+=4){
        XScuGic_WriteReg(baseaddr, XSCUGIC_PRIORITY_OFFSET +((intr_id *4)/4), DEFAULT_PRIORITY);
    }

    for(intr_id = 32; intr_id < XSCUGIC_MAX_NUM_INTR_INPUTS; intr_id+=4){
        XScuGic_WriteReg(baseaddr, XSCUGIC_SPI_TARGET_OFFSET +((intr_id *4)/4), DEFAULT_TARGET);
    }

    for(intr_id = 0; intr_id < XSCUGIC_MAX_NUM_INTR_INPUTS; intr_id+=32){
        XScuGic_WriteReg(baseaddr, XSCUGIC_DISABLE_OFFSET +((intr_id *4)/32), 0xFFFFFFFFUL);
    }

    XScuGic_WriteReg(baseaddr, XSCUGIC_DIST_EN_OFFSET, 0x01UL);
}



static void gic_cpu_init(u32 baseaddr) {
    XScuGic_WriteReg(baseaddr, XSCUGIC_CPU_PRIOR_OFFSET, 0xF0);
    XScuGic_WriteReg(baseaddr, XSCUGIC_CONTROL_OFFSET, 0x01);

}



