#include "xparameters.h"
#include "xiicps.h"
#include "xil_printf.h"
#include <stdint.h>
#define IIC_DEVICE_ID       XPAR_XIICPS_0_DEVICE_ID


#define IIC_SLAVE_ADDR      0x29
#define IIC_SCLK_RATE       400000

int IicPsMasterPolledExample(u16 DeviceId);



int main(){
    int Status;

    xil_printf("IIC Master Polled Example Test \r\n");

    Status = IicPsMasterPolledExample(IIC_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("IIC Master Polled Example Test Failed\r\n");
        return XST_FAILURE;
    }

    xil_printf("Successfully ran IIC Master Polled Example Test\r\n");
    return XST_SUCCESS;
}


int IicPsMasterPolledExample(u16 DeviceId){

	XIicPs Iic;     /**< Instance of the IIC Device */

    int Status;
    XIicPs_Config *Config;
    int Index;

    Config = XIicPs_LookupConfig(DeviceId);
    if (NULL == Config) {
        return XST_FAILURE;
    }

    Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    Status = XIicPs_SelfTest(&Iic);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);

    u32 clk = XIicPs_GetSClk(&Iic);

    u8 RecvBuffer[2];
    u8 SendBuffer[2];

    for (int i = 0 ; i < 2; i++ ){
    	RecvBuffer[i] = 0;
    	SendBuffer[i] = 0x00;
    }
    float min = 100;
    float max = 0;

	int delay = 100000000;


    while(1){

		Status = XIicPs_MasterSendPolled(&Iic, SendBuffer, 1, 0x49);
		if (Status != XST_SUCCESS){
			printf("!!\r\n");
		}

		while (XIicPs_BusIsBusy(&Iic)) {

		}



		XIicPs_MasterRecvPolled(&Iic, RecvBuffer, 2, 0x49);
		if (Status != XST_SUCCESS){
			printf("!!\r\n");
		}

		int16_t temp = 0;
		uint16_t raw = ( RecvBuffer[0] << 8)| RecvBuffer[1];
		raw = raw >> 7;
		if (raw & 0x0100) {
			temp = -10 * (((~(uint8_t)(raw & 0xFE) + 1) & 0x7F) >> 1) - (raw & 0x01) * 5;
		} else {
			temp = ((raw & 0xFE) >> 1) * 10 + (raw & 0x01) * 5;
		}


	    int grades = (temp) / 10;
	    float partition = ((float)(temp % 10))/10;
	    float tempf = (float)grades + (float)partition;
	    if (tempf > max){
	    	max = tempf;
	    }
	    if(tempf < min){
	    	min = tempf;
	    }
	    printf("cur : %3.1f, min : %3.1f, max : %3.1f\r\n", tempf, min, max);

		for (int i = 0; i < delay; i++);
    }
    return XST_SUCCESS;
}
