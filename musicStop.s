
	.include "include.inc" 
	.section .init
	.global musicStop
musicStop:
@-----データの保存-------------------------------------
backup:
 	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
stop:	
	@(PWM の動作モードを設定する)
	ldr	r12, =PWM_BASE		@ PWM を制御するためのレジスタのベースアドレス
	ldr	r11, =(0 << PWM_PWEN2)	@ PWEN2bit目まで1を左シフト
	ldr	r10, =(0 << PWM_MSEN2)	@ MSEN2bit目まで1を左シフト
	orr	r11, r11, r10		@ 合体
	str	r11, [r12, #PWM_CLT]	@ 
	
@-----終了--------------------------------------------	
return:
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	ldr	r10, [sp], #4		@ pop
	bx	r14
