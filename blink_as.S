# MIK32
# EEPROM - 8K RAM - 16K


###
# For RISC-V simulator "QtRVSim" 
# Directives to make interesting windows visible
#pragma qtrvsim show terminal
#pragma qtrvsim show registers
#pragma qtrvsim show memory
###

.globl _start
.globl __start
.option norelax

# #define RAM_BASE_ADDRESS                    0x02000000
# #define RAM_SIZE                            (16*1024)

# #define PM_BASE_ADDRESS                     0x00050000
# #define PAD_CONFIG_BASE_ADDRESS             0x00050c00
# #define GPIO_0_BASE_ADDRESS                 0x00084000
# #define GPIO_1_BASE_ADDRESS                 0x00084400
# #define GPIO_2_BASE_ADDRESS                 0x00084800
# #define GPIO_IRQ_BASE_ADDRESS               0x00084C00
#    typedef struct
#    {   
#
#        volatile uint32_t DIV_AHB;				# PM_BASE_ADDRESS + 0x00 (00)
#        volatile uint32_t DIV_APB_M;			# PM_BASE_ADDRESS + 0x04 (04)
#        volatile uint32_t DIV_APB_P;			# PM_BASE_ADDRESS + 0x08 (08)
#        volatile uint32_t CLK_AHB_SET;			# PM_BASE_ADDRESS + 0x0C (12)
#        volatile uint32_t CLK_AHB_CLEAR;		# PM_BASE_ADDRESS + 0x10 (16)
#        volatile uint32_t CLK_APB_M_SET;		# PM_BASE_ADDRESS + 0x14 (20)
#        volatile uint32_t CLK_APB_M_CLEAR;		# PM_BASE_ADDRESS + 0x18 (24)
#        volatile uint32_t CLK_APB_P_SET;		# PM_BASE_ADDRESS + 0x1C (28)
#        volatile uint32_t CLK_APB_P_CLEAR;		# PM_BASE_ADDRESS + 0x20 (32)
#        volatile uint32_t AHB_CLK_MUX;			# PM_BASE_ADDRESS + 0x24 (36)
#        volatile uint32_t WDT_CLK_MUX;			# PM_BASE_ADDRESS + 0x28 (40)
#        volatile uint32_t CPU_RTC_CLK_MUX;		# PM_BASE_ADDRESS + 0x2C (44)
#        volatile uint32_t TIMER_CFG;			# PM_BASE_ADDRESS + 0x30 (48)
#        volatile uint32_t FREQ_MASK;			# PM_BASE_ADDRESS + 0x34 (52)
#        volatile uint32_t FREQ_STATUS;			# PM_BASE_ADDRESS + 0x38 (56)
#        volatile uint32_t SLEEP_MODE;			# PM_BASE_ADDRESS + 0x3C (60)
#
#    } PM_TypeDef;
# #define PAD_CONFIG      (( PAD_CONFIG_TypeDef       *)  PAD_CONFIG_BASE_ADDRESS     )	# 0x000050c00
#    typedef struct
#    {
#        volatile uint32_t PORT_0_CFG;			# PAD_CONFIG_BASE_ADDRESS + 0x00 (0)
#        volatile uint32_t PORT_1_CFG;			# PAD_CONFIG_BASE_ADDRESS + 0x04 (4)
#        volatile uint32_t PORT_2_CFG;			# PAD_CONFIG_BASE_ADDRESS + 0x08 (8)
#    } PAD_CONFIG_TypeDef;

# #define PM_CLOCK_GPIO_2_S       14
# #define PM_CLOCK_GPIO_2_M       (1 << PM_CLOCK_GPIO_2_S)			# 0b0100000000000000 = 0x4000
# #APB M BUS
# #define PM_CLOCK_PM_S               0
# #define PM_CLOCK_PM_M               (1 << PM_CLOCK_PM_S)			# 0b1 = 0x01
# #define PM_CLOCK_PAD_CONFIG_S       3
# #define PM_CLOCK_PAD_CONFIG_M       (1 << PM_CLOCK_PAD_CONFIG_S)	# 0b1000 = 0x08
# #define PM_CLOCK_WU_S               7
# #define PM_CLOCK_WU_M               (1 << PM_CLOCK_WU_S)			# 0b10000000 = 0x80

# #define GPIO_STATE				0x00 
# #define GPIO_SET					0x00 
# #define GPIO_CLEAR				0x04 
# #define GPIO_DIRECTION_OUT		0x08 
# #define GPIO_DIRECTION_IN			0x0C 
# #define GPIO_OUTPUT				0x10
# #define GPIO_CONTROL				0x14 
#    typedef struct
#    {
#        volatile uint32_t SET;					# GPIO_X_BASE_ADDRESS + 0x00 (00)
#        volatile uint32_t CLEAR;				# GPIO_X_BASE_ADDRESS + 0x04 (04)
#        volatile uint32_t DIRECTION_OUT;		# GPIO_X_BASE_ADDRESS + 0x08 (08)
#        volatile uint32_t DIRECTION_IN;		# GPIO_X_BASE_ADDRESS + 0x0C (12)
#        volatile uint32_t OUTPUT;				# GPIO_X_BASE_ADDRESS + 0x10 (16)
#        volatile uint32_t CONTROL;				# GPIO_X_BASE_ADDRESS + 0x14 (20)
#        
#    } GPIO_TypeDef;
# #define GPIO_0          (( GPIO_TypeDef             *)  GPIO_0_BASE_ADDRESS         )	# 0x00084000
# #define GPIO_1          (( GPIO_TypeDef             *)  GPIO_1_BASE_ADDRESS         )	# 0x00084400
# #define GPIO_2          (( GPIO_TypeDef             *)  GPIO_2_BASE_ADDRESS         )	# 0x00084800
# #define GPIO_IRQ        (( GPIO_IRQ_TypeDef         *)  GPIO_IRQ_BASE_ADDRESS       )	# 0x00084C00

.equ RAM_BASE_ADDRESS,      0x02000000
.equ RAM_END_ADDRESS,       0x02004000
.equ PM_BASE_ADDRESS,       0x00050000
.equ PAD_CONFIG,            0x00050c00
.equ PM_CLOCK_GPIO_2_M,     0x4000				# 0b0100000000000000
.equ PM_CLOCK_PM_M,         0x01				# 0b1
.equ PM_CLOCK_PAD_CONFIG_M, 0x08				# 0b1000
.equ PM_CLOCK_WU_M,         0x80				# 0b10000000
.equ PORT_0_CFG,            0x00
.equ PORT_1_CFG,            0x04
.equ PORT_2_CFG,            0x08
.equ GPIO_0,                0x00084000
.equ GPIO_1,                0x00084400
.equ GPIO_2,                0x00084800
.equ DIRECTION_OUT,         0x08
.equ DIRECTION_IN,          0x0C
.equ GPIO_OUTPUT,           0x10

.equ PIN_LED2,           7			# LED2 управляется выводом PORT_2_7
.equ PIN_button,         6			# LED2 управляется выводом PORT_2_6
.equ delay1,        100000			# delay 100000 times

# CL_SIZE = 0x20 (32)

_start:
#00000000 <_start>:
	la   sp, RAM_END_ADDRESS		# sp <- end of RAM (0x2000000 + 16K)
	la   gp, RAM_BASE_ADDRESS		# gp <- start of RAM (0x2000000)
	li   a1, 0xc80		# c80 <__TEXT_END__>
	li   a2, 0xc80		# c80 <__TEXT_END__>
	la   a3, RAM_BASE_ADDRESS
	j    m1_2	#0x23c	#0x200+0x32	#32 #<CL_SIZE+0x12>
m1_1:
	lw   t0, 0(a1)
	sw   t0, 0(a3) # 2000000 <__DATA_START__>
	addi a1, a1, 4
	addi a3, a3, 4
m1_2:
	bltu a1, a2, m1_1	#26 #<CL_SIZE+0x6> bltu - unsigned blt - signed
	la   a1, RAM_BASE_ADDRESS
	la   a2, RAM_BASE_ADDRESS + 32
	j    m1_4	#0x4e #<CL_SIZE+0x2e>
m1_3:
	# clear memory 0x2000000 - 0x2000032
	sw   zero, 0(a1) # 2000000 <__DATA_START__>
	addi a1, a1, 4
m1_4:
	bltu a1, a2, m1_3	#48 #<CL_SIZE+0x28>
	call main # b4a <main>
	ret

main:
#00000b4a <main>:
	addi sp, sp, -16
	sw   ra, 12(sp)
	call initClock
	la   a5, PAD_CONFIG
	lw   a4, 0(a5) # 50c08 <__TEXT_END__+0x4ff88>
	la   a3, 0x4000		# (1 << (2 * PIN_LED2))
	or   a4, a4, a3		# (a4) | (1 << (2 * PIN_LED2)); // Установка порта 2 в режим GPIO
	sw   a4, 0(a5)
	lw   a4, 0(a5)
	la   a3, 0x1000		# (1 << (2 * PIN_button))
	or   a4, a4, a3		# (a4) | (1 << (2 * PIN_button)); // Установка порта 2 в режим GPIO
	sw   a4, 0(a5)
	la   a5, GPIO_2		# 0x84800
	li   a4, 128		# 1 << PIN_LED2
	sw   a4, 8(a5)		# GPIO_2 + DIRECTION_OUT (84808 <__TEXT_END__+0x83b88>)
	li   a4, 64			# 1 << PIN_button
	sw   a4, 12(a5)		# GPIO_2 + DIRECTION_IN  (8480C)
m2_1:
	call ledBlink
	j    m2_1

initClock:
#00000182 <initClock>:
	la   a5, PM_BASE_ADDRESS
	lw   a4, 28(a5)				# a4 <- [PM_BASE_ADDRESS + CLK_APB_P_SET]
	lui  a3, 0x4				# a3 <- PM_CLOCK_GPIO_2_M (0x4000)
	addi sp, sp, -16			# sp <- sp - 16
	or   a4, a4, a3				# a4 <- a4 | a3
	sw   a4, 28(a5)				# [PM_BASE_ADDRESS + CLK_APB_P_SET] <- a4
	lw   a4, 20(a5)				# a4 <- [PM_BASE_ADDRESS + CLK_APB_M_SET]
	ori  a4, a4, 137			# 137 = PM_CLOCK_PAD_CONFIG_M | PM_CLOCK_WU_M | PM_CLOCK_PM_M = 0b10001001 = 0x89
	sw   a4, 20(a5)				# [PM_BASE_ADDRESS + CLK_APB_M_SET] <- a4
	sw   zero, 12(sp)			# [sp + 12] <- 0
	# for (volatile int i = 0; i < 10; i++)
	li   a4, 9
m3_1:
	lw   a5, 12(sp)				# a5 <- [sp + 12]
	bge  a4, a5, m3_2
	addi sp, sp, 16				# sp <- sp + 16
	ret
m3_2:
	lw   a5, 12(sp)				# a5 <- [sp + 12]
	addi a5, a5, 1				# a5 <- a5 + 1
	sw   a5, 12(sp)				# [sp + 12] <- a5
	j    m3_1

ledBlink:
#000001ae <ledBlink>:
	la   a5, GPIO_2 + GPIO_OUTPUT
	lw   a4, 0(a5)
	addi sp, sp, -32
	sw   ra, 28(sp)
	ori  a4, a4, 128		# 1 << PIN_LED2
	sw   a4, 0(a5)
	li   a5, delay1
	sw   zero, 8(sp)
m4_1:
	lw   a4, 8(sp)
	bge  a5, a4, m4_3
	la   a5, GPIO_2 + GPIO_OUTPUT
	lw   a4, 0(a5)
	andi a4, a4, -129		# ~(1 << PIN_LED2)
	sw   a4, 0(a5)
	li   a5, delay1
	sw   zero, 12(sp)
m4_2:
	lw   a4, 12(sp)
	bge  a5, a4, m4_4
	lw   ra, 28(sp)
	addi sp, sp,32
	ret
m4_3:
	lw   a4, 8(sp)
	addi a4, a4, 1
	sw   a4, 8(sp)
	j    m4_1
m4_4:
	lw   a4, 12(sp)
	addi a4, a4, 1
	sw   a4, 12(sp)
	j    m4_2

