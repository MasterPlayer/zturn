/*
 * axi_buzzer.h
 *
 *  Created on: 20 окт. 2020 г.
 *      Author: masterplayer
 */

#ifndef SRC_AXI_BUZZER_H_
#define SRC_AXI_BUZZER_H_

#include <stdint.h>

typedef struct buzzer_hw{
	uint32_t ctl_reg;
	uint32_t duration_on_reg;
	uint32_t duration_off_reg;
}buzzer_hw;

typedef struct buzzer{
	uint32_t baseaddr;
	uint32_t has_init;
	buzzer_hw* buzzer_hw_inst_ptr;
} buzzer;

enum ERR{
	NO_ERR = 0,
	NO_INIT = -1,
};

enum MODE{
	MODE_ONCE = 0x00,
	MODE_BLINK = 0x01,
	MODE_CONST = 0x02,
};

#define CTL_RESET_MASK 0x00000001
#define CTL_ENABLE_MASK 0x00000002
#define CTL_MODE_MASK 0x0000000C

#define CTL_BUZZER_ACTIVE 0x00010000

int axi_buzzer_set_ctl_reg(buzzer* buzzer_ptr, uint32_t value);
int axi_buzzer_set_duration_on_reg(buzzer* buzzer_ptr, uint32_t value);
int axi_buzzer_set_duration_off_reg(buzzer* buzzer_ptr, uint32_t value);

uint32_t axi_buzzer_get_ctl_reg(buzzer *buzzer_ptr);
uint32_t axi_buzzer_get_duration_on_reg(buzzer *buzzer_ptr);
uint32_t axi_buzzer_get_duration_off_reg(buzzer *buzzer_ptr);

int axi_buzzer_init(buzzer* buzzer_inst_ptr, uint32_t baseaddr);
int axi_buzzer_reset(buzzer* buzzer_inst_ptr);
int axi_buzzer_has_init(buzzer* buzzer_inst_ptr);
int axi_buzzer_enable(buzzer* buzzer_inst_ptr);
int axi_buzzer_disable(buzzer* buzzer_inst_ptr);

int axi_buzzer_set_mode(buzzer* buzzer_inst_ptr, enum MODE mode);
uint32_t axi_buzzer_get_mode(buzzer* buzzer_inst_ptr);

int axi_buzzer_set_duration_on(buzzer* buzzer_inst_ptr, uint32_t duration);
int axi_buzzer_set_duration_off(buzzer* buzzer_inst_ptr, uint32_t duration);
uint32_t axi_buzzer_get_duration_on(buzzer* buzzer_inst_ptr);
uint32_t axi_buzzer_get_duration_off(buzzer* buzzer_inst_ptr);

int axi_buzzer_has_active(buzzer* buzzer_inst_ptr);


#endif /* SRC_AXI_BUZZER_H_ */
