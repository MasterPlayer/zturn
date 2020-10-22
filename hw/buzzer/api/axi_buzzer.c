/*
 * axi_buzzer.c
 *
 *  Created on: 20 окт. 2020 г.
 *      Author: masterplayer
 */

#include "axi_buzzer.h"

int axi_buzzer_set_ctl_reg(buzzer* buzzer_ptr, uint32_t value){
	buzzer_ptr->buzzer_hw_inst_ptr->ctl_reg = value;
	return NO_ERR;

}


int axi_buzzer_set_duration_on_reg(buzzer* buzzer_ptr, uint32_t value){
	buzzer_ptr->buzzer_hw_inst_ptr->duration_on_reg = value;
	return NO_ERR;
}


int axi_buzzer_set_duration_off_reg(buzzer* buzzer_ptr, uint32_t value){
	buzzer_ptr->buzzer_hw_inst_ptr->duration_off_reg = value;
	return NO_ERR;
}



uint32_t axi_buzzer_get_ctl_reg(buzzer *buzzer_ptr){
	return (buzzer_ptr->buzzer_hw_inst_ptr->ctl_reg);
}


uint32_t axi_buzzer_get_duration_on_reg(buzzer *buzzer_ptr){
	return (buzzer_ptr->buzzer_hw_inst_ptr->duration_on_reg);
}


uint32_t axi_buzzer_get_duration_off_reg(buzzer *buzzer_ptr){
	return (buzzer_ptr->buzzer_hw_inst_ptr->duration_off_reg);
}


int axi_buzzer_init(buzzer* buzzer_inst_ptr, uint32_t baseaddr){
	buzzer_inst_ptr->baseaddr = baseaddr;
	buzzer_inst_ptr->has_init = 1;
	buzzer_inst_ptr->buzzer_hw_inst_ptr = baseaddr;

	int status = axi_buzzer_reset(buzzer_inst_ptr);
	return status;

}


int axi_buzzer_reset(buzzer* buzzer_inst_ptr){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}
	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & ~CTL_ENABLE_MASK);

	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & ~CTL_RESET_MASK);
	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, axi_buzzer_get_ctl_reg(buzzer_inst_ptr) | CTL_RESET_MASK);

	axi_buzzer_set_duration_on_reg(buzzer_inst_ptr, 0);
	axi_buzzer_set_duration_off_reg(buzzer_inst_ptr, 0);
	return NO_ERR;
}

int axi_buzzer_has_init(buzzer* buzzer_inst_ptr){
	return (buzzer_inst_ptr->has_init);
}


int axi_buzzer_enable(buzzer* buzzer_inst_ptr){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}

	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, axi_buzzer_get_ctl_reg(buzzer_inst_ptr) | CTL_ENABLE_MASK);
	return NO_ERR;
}


int axi_buzzer_disable(buzzer* buzzer_inst_ptr){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}

	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & ~CTL_ENABLE_MASK);
	return NO_ERR;
}



int axi_buzzer_set_mode(buzzer* buzzer_inst_ptr, enum MODE mode){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}

	axi_buzzer_set_ctl_reg(buzzer_inst_ptr, (axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & ~CTL_MODE_MASK) | (mode << 2));

}


uint32_t axi_buzzer_get_mode(buzzer* buzzer_inst_ptr){
	return ((axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & CTL_MODE_MASK) >> 2);
}


int axi_buzzer_set_duration_on(buzzer* buzzer_inst_ptr, uint32_t duration){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}

	axi_buzzer_set_duration_on_reg(buzzer_inst_ptr, duration);
	return NO_ERR;
}


int axi_buzzer_set_duration_off(buzzer* buzzer_inst_ptr, uint32_t duration){
	if (!axi_buzzer_has_init(buzzer_inst_ptr)){
		return NO_INIT;
	}

	axi_buzzer_set_duration_off_reg(buzzer_inst_ptr, duration);
	return NO_ERR;
}


uint32_t axi_buzzer_get_duration_on(buzzer* buzzer_inst_ptr){
	return (axi_buzzer_get_duration_on_reg(buzzer_inst_ptr));
}


uint32_t axi_buzzer_get_duration_off(buzzer* buzzer_inst_ptr){
	return (axi_buzzer_get_duration_off_reg(buzzer_inst_ptr));
}

int axi_buzzer_has_active(buzzer* buzzer_inst_ptr){
	return ((axi_buzzer_get_ctl_reg(buzzer_inst_ptr) & CTL_BUZZER_ACTIVE) >> 16) ;
}


