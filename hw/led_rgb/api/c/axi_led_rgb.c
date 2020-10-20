#include "axi_led_rgb.h"


/*
 *
 * @author
 *      MasterPlayer
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param  - pointer of rgb driver struct
 * @param  - valid value which sets to ctl register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_ctl_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->ctl_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param  - pointer of rgb driver struct
 * @param  - valid value which sets to ctl_r register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_ctl_r_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->ctl_r_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param  - pointer of rgb driver struct
 * @param  - valid value which sets to duration_r register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_duration_r_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->duration_r_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param  - pointer of rgb driver struct
 * @param  - valid value which sets to ctl_g register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_ctl_g_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->ctl_g_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function sets value to hardware device
 * 
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param  - valid value which sets to duration_g register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_duration_g_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->duration_g_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param  - valid value which sets to ctl_b register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_ctl_b_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->ctl_b_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function sets value to hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - valid value which sets to duration_b register in device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_set_duration_b_reg(rgb *rgb_inst_ptr, uint32_t value){
    rgb_inst_ptr->rgb_hw_inst->duration_b_reg = value;
    return NO_ERR;
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_ctl_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->ctl_reg);
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_ctl_r_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->ctl_r_reg);
}

/*
 *
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_duration_r_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->duration_r_reg);
}

/*
 *
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_ctl_g_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->ctl_g_reg);
}
/*
 *
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_duration_g_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->duration_g_reg);
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_ctl_b_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->ctl_b_reg);
}
/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function get actual value from register in hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
uint32_t axi_led_rgb_get_duration_b_reg(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->rgb_hw_inst->duration_b_reg);
}


int axi_led_rgb_has_init(rgb *rgb_inst_ptr){
    return (rgb_inst_ptr->has_init);
}

/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Function initialize software structure and reset hardware device
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - baseaddr of address device
 *
 * @return
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_init(rgb *rgb_inst_ptr, uint32_t baseaddr){

    rgb_inst_ptr->rgb_hw_inst = baseaddr;
    rgb_inst_ptr->baseaddr = baseaddr;
    rgb_inst_ptr->has_init = 1;

    axi_led_rgb_reset(rgb_inst_ptr);

    return NO_ERR;

}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Resets hardware device and sets all parameters in zeroes
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_reset(rgb *rgb_inst_ptr){
    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }
    axi_led_rgb_set_ctl_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_reg(rgb_inst_ptr) & ~CTL_RESET_MASK);
    axi_led_rgb_set_ctl_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_reg(rgb_inst_ptr) | CTL_RESET_MASK);
    axi_led_rgb_set_ctl_r_reg(rgb_inst_ptr, 0);
    axi_led_rgb_set_ctl_g_reg(rgb_inst_ptr, 0);
    axi_led_rgb_set_ctl_b_reg(rgb_inst_ptr, 0);
    axi_led_rgb_set_duration_r_reg(rgb_inst_ptr, 0);
    axi_led_rgb_set_duration_g_reg(rgb_inst_ptr, 0);
    axi_led_rgb_set_duration_b_reg(rgb_inst_ptr, 0);
    return NO_ERR;
}



/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Restart all rgb with reset signal on control logic(resetting counters, modes, and current state)
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 *
 * @return
 *      NO_ERR if function execution complete
 *          NO INIT if no init device rgb_led
 *
 * @note
 *      might be used for one-time blinking of all leds.
 *      If ENABLE bit sets in zero, then LEDs disabled
 *
 * */
int axi_led_rgb_restart(rgb *rgb_inst_ptr){
    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }
    axi_led_rgb_set_ctl_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_reg(rgb_inst_ptr) & ~CTL_RESET_MASK);
    axi_led_rgb_set_ctl_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_reg(rgb_inst_ptr) | CTL_RESET_MASK);
    return NO_ERR;
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Return current status for selected LED 
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - mask for LED selection
 *
 * @return
 *      masked value of activity led : ACTIVE or INACTIVE
 *
 * @note
 *      none
 *
 * */
int axi_led_rgb_get_led_status(rgb *rgb_inst_ptr, uint8_t mask){
    if ((axi_led_rgb_get_ctl_reg(rgb_inst_ptr) & mask))
        return ACTIVE;
    else
        return INACTIVE;
}



/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      set freeze time(enabled and disabled states) for selected LED
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - Selected led color : RED | GREEN | BLUE
 * @param - duration in clock periods 
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      none
 *
 * */
int axi_led_set_duration(rgb *rgb_inst_ptr, enum LED_COLOR color, uint32_t duration){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color) {
        case RED:
            axi_led_rgb_set_duration_r_reg(rgb_inst_ptr, duration);
            break;

        case GREEN :
            axi_led_rgb_set_duration_g_reg(rgb_inst_ptr, duration);
            break;

        case BLUE :
            axi_led_rgb_set_duration_b_reg(rgb_inst_ptr, duration);
            break;

        default:
            return NO_LED_IN_GROUP;
            break;
    }
        return NO_ERR;
}


int axi_led_get_duration(rgb *rgb_inst_ptr, enum LED_COLOR color){
    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    uint32_t duration = 0;

    switch(color) {
    case RED :
        duration = axi_led_rgb_get_duration_r_reg(rgb_inst_ptr);
        break;
    case GREEN :
        duration = axi_led_rgb_get_duration_g_reg(rgb_inst_ptr);
        break;
    case BLUE :
        duration = axi_led_rgb_get_duration_b_reg(rgb_inst_ptr);
        break;
    default : return NO_LED_IN_GROUP;
    }
    return duration;
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      Enable selected led;
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - selected led color : RED | GREEN | BLUE
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      none
 *
 * */
int axi_led_set_enable(rgb *rgb_inst_ptr, enum LED_COLOR color){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color){
    case RED :
        axi_led_rgb_set_ctl_r_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) | ENABLE_MASK);
        break;

    case GREEN :
        axi_led_rgb_set_ctl_g_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) | ENABLE_MASK);
        break;

    case BLUE :
        axi_led_rgb_set_ctl_b_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) | ENABLE_MASK);
        break;

    default:
        return NO_LED_IN_GROUP;
        break;

    }
    return 0;
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      disable selected led;
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - selected led color : RED | GREEN | BLUE
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      none
 *
 * */
int axi_led_set_disable(rgb *rgb_inst_ptr, enum LED_COLOR color){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color){
    case RED :
        axi_led_rgb_set_ctl_r_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) & ~ENABLE_MASK);
        break;

    case GREEN :
        axi_led_rgb_set_ctl_g_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) & ~ENABLE_MASK);
        break;

    case BLUE :
        axi_led_rgb_set_ctl_b_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) & ~ENABLE_MASK);
        break;

    default :
        return NO_LED_IN_GROUP;
        break;
    }

    return 0;
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      select mode of work leds
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - selected led color : RED | GREEN | BLUE
 * @param - selected mode : LED_MODE_ON | LED_MODE_BLINK
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      LED_MODE_ON - LED emitting continues while ENABLE reg in device is asserted
 *      LED_MODE_BLINK - led blinks for DURATION value, where active_pause = inactive_pause
 *
 * */
int axi_led_set_mode(rgb *rgb_inst_ptr, enum LED_COLOR color, enum LED_MODE mode){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color){
        case RED :
            if (mode == LED_MODE_ON)
                axi_led_rgb_set_ctl_r_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) & ~MODE_MASK);
            else
                axi_led_rgb_set_ctl_r_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) | MODE_MASK);
            break;

        case GREEN :
            if (mode == LED_MODE_ON)
                axi_led_rgb_set_ctl_g_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) & ~MODE_MASK);
            else
                axi_led_rgb_set_ctl_g_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) | MODE_MASK);
            break;

        case BLUE :
            if (mode == LED_MODE_ON)
                axi_led_rgb_set_ctl_b_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) & ~MODE_MASK);
            else
                axi_led_rgb_set_ctl_b_reg( rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) | MODE_MASK);
            break;
        default :
            return NO_LED_IN_GROUP;
            break;
    }

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
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - selected led color : RED | GREEN | BLUE
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      none
 *
 * */
int axi_led_set_hold(rgb *rgb_inst_ptr, enum LED_COLOR color){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color){
        case RED :
            axi_led_rgb_set_ctl_r_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) | HOLDED_MASK);
            break;
        case GREEN :
            axi_led_rgb_set_ctl_g_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) | HOLDED_MASK);
            break;
        case BLUE :
            axi_led_rgb_set_ctl_b_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) | HOLDED_MASK);
            break;
        default :
            return NO_LED_IN_GROUP;
            break;
    }
    return NO_ERR;
}


/*
 * @author
 *      MasterPlayer
 *
 * @description 
 *      
 *
 * @date
 *      20.10.2020
 *
 * @param - pointer of rgb driver struct
 * @param - selected led color : RED | GREEN | BLUE
 *
 * @return
 *      NO INIT if no init device rgb_led
 *      NO_ERR if function execution complete
 *      NO_LED_IN_GROUP if color not presented in list
 *
 * @note
 *      none
 *
 * */
int axi_led_set_unhold(rgb *rgb_inst_ptr, enum LED_COLOR color){

    if (!axi_led_rgb_has_init(rgb_inst_ptr)) {
        return NO_INIT;
    }

    switch (color){

        case RED :
            axi_led_rgb_set_ctl_r_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_r_reg(rgb_inst_ptr) & ~HOLDED_MASK);
            break;

        case GREEN :
            axi_led_rgb_set_ctl_g_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_g_reg(rgb_inst_ptr) & ~HOLDED_MASK);
            break;

        case BLUE :
            axi_led_rgb_set_ctl_b_reg(rgb_inst_ptr, axi_led_rgb_get_ctl_b_reg(rgb_inst_ptr) & ~HOLDED_MASK);
            break;

        default :
            return NO_LED_IN_GROUP;
            break;
        }
    return NO_ERR;
}
