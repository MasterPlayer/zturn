#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "axi_buzzer.h"


int main()
{
    init_platform();

    static buzzer buzzer_inst;

    axi_buzzer_init(&buzzer_inst, XPAR_AXI_BUZZER_VHD_0_BASEADDR);
//    axi_buzzer_set_duration_on(&buzzer_inst, 10000000);
//    axi_buzzer_set_duration_off(&buzzer_inst, 5000000);
    axi_buzzer_set_mode(&buzzer_inst, MODE_BLINK);
//    axi_buzzer_enable(&buzzer_inst);
//    axi_buzzer_disable(&buzzer_inst);


//    axi_buzzer_init(&buzzer_inst, XPAR_AXI_BUZZER_VHD_0_BASEADDR);
    axi_buzzer_set_duration_on(&buzzer_inst, 50000000);
    axi_buzzer_set_duration_off(&buzzer_inst, 50000000);
    axi_buzzer_enable(&buzzer_inst);
    while(axi_buzzer_has_active(&buzzer_inst)){

    }
    axi_buzzer_set_duration_on(&buzzer_inst, 50000000);
    axi_buzzer_set_duration_off(&buzzer_inst, 50000000);

    while(axi_buzzer_has_active(&buzzer_inst)){

    }
    axi_buzzer_set_duration_on(&buzzer_inst, 25000000);
    axi_buzzer_set_duration_off(&buzzer_inst, 25000000);

    while(axi_buzzer_has_active(&buzzer_inst)){

    }
    axi_buzzer_set_duration_on(&buzzer_inst, 25000000);
    axi_buzzer_set_duration_off(&buzzer_inst, 25000000);

    while(axi_buzzer_has_active(&buzzer_inst)){

    }
    axi_buzzer_set_duration_on(&buzzer_inst, 25000000);
    axi_buzzer_set_duration_off(&buzzer_inst, 25000000);

    axi_buzzer_disable(&buzzer_inst);
    print("Hello World\n\r");

    cleanup_platform();
    return 0;
}
