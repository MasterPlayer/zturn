#include "axi_led_rgb.h"


/*
 *
 * @author
 * 		MasterPlayer
 *
 * @date
 * 		12.10.2020
 *
 * @param rgb_inst_ptr - pointer of rgb driver struct
 * @param baseaddr - baseaddr of address device
 *
 * @return
 * 		0 if function execution complete
 *
 * @note
 * 		none
 *
 * */
int axi_led_rgb_init(rgb *rgb_inst_ptr, uint32_t baseaddr){

	rgb_inst_ptr->rgb_hw_inst = baseaddr;
	rgb_inst_ptr->baseaddr = baseaddr;
	rgb_inst_ptr->has_init = 1;

	return 0;

}


int axi_led_rgb_reset(rgb *rgb_inst_ptr){
	rgb_inst_ptr->rgb_hw_inst->ctl_reg |= CTL_RESET_MASK;
//	rgb_inst_ptr->rgb_hw_inst->ctl_reg &= ~CTL_RESET_MASK;
	return 0;
}


int axi_led_rgb_get_led_status(rgb *rgb_inst_ptr, uint8_t mask){
	return (rgb_inst_ptr->rgb_hw_inst->ctl_reg & mask);
}


int axi_led_set_duration(rgb *rgb_inst_ptr, uint32_t duration, enum COLOR color){
	switch (color) {
		case RED:
			rgb_inst_ptr->rgb_hw_inst->duration_r_reg = duration;
			break;
		case GREEN :
			rgb_inst_ptr->rgb_hw_inst->duration_g_reg = duration;
			break;
		case BLUE :
			rgb_inst_ptr->rgb_hw_inst->duration_r_reg = duration;
			break;
		default:
			break;
	}
		return 0;
}


int axi_led_set_enable(rgb *rgb_inst_ptr, enum COLOR color){
	switch (color){
	case RED :
		rgb_inst_ptr->rgb_hw_inst->ctl_r_reg |= ENABLE_MASK;
		break;

	case GREEN :
		rgb_inst_ptr->rgb_hw_inst->ctl_g_reg |= ENABLE_MASK;
		break;

	case BLUE :
		rgb_inst_ptr->rgb_hw_inst->ctl_b_reg |= ENABLE_MASK;
		break;

	}
	return 0;
}


int axi_led_set_disable(rgb *rgb_inst_ptr, enum COLOR color){
	switch (color){
	case RED :
		rgb_inst_ptr->rgb_hw_inst->ctl_r_reg &= ~ENABLE_MASK;
		break;

	case GREEN :
		rgb_inst_ptr->rgb_hw_inst->ctl_g_reg &= ~ENABLE_MASK;
		break;

	case BLUE :
		rgb_inst_ptr->rgb_hw_inst->ctl_b_reg &= ~ENABLE_MASK;
		break;

	}

	return 0;
}


int axi_led_set_mode(rgb *rgb_inst_ptr, enum COLOR color, enum LED_MODE mode){
	switch (color){
		case RED :
			rgb_inst_ptr->rgb_hw_inst->ctl_r_reg &= (~MODE_MASK & mode);
			break;

		case GREEN :
			rgb_inst_ptr->rgb_hw_inst->ctl_g_reg &= (~MODE_MASK & mode);
			break;

		case BLUE :
			rgb_inst_ptr->rgb_hw_inst->ctl_b_reg &= (~MODE_MASK & mode);
			break;

	}

	return 0;
}


int axi_led_set_hold(rgb *rgb_inst_ptr, enum COLOR color){
	return 0;
}


int axi_led_set_unhold(rgb *rgb_inst_ptr, enum COLOR color){
	return 0;
}
