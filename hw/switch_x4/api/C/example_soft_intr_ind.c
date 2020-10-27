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
#define SW1_INT_ID  0x01
#define SW2_INT_ID  0x02
#define SW3_INT_ID  0x03


int gic_example(uint32_t DeviceId);

int setup_intr_system(XScuGic *XScuGicInstancePtr);

void sw0_intr_handler(void *CallbackRef);
void sw1_intr_handler(void *CallbackRef);
void sw2_intr_handler(void *CallbackRef);
void sw3_intr_handler(void *CallbackRef);

XScuGic intr_ctrl;
static axi_sw_ctrlr axi_sw_ctrl;
static XScuGic_Config *gic_cfg;

int main(void) {


    init_platform();

    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);
    axi_sw_ctrlr_init(&axi_sw_ctrl, XPAR_AXI_SW_CTRLR_VHD_0_BASEADDR);

    axi_sw_ctrlr_enable_irq(&axi_sw_ctrl);

	gic_cfg = XScuGic_LookupConfig(XPAR_SCUGIC_0_DEVICE_ID);
    XScuGic_CfgInitialize(&intr_ctrl, gic_cfg, gic_cfg->CpuBaseAddress);
    setup_intr_system(&intr_ctrl);

    XScuGic_Connect(&intr_ctrl, SW0_INT_ID, (Xil_ExceptionHandler)sw0_intr_handler, (void *)&intr_ctrl);
    XScuGic_Connect(&intr_ctrl, SW1_INT_ID, (Xil_ExceptionHandler)sw1_intr_handler, (void *)&intr_ctrl);
    XScuGic_Connect(&intr_ctrl, SW2_INT_ID, (Xil_ExceptionHandler)sw2_intr_handler, (void *)&intr_ctrl);
    XScuGic_Connect(&intr_ctrl, SW3_INT_ID, (Xil_ExceptionHandler)sw3_intr_handler, (void *)&intr_ctrl);

    XScuGic_Enable(&intr_ctrl, SW0_INT_ID);
    XScuGic_Enable(&intr_ctrl, SW1_INT_ID);
    XScuGic_Enable(&intr_ctrl, SW2_INT_ID);
    XScuGic_Enable(&intr_ctrl, SW3_INT_ID);

    while(1){

		if (axi_sw_ctrlr_has_switched(&axi_sw_ctrl, SW0_MASK)){
			XScuGic_SoftwareIntr(&intr_ctrl, SW0_INT_ID, XSCUGIC_SPI_CPU0_MASK);
		}

		if (axi_sw_ctrlr_has_switched(&axi_sw_ctrl, SW1_MASK)){
			XScuGic_SoftwareIntr(&intr_ctrl, SW1_INT_ID, XSCUGIC_SPI_CPU0_MASK);
		}

		if (axi_sw_ctrlr_has_switched(&axi_sw_ctrl, SW2_MASK)){
			XScuGic_SoftwareIntr(&intr_ctrl, SW2_INT_ID, XSCUGIC_SPI_CPU0_MASK);
		}

		if (axi_sw_ctrlr_has_switched(&axi_sw_ctrl, SW3_MASK)){
			XScuGic_SoftwareIntr(&intr_ctrl, SW3_INT_ID, XSCUGIC_SPI_CPU0_MASK);
		}


    }



    return XST_SUCCESS;
}



int setup_intr_system(XScuGic *XScuGicInstancePtr) {

    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XScuGic_InterruptHandler, XScuGicInstancePtr);
    Xil_ExceptionEnable();
}



void sw0_intr_handler(void *CallbackRef){
    uint32_t sw_number = axi_sw_ctrlr_get_event_mask(&axi_sw_ctrl);

    xil_printf("sw[0] activated : switched state to %d\r\n", axi_sw_ctrlr_has_asserted(&axi_sw_ctrl, 0x00000001));

    axi_sw_ctrlr_event_ack(&axi_sw_ctrl, 0x00000001);
}


void sw1_intr_handler(void *CallbackRef){

    xil_printf("sw[1] activated : switched state to %d\r\n", axi_sw_ctrlr_has_asserted(&axi_sw_ctrl, 0x00000002));

    axi_sw_ctrlr_event_ack(&axi_sw_ctrl, 0x00000002);

}

void sw2_intr_handler(void *CallbackRef){
    uint32_t sw_number = axi_sw_ctrlr_get_event_mask(&axi_sw_ctrl);

    xil_printf("sw[2] activated : switched state to %d\r\n", axi_sw_ctrlr_has_asserted(&axi_sw_ctrl, 0x00000004));

    axi_sw_ctrlr_event_ack(&axi_sw_ctrl, 0x00000004);

}

void sw3_intr_handler(void *CallbackRef){

    xil_printf("sw[3] activated : switched state to %d\r\n", axi_sw_ctrlr_has_asserted(&axi_sw_ctrl, 0x00000008));

    axi_sw_ctrlr_event_ack(&axi_sw_ctrl, 0x00000008);

}
