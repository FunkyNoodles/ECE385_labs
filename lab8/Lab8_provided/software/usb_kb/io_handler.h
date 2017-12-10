#ifndef IO_HANDLER_H_
#define IO_HANDLER_H_
#include "alt_types.h"

#define OTG_HPI_ADDRESS_BASE 0x0050
#define OTG_HPI_DATA_BASE 0x0040
#define OTG_HPI_R_BASE 0x0030
#define OTG_HPI_CS_BASE 0x0060
#define OTG_HPI_W_BASE 0x0020

void IO_write(alt_u8 Address, alt_u16 Data);
alt_u16 IO_read(alt_u8 Address);
void IO_init(void);


#endif
