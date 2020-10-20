#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "axi_led_rgb.h"


int main() {
	static rgb rgb_ctrlr;

	init_platform();

    axi_led_rgb_init(&rgb_ctrlr, XPAR_AXI_LED_RGB_VHD_BASEADDR);
//
    axi_led_set_duration(&rgb_ctrlr, RED, 100000000);
    axi_led_set_mode(&rgb_ctrlr, RED, LED_MODE_ON);
    axi_led_set_enable(&rgb_ctrlr, RED);
//    axi_led_set_hold(&rgb_ctrlr, RED);
//    axi_led_set_disable(&rgb_ctrlr, RED);

    axi_led_set_duration(&rgb_ctrlr, GREEN, 100000000);
    axi_led_set_mode(&rgb_ctrlr, GREEN, LED_MODE_BLINK);
    axi_led_set_enable(&rgb_ctrlr, GREEN);
//    axi_led_set_hold(&rgb_ctrlr, GREEN);
    axi_led_set_disable(&rgb_ctrlr, GREEN);
//

    axi_led_set_duration(&rgb_ctrlr, BLUE, 100000000);
    axi_led_set_mode(&rgb_ctrlr, BLUE, LED_MODE_BLINK);
    axi_led_set_enable(&rgb_ctrlr, BLUE);
//    axi_led_set_hold(&rgb_ctrlr, BLUE);
    axi_led_set_disable(&rgb_ctrlr, BLUE);

//    axi_led_rgb_restart(&rgb_ctrlr);
    int j = 100000000;

    int r = axi_led_rgb_get_led_status(&rgb_ctrlr, RED);
    int g = axi_led_rgb_get_led_status(&rgb_ctrlr, GREEN);
    int b = axi_led_rgb_get_led_status(&rgb_ctrlr, BLUE);

    printf("duration_r : %d\r\n", axi_led_rgb_get_duration_r_reg(&rgb_ctrlr));

    cleanup_platform();
    return 0;
}
