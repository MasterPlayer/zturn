#include "axi_sw_ctrlr.h"


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_set_ctl_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr, uint32_t value){
	axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->ctl_reg = value;
	return NO_ERR;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_set_mask_reg(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t value){
	axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->mask_reg = value;
	return NO_ERR;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_set_event_reg(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t value){
	axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->event_reg = value;
	return NO_ERR;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_ctl_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr){
	return axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->ctl_reg;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_state_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr){
	return axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->state_reg;
}



/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_mask_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr){
	return axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->mask_reg;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_event_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr){
	return axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr->event_reg;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_init(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t baseaddr){
	axi_sw_ctrlr_inst_ptr->baseaddr = baseaddr;
	axi_sw_ctrlr_inst_ptr->axi_sw_ctrlr_hw_inst_ptr = baseaddr;
	axi_sw_ctrlr_inst_ptr->has_init = 1;

	axi_sw_ctrlr_set_ctl_reg(axi_sw_ctrlr_inst_ptr, 0);
	axi_sw_ctrlr_set_mask_reg(axi_sw_ctrlr_inst_ptr, 0);

	axi_sw_ctrlr_set_event_reg(axi_sw_ctrlr_inst_ptr, axi_sw_ctrlr_get_event_reg(axi_sw_ctrlr_inst_ptr));
	return NO_ERR;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_enable_irq(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr)) {
		return NO_INIT;
	}

	axi_sw_ctrlr_set_ctl_reg(axi_sw_ctrlr_inst_ptr, axi_sw_ctrlr_get_ctl_reg(axi_sw_ctrlr_inst_ptr) | CTL_ENABLE_IRQ_MASK);
	return NO_ERR;
}

int axi_sw_ctrlr_has_init(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr){
	return axi_sw_ctrlr_inst_ptr->has_init;
}

/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_disable_irq(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	axi_sw_ctrlr_set_ctl_reg(axi_sw_ctrlr_inst_ptr, axi_sw_ctrlr_get_ctl_reg(axi_sw_ctrlr_inst_ptr) & ~CTL_ENABLE_IRQ_MASK);

	return NO_ERR;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_get_state(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr)){
		return NO_INIT;
	}

	return (axi_sw_ctrlr_get_state_reg(axi_sw_ctrlr_inst_ptr) & sw_mask);
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_has_asserted(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	int assertion_flaq = 0;

	if (axi_sw_ctrlr_get_state(axi_sw_ctrlr_inst_ptr, sw_mask)){
		assertion_flaq = 1;
	}
	else{
		assertion_flaq = 0;
	}
	return assertion_flaq;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_set_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	int status = axi_sw_ctrlr_set_mask_reg(axi_sw_ctrlr_inst_ptr, (uint32_t)sw_mask);
	return status;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;
	return axi_sw_ctrlr_get_mask_reg(axi_sw_ctrlr_inst_ptr);
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
int axi_sw_ctrlr_has_enabled_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	int has_enabled_mask = 0;

	if ((axi_sw_ctrlr_get_mask(axi_sw_ctrlr_inst_ptr) & (uint32_t)sw_mask))
		has_enabled_mask = 1;

	return has_enabled_mask;
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_get_event_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	return axi_sw_ctrlr_get_event_reg(axi_sw_ctrlr_inst_ptr);

}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_has_switched(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	return (axi_sw_ctrlr_get_event_mask(axi_sw_ctrlr_inst_ptr) & (uint32_t)sw_mask);
}


/*
 *
 * @author
 *      MasterPlayer
 *
 * @description
 *
 *
 * @date
 *      23.10.2020
 *
 * @param  - pointer of
 * @param  -
 *
 * @return
 *
 *
 * @note
 *      none
 *
 * */
uint32_t axi_sw_ctrlr_event_ack(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask){
	if (!axi_sw_ctrlr_has_init(axi_sw_ctrlr_inst_ptr))
		return NO_INIT;

	return (axi_sw_ctrlr_set_event_reg(axi_sw_ctrlr_inst_ptr, (uint32_t)sw_mask));
}
