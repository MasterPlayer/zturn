#include <stdio.h>
#include <stdint.h>

/*
 * Hardware structure which mapped to device
 * */
typedef struct rgb_hw{
	uint32_t ctl_reg;
	uint32_t ctl_r_reg;
	uint32_t duration_r_reg;
	uint32_t ctl_g_reg;
	uint32_t duration_g_reg;
	uint32_t ctl_b_reg;
	uint32_t duration_b_reg;
} rgb_hw;


/*
 * rgb soft structure for hold parameters
 * */
typedef struct rgb{
	uint32_t baseaddr;
	uint8_t has_init;
	rgb_hw*	rgb_hw_inst;
} rgb;

/*enumeration for color leds in board. do not modify*/
enum LED_COLOR {
	RED = 0x00000002,
	GREEN = 0x00000004,
	BLUE = 0x00000008,
};


enum LED_MODE{
	LED_MODE_ON = 0x00,
	LED_MODE_BLINK = 0x01,
};

enum LED_STS{
	ACTIVE = 0x01,
	INACTIVE = 0x00,
};

/*List of returned functions*/
enum ERRS{
	NO_ERR = 0,
	NO_INIT = -1,
	NO_LED_IN_GROUP = -2,
};

/*Fields ctl register*/
#define CTL_RESET_MASK 0x00000001

/*Fields ctl_x registers (for individually every LED*/
#define MODE_MASK 	0x00000001
#define ENABLE_MASK 0x00000002
#define HOLDED_MASK 0x00000004

// SET functions for hw instance
int axi_led_rgb_set_ctl_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_ctl_r_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_duration_r_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_ctl_g_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_duration_g_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_ctl_b_reg(rgb *rgb_inst_ptr, uint32_t value);
int axi_led_rgb_set_duration_b_reg(rgb *rgb_inst_ptr, uint32_t value);

// get functions for hw instance
uint32_t axi_led_rgb_get_ctl_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_ctl_r_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_duration_r_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_ctl_g_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_duration_g_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_ctl_b_reg(rgb *rgb_inst_ptr);
uint32_t axi_led_rgb_get_duration_b_reg(rgb *rgb_inst_ptr);

int axi_led_rgb_has_init(rgb *rgb_inst_ptr);

int axi_led_rgb_init(rgb *rgb_inst_ptr, uint32_t baseaddr);
int axi_led_rgb_reset(rgb *rgb_inst_ptr);
int axi_led_rgb_restart(rgb *rgb_inst_ptr);
int axi_led_rgb_get_led_status(rgb *rgb_inst_ptr, enum LED_COLOR color);


int axi_led_set_duration(rgb *rgb_inst_ptr, enum LED_COLOR color, uint32_t duration);
int axi_led_get_duration(rgb *rgb_inst_ptr, enum LED_COLOR);

int axi_led_set_enable(rgb *rgb_inst_ptr, enum LED_COLOR color);
int axi_led_set_disable(rgb *rgb_inst_ptr, enum LED_COLOR color);
int axi_led_set_mode(rgb *rgb_inst_ptr, enum LED_COLOR color, enum LED_MODE);
int axi_led_set_hold(rgb *rgb_inst_ptr, enum LED_COLOR color);
int axi_led_set_unhold(rgb *rgb_inst_ptr, enum LED_COLOR color);

