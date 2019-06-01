@======システム上の定数===================================================================
	.equ    PWM_HZ, 9600 * 1000
	.equ	GPIO_BASE,	0x3f200000	@ GPIOベースアドレス
	.equ	CM_BASE, 	0x3f101000	@クロックソースのベースアドレス
	.equ	PWM_BASE, 	0x3f20c000	@PWM を制御するためのレジスタのベースアドレス
	.equ	GPFSEL_VEC0,		0x01201000		@ GPFSEL0 に設定する値 (GPIO #4, #7, #8 を出力用に設定)
	.equ	GPFSEL_VEC1,		0x11249041		@ GPFSEL1 に設定する値 (GPIO #10, #12, #14, #15, #16, #17, #18 を出力用に設定)
	.equ	GPFSEL_VEC2,		0x00209249		@ GPFSEL2 に設定する値 (GPIO #20, #21, #22,#23, #24, #25, #27 を出力用に設定)
	.equ	CM_PWMCTL, 	0xa0
	.equ	CM_PWMDIV, 	0xa4
	.equ	GPFSEL_VEC0,	0x0
	.equ	GPFSEL_VEC1,	0x10000001	@ GPFSEL1 に設定する値 (GPIO #10 , #19 を出力用に設定)
	.equ	GPSET0,	0x1C			@ GPIOポートの出力値を1にするための番地のオフセット
	.equ	GPFSEL_VEC2,	0x0
	.equ	PWM_CLT, 	0x0
	.equ	PWM_PWEN2, 	8
	.equ	PWM_MSEN2, 	15
	.equ	PWM_RNG2, 	0x20
	.equ	PWM_DAT2, 	0x24
	.equ	LED_PORT,   10           @ LEDが接続されたGPIOのポート番号
	.equ	TIMER_BASE, 0x3f003000		@ システムタイマの制御レジスタのベースアドレス
	.equ	CLO,	 0x4			@ システムタイマの下位32bitを示すオフセット
	.equ	TIME1, 5000000
	.equ 	LED_PORT,   	10           @ LEDが接続されたGPIOのポート番号
	.equ	BYTE,			8			@ 8bit=1Byte
	.equ	STACK, 			0x8000			@ スタックポインタ
@======システム上の定数===================================================================
	.include "include.inc" 
	.section .init
	.global _start
_start:

@-----役固定レジスタ------------------------------------------
	ldr	r0, =GPIO_BASE			@ ベースアドレス
	mov	sp, #STACK			@ スタックポインタ
@------初期設定----------------------------------------------

@======ここからテンプレ===============================================================================================================
	@(GPIO #19 を含め，GPIOの用途を設定する)
	@ LEDとディスプレイ用のIOポートを出力に設定する
	ldr	r0, =GPIO_BASE
	ldr	r11, =GPFSEL_VEC0
	str	r11, [r0, #GPFSEL0]
	ldr	r11, =GPFSEL_VEC1
	str	r11, [r0, #GPFSEL0 + 4]
	ldr	r11, =GPFSEL_VEC2
	str	r11, [r0, #GPFSEL0 + 8]
	
@-----(PWM のクロックソースを設定する)-------------------------------------------
	@ Set PWM clock source
	@src = osc, divider = 2.0
	
	ldr     r12, =CM_BASE
	ldr     r11, =0x5a000021                     @  src = osc, enable=false
	str     r11, [r12, #CM_PWMCTL]

1:    @ wait for busy bit to be cleared
	ldr     r11, [r12, #CM_PWMCTL]
	tst     r11, #0x80
	bne     1b

	ldr     r11, =(0x5a000000 | (2 << 12))  @ div = 2.0
	str     r11, [r12, #CM_PWMDIV]
	ldr     r11, =0x5a000211                   @ src = osc, enable=true
	str     r11, [r12, #CM_PWMCTL]
@----------------==-=-==-===-=-=-==-=-=-==-==---==-==-=-=-=--==-=-=-==-=-=-

	@(PWM の動作モードを設定する)
	ldr	r12, =PWM_BASE		@ PWM を制御するためのレジスタのベースアドレス
	ldr	r11, =(1 << PWM_PWEN2)	@ PWEN2bit目まで1を左シフト
	ldr	r10, =(1 << PWM_MSEN2)	@ MSEN2bit目まで1を左シフト
	orr	r11, r11, r10		@ 合体
	str	r11, [r12, #PWM_CLT]
@======ここまでテンプレ===============================================================================================================
@======taskSet_play==================================================================================
taskSet_play:					@ loopここから
@------画面出力-----------------------------------------
	bl	bad_pv
@------音声出力-----------------------------------------
	bl	bad_music
@------taskSet_play loop--------------------------------------	
	b	taskSet_play			@ taskをloopさせて、それぞれのtaskを判定させる
	
@======safety================================================
safety_loop:
	b	safety_loop			@ 万一のためのloop
	
