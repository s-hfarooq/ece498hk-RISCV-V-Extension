# ece498hk-RISCV-V-Extension

![block diagram](imgs/block-diagram.jpg)


## MMU
![MMU block diagram](imgs/mmu-block-diagram.png)

External storage will be on SPI flash memory. For example, [this](https://www.mouser.com/ProductDetail/Microchip-Technology-Atmel/SST26VF040AT-104I-SN?qs=vmHwEFxEFR8%252BmQlv%252BpDlqw%3D%3D) 4Mb module. This will only store instructions. It will be seen as read-only by the main core. On chip SRAM will be used as scratch memory. 

External storage will be flashed through our chip. Will have 2 more pins that if shorted on reset will put the chip in programming mode - this is when SPI is connected directly to offboard storage via the storage controller 

Another 2 pins that if shorted on reset will put it into debug mode - this is when addr/data that ibex requests is also outputted via SPI. SRAM can also be dumped in this mode. 


### Memory addresses

| Address Range              | Device                |
| -------------------------- | --------------------- |
| 0x0000_0000 - 0x0000_0100  | Reserved              |
| 0x0000_0101 - 0x0000_010A  | GPIO                  |
| 0x0000_010B                | Digital Timer         |
| 0x0000_010C - 0x0000_0FFF  | Reserved              |
| 0x0000_1000 - 0x0000_1FFF  | SRAM Scratch Memory   |
| 0x0000_2000 - 0xFFFF_FFFF  | External Storage      |


**TODO:** change cache in ibex/vicuna to always fetch for addresses 0x0000_0000-0x0000_0FFF. 

## Divider
Vector division

## SRAM Register File
