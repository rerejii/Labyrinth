
	.include "include.inc" 
	.section .init
	.global musicStop
musicStop:
@-----�ǡ�������¸-------------------------------------
backup:
 	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
stop:	
	@(PWM ��ư��⡼�ɤ����ꤹ��)
	ldr	r12, =PWM_BASE		@ PWM �����椹�뤿��Υ쥸�����Υ١������ɥ쥹
	ldr	r11, =(0 << PWM_PWEN2)	@ PWEN2bit�ܤޤ�1�򺸥��ե�
	ldr	r10, =(0 << PWM_MSEN2)	@ MSEN2bit�ܤޤ�1�򺸥��ե�
	orr	r11, r11, r10		@ ����
	str	r11, [r12, #PWM_CLT]	@ 
	
@-----��λ--------------------------------------------	
return:
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	ldr	r10, [sp], #4		@ pop
	bx	r14
