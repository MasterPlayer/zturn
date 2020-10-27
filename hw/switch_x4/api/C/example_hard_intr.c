#include <stdio.h>
#include <stdlib.h>
#include "xil_io.h"
#include "xil_exception.h"
#include "xparameters.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xil_types.h"
#include "xscugic.h"
#include "axi_sw_ctrlr.h"

#define SW0_INT_ID  0x00

int scugic_initialize(XScuGic *gic_inst_ptr, axi_sw_ctrlr* axi_sw_ctrlr_inst_ptr);

void sw_intr_handler(void *CallbackRef);

XScuGic intr_ctrl;
static axi_sw_ctrlr axi_sw_ctrl;
static XScuGic_Config *gic_cfg;



int main() {

    init_platform();

    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);

    axi_sw_ctrlr_init(&axi_sw_ctrl, XPAR_AXI_SW_CTRLR_VHD_0_BASEADDR);

    axi_sw_ctrlr_set_mask(&axi_sw_ctrl, SW0_MASK | SW1_MASK | SW2_MASK | SW3_MASK);

    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);
    scugic_initialize(&intr_ctrl, &axi_sw_ctrl);

    while(1){

    }



    return XST_SUCCESS;
}

void sw_intr_handler(void *CallbackRef){

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

	return ;
}



int scugic_initialize(XScuGic *gic_inst_ptr, axi_sw_ctrlr* axi_sw_ctrlr_inst_ptr){
    int status = 0;

    XScuGic_Config *cfg;

    cfg = XScuGic_LookupConfig(XPAR_SCUGIC_0_DEVICE_ID);

    status = XScuGic_CfgInitialize(gic_inst_ptr, cfg, cfg->CpuBaseAddress);

    status = XScuGic_Connect(gic_inst_ptr, XPAR_FABRIC_AXI_SW_CTRLR_VHD_0_IRQ_INTR, (Xil_InterruptHandler)sw_intr_handler, axi_sw_ctrlr_inst_ptr);

	XScuGic_Enable(gic_inst_ptr, XPAR_FABRIC_AXI_SW_CTRLR_VHD_0_IRQ_INTR);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, gic_inst_ptr);
	Xil_ExceptionEnableMask(XIL_EXCEPTION_ALL);

	Xil_ExceptionEnable();
    return status ;
}


