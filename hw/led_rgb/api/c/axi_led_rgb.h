#include <stdio.h>
#include <stdint.h>


typedef struct rgb_hw{
	uint32_t ctl_reg;
	uint32_t ctl_r_reg;
	uint32_t duration_r_reg;
	uint32_t ctl_g_reg;
	uint32_t duration_g_reg;
	uint32_t ctl_b_reg;
	uint32_t duration_b_reg;
} rgb_hw;


typedef struct rgb{
	uint32_t baseaddr;
	uint8_t has_init;
	rgb_hw*	rgb_hw_inst;
} rgb;

enum COLOR {
	RED,
	GREEN,
	BLUE,
};

enum LED_MODE{
	LED_ON = 0x00000000,
	LED_BLINK = 0x00000001,
};

#define CTL_RESET_MASK 0x00000001

#define CTL_REG_LED_R_STS_MASK 0x00000002
#define CTL_REG_LED_G_STS_MASK 0x00000004
#define CTL_REG_LED_B_STS_MASK 0x00000008

#define MODE_MASK 	0x00000001
#define ENABLE_MASK 0x00000002
#define HOLDED_MASK 0x00000004


int axi_led_rgb_init(rgb *rgb_inst_ptr, uint32_t baseaddr);
int axi_led_rgb_reset(rgb *rgb_inst_ptr);
int axi_led_rgb_get_led_status(rgb *rgb_inst_ptr, uint8_t mask);

int axi_led_set_duration(rgb *rgb_inst_ptr, uint32_t duration, enum COLOR color);

int axi_led_set_enable(rgb *rgb_inst_ptr, enum COLOR color);
int axi_led_set_disable(rgb *rgb_inst_ptr, enum COLOR color);
int axi_led_set_mode(rgb *rgb_inst_ptr, enum COLOR color, enum LED_MODE);
int axi_led_set_hold(rgb *rgb_inst_ptr, enum COLOR color);
int axi_led_set_unhold(rgb *rgb_inst_ptr, enum COLOR color);

