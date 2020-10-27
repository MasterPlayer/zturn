#ifndef SRC_AXI_SW_CTRLR_H_
#define SRC_AXI_SW_CTRLR_H_

#include <stdint.h>

typedef struct axi_sw_ctrlr_hw{
	uint32_t ctl_reg;
	uint32_t state_reg;
	uint32_t mask_reg;
	uint32_t event_reg;
}axi_sw_ctrlr_hw;

typedef struct axi_sw_ctrlr{
	uint32_t baseaddr;
	uint32_t has_init;
	axi_sw_ctrlr_hw *axi_sw_ctrlr_hw_inst_ptr;
}axi_sw_ctrlr;

#define CTL_ENABLE_IRQ_MASK 0x00000001

enum SW_MASK {
	SW0_MASK = 0x00000001,
	SW1_MASK = 0x00000002,
	SW2_MASK = 0x00000004,
	SW3_MASK = 0x00000008,
};

enum ERR_LOG {
	NO_ERR = 0,
	NO_INIT = -1,
};

int axi_sw_ctrlr_set_ctl_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr, uint32_t value);
int axi_sw_ctrlr_set_mask_reg(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t value);
int axi_sw_ctrlr_set_event_reg(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t value);

uint32_t axi_sw_ctrlr_get_ctl_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr);
uint32_t axi_sw_ctrlr_get_state_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr);
uint32_t axi_sw_ctrlr_get_mask_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr);
uint32_t axi_sw_ctrlr_get_event_reg(axi_sw_ctrlr * axi_sw_ctrlr_inst_ptr);

int axi_sw_ctrlr_init(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, uint32_t baseaddr);

int axi_sw_ctrlr_has_init(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr);

/*hilevel functions for control register*/
int axi_sw_ctrlr_enable_irq(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr);
int axi_sw_ctrlr_disable_irq(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr);

int axi_sw_ctrlr_get_state(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);
int axi_sw_ctrlr_has_asserted(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);

/*hilevel functions for mask register*/
int axi_sw_ctrlr_set_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);
uint32_t axi_sw_ctrlr_get_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr);
int axi_sw_ctrlr_has_enabled_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);

uint32_t axi_sw_ctrlr_get_event_mask(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr);
uint32_t axi_sw_ctrlr_has_switched(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);
uint32_t axi_sw_ctrlr_event_ack(axi_sw_ctrlr *axi_sw_ctrlr_inst_ptr, enum SW_MASK sw_mask);





#endif /* SRC_AXI_SW_CTRLR_H_ */
