@ ���ꥢ�ʡ���Flagpole Fanfare��~�����ѡ��ޥꥪ���~
	
@======�����ƥ������===================================================================
	.equ    PWM_HZ, 9600 * 1000
	.equ	GPIO_BASE,	0x3f200000	@ GPIO�١������ɥ쥹
	.equ	CM_BASE, 	0x3f101000	@����å��������Υ١������ɥ쥹
	.equ	PWM_BASE, 	0x3f20c000	@PWM �����椹�뤿��Υ쥸�����Υ١������ɥ쥹
	.equ	GPFSEL0,	0x00		@ GPIO�ݡ��Ȥε�ǽ�����򤹤����ϤΥ��ե��å�
	.equ	GPSET0,		0x1C		@ GPIO�ݡ��Ȥν����ͤ�1�ˤ��뤿������ϤΥ��ե��å�
	.equ	GPCLR0,		0x28		@ GPIO�ܡ��Ȥν����ͤ�0�ˤ��뤿������ϤΥ��ե��å�
	.equ	CM_PWMCTL, 	0xa0
	.equ	CM_PWMDIV, 	0xa4
	.equ	GPFSEL_VEC0,	0x0
	.equ	GPFSEL_VEC1,	0x10000001	@ GPFSEL1 �����ꤹ���� (GPIO #10 , #19 ������Ѥ�����)
	.equ	GPSET0,	0x1C			@ GPIO�ݡ��Ȥν����ͤ�1�ˤ��뤿������ϤΥ��ե��å�
	.equ	GPFSEL_VEC2,	0x0
	.equ	PWM_CLT, 	0x0
	.equ	PWM_PWEN2, 	8
	.equ	PWM_MSEN2, 	15
	.equ	PWM_RNG2, 	0x20
	.equ	PWM_DAT2, 	0x24
	.equ	LED_PORT,   10           @ LED����³���줿GPIO�Υݡ����ֹ�
	.equ	TIMER_BASE, 0x3f003000		@ �����ƥॿ���ޤ�����쥸�����Υ١������ɥ쥹
	.equ	CLO,	 0x4			@ �����ƥॿ���ޤβ���32bit�򼨤����ե��å�
	.equ	TIME1, 5000000
	.equ 	LED_PORT,   	10           @ LED����³���줿GPIO�Υݡ����ֹ�
	.equ	BYTE,			8			@ 8bit=1Byte
@======�����ƥ������===================================================================

@======���ȿ����===================================================================
	.equ	KEY_So0, 195	@ ��1������
	.equ	KEY_Raf, 207	@ ���
	.equ	KEY_Sif, 233	@ ����
	.equ	KEY_Do, 261	@ ��
	.equ	KEY_Re, 293	@ ��
	.equ	KEY_Mif, 311	@ �ߢ�
	.equ	KEY_Mi, 329	@ ��
	.equ	KEY_Fa, 349	@ �ե�
	.equ	KEY_So, 391	@ ��
	.equ	KEY_Raf1, 415	@ ���1������
	.equ	KEY_Sif1, 466	@ ����1������
	.equ	KEY_Do1, 523	@ ��1������
	.equ	KEY_Re1, 587	@ ��1������
	.equ	KEY_Mif1, 622	@ �ߢ�1������
	.equ	KEY_Mi1, 659	@ ��1������
	.equ	KEY_Fa1, 698	@ �ե�1������
	.equ	KEY_So1, 783	@ ��1������
	.equ	KEY_Raf2, 830	@ ���2������
	.equ	KEY_Ra2, 876	@ ��2������
	.equ	KEY_Sif2, 931	@ ����2������
	.equ	KEY_Si2, 986	@ ��2������
	.equ	KEY_Do2, 1045	@ ��2������
@======���ȿ����===================================================================

	
	.section .init
	.global _start
_start:

@------���ư��-----------------------------------
first_task:
	ldr	r12, =first_flag		@ r12��first_flag������
	ldrb	r11, [r12]			@ �����ư�Υե饰�����
	cmp	r11, #1				@ ���Ƥε�ư��?
	bne	first_end			@ ��λ
	mov	r11, #0				@ 0��Ǽ
	strb	r11, [r12]			@ �ե饰���ޤ�

	mov	r12, #3				@ loop�������
	ldr	r11, =music_data		@ music_data�����ϼ���
	mov	r10, #0				@ �����
	ldr	r8, =read_point			@ �ɤ߹���ǡ����ֹ������
	ldrb	r8, [r8]			@ �ɤ߹���ǡ����ֹ���ֹ��������
	mov	r8, r8, lsl #3			@ 8�ܤ��ƺ�ɸ�����
	add	r8, r8, #4			@ music_data��ή�����֤κ�ɸ�����
1:
	add	r9, r12, r8			@ ��ɸ�򻻽�
	ldrb	r9, [r11, r9]			@ �������
	add	r10, r10, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r10, r10, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
	
	ldr	r12, =TIMER_BASE		@ �����ƥॿ���ޤΥ١������ɥ쥹
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + ���ե��å�)���Ϥ����ɤ߽Ф�
	
	add	r10, r10, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_sound		@ time_sound�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop
first_end:	

@======��������ƥ�ץ�===============================================================================================================
	@(GPIO #19 ��ޤᡤGPIO�����Ӥ����ꤹ��)
	@ LED�ȥǥ����ץ쥤�Ѥ�IO�ݡ��Ȥ���Ϥ����ꤹ��
	ldr	r0, =GPIO_BASE
	ldr	r11, =GPFSEL_VEC0
	str	r11, [r0, #GPFSEL0]
	ldr	r11, =GPFSEL_VEC1
	str	r11, [r0, #GPFSEL0 + 4]
	ldr	r11, =GPFSEL_VEC2
	str	r11, [r0, #GPFSEL0 + 8]
	
@-----(PWM �Υ���å������������ꤹ��)-------------------------------------------
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

	@(PWM ��ư��⡼�ɤ����ꤹ��)
	ldr	r12, =PWM_BASE		@ PWM �����椹�뤿��Υ쥸�����Υ١������ɥ쥹
	ldr	r11, =(1 << PWM_PWEN2)	@ PWEN2bit�ܤޤ�1�򺸥��ե�
	ldr	r10, =(1 << PWM_MSEN2)	@ MSEN2bit�ܤޤ�1�򺸥��ե�
	orr	r11, r11, r10		@ ����
	str	r11, [r12, #PWM_CLT]
@======�����ޤǥƥ�ץ�===============================================================================================================

	

@------�����ޡ�ư��-----------------------------------
check_time_sound:
@------time_sound����------
	ldr	r11, =time_sound		@ time_sound�����ϼ���
	mov	r10, #0				@ �����
	mov	r12, #0				@ loop�����

1:
	ldrb	r9, [r11, r12]			@ �������
	add	r10, r10, r9			@ ­��
	cmp	r12, #3				@ looe_end?
	addne	r12, r12, #1			@ ������ȥ�����
	movne	r10, r10, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
	
	ldr	r12, =TIMER_BASE		@ �����ƥॿ���ޤΥ١������ɥ쥹
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + ���ե��å�)���Ϥ����ɤ߽Ф�
	cmp	r12, r10			@ ���֤�Ƚ��
	bcc	check_time_sound_end		@ ��ư���֤����äƤʤ���н�λ
@------read_point����------
	mov	r12, #3				@ loop�������
	ldr	r11, =read_point		@ �ɤ߹���ǡ����ֹ��ɸ
	mov	r8, #0				@ �����
1:
	ldrb	r9, [r11, r12]			@ �������
	add	r8, r8, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r8, r8, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
@������r8��read_point���ͤ���Ǽ�����
	mov	r12, #3				@ loop�������
	ldr	r11, =music_size		@ �ɤ߹���ǡ����ֹ��ɸ
	mov	r7, #0				@ �����
1:
	ldrb	r9, [r11, r12]			@ �������
	add	r7, r7, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r7, r7, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
@������r7��music_size���ͤ���Ǽ�����
	add	r8, r8, #1			@ r8���ͤ�1��­��(point��ʤ��)
	cmp	r8, r7				@ �ǡ����κǸ�ޤǤ��ä���?
@++++++�����ǡ��Ǹ�ޤǹԤä��ݤν������++++++
	moveq	r8, #0				@ �Ǹ�ޤǹԤä���ǽ��loop
@read_point�򹹿�
	mov	r12, #0				@ loop�������
	ldr	r11, =read_point		@ �񤭹���ǡ����ֹ��ɸ
1:
	strb	r8, [r11, r12]			@ �ͤ򹹿�
	cmp	r12, #3				@ loop����λ������?
	addne	r12, r12, #1			@ loop������ȥ��å�
	movne	r8, r8, lsr #BYTE		@ �񤭹��߽���ä�bit�򤺤餹
	bne	1b				@ loop
@------music_data->time����------
	mov	r12, #3				@ loop�������
	ldr	r11, =read_point		@ �ɤ߹���ǡ����ֹ��ɸ
	mov	r8, #0				@ �����
1:
	ldrb	r9, [r11, r12]			@ �������
	add	r8, r8, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r8, r8, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
	
	mov	r12, #3				@ loop�������
	ldr	r11, =music_data		@ music_data�����ϼ���
	mov	r7, #0				@ �����
	mov	r8, r8, lsl #3			@ 8�ܤ��ƺ�ɸ�����
	add	r8, r8, #4			@ music_data��ή�����֤κ�ɸ�����
1:
	add	r9, r12, r8			@ ��ɸ�򻻽�
	ldrb	r9, [r11, r9]			@ �������
	add	r7, r7, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r7, r7, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
@------time_sound����------	
	add	r10, r10, r7			@ time��׻���
	ldr	r11, =time_sound		@ time_sound�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop
	
check_time_sound_end:	
@------�����ޡ�ư��end-----------------------------------

	
@------music_data�μ������ϻ���------
	mov	r12, #3				@ loop�������
	ldr	r11, =read_point		@ �ɤ߹���ǡ����ֹ��ɸ
	mov	r8, #0				@ �����
1:
	ldrb	r9, [r11, r12]			@ �������
	add	r8, r8, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r8, r8, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
	
	mov	r8, r8, lsl #3			@ 8�ܤ��ƺ�ɸĴ��
	mov	r12, #3				@ loop�������
	ldr	r11, =music_data		@ music_data�����ϼ���
@------���ȿ��ǡ����μ���------
	mov	r12, #3				@ loop�������
	mov	r10, #0				@ �����
1:
	add	r9, r12, r8			@ ��ɸ�򻻽�
	ldrb	r9, [r11, r9]			@ �������
	add	r10, r10, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r10, r10, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop

	cmp	r10, #0
	@(PWM ��ư��⡼�ɤ����ꤹ��)
	ldr	r12, =PWM_BASE		@ PWM �����椹�뤿��Υ쥸�����Υ١������ɥ쥹
	ldreq	r9, =(0 << PWM_PWEN2)	@ PWEN2bit�ܤޤ�1�򺸥��ե�
	ldreq	r8, =(0 << PWM_MSEN2)	@ MSEN2bit�ܤޤ�1�򺸥��ե�
	ldrne	r9, =(1 << PWM_PWEN2)	@ PWEN2bit�ܤޤ�1�򺸥��ե�
	ldrne	r8, =(1 << PWM_MSEN2)	@ MSEN2bit�ܤޤ�1�򺸥��ե�
	orr	r9, r9, r8		@ ����
	str	r9, [r12, #PWM_CLT]
	beq	check_time_sound

	@ �����Ĥ餹
	ldr	r11, =PWM_HZ
	udiv	r10, r11, r10
	ldr	r12, =PWM_BASE
	str	r10, [r12, #PWM_RNG2]
	lsr	r10, r10, #1			
	str	r10, [r12, #PWM_DAT2]

	b	check_time_sound


loop:
    b    loop

	.section .data

@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1	
	
@�ɤ߹���deta�ֹ���Ǽ����
read_point:	.word	0

@�����Ѥ��륿���ߥ󥰤�¬��
time_sound:	.word	0

@=====================================================================
@========������������Խ����Ƥ��Ȥ���������=================================
@=====================================================================

@ music_data�θĿ��򤳤��˽񤭹���Ǥ�������	
music_size:	.word	40
	
@ ���ڤΥǡ���  ���ȿ�, �Ĥ餹����[1ns]
@ ���Υǡ�����word�����ǽ񤭹���Ǥ�������
music_data:
	.word KEY_So0,	200000
	.word KEY_Do,	200000
	.word KEY_Mi,	200000
	.word 0,	050000
	.word KEY_So,	200000
	.word KEY_Do1,	200000
	.word KEY_Mi1,	200000
	.word 0,	050000
	.word KEY_So1,	600000
	.word KEY_Mi1,	600000
	@/////10/////
	.word 0,	050000
	.word KEY_Raf,	200000
	.word KEY_Do,	200000
	.word KEY_Mif,	200000
	.word 0,	050000
	.word KEY_Raf,	200000
	.word KEY_Do1,	200000
	.word KEY_Mif1,	200000
	.word 0,	050000
	.word KEY_Raf2,	600000
	@/////20/////
	.word KEY_Mif1,	600000
	.word 0,	050000
	.word KEY_Sif,	200000
	.word KEY_Re,	200000
	.word KEY_Fa,	200000
	.word 0,	050000
	.word KEY_Sif1,	200000
	.word KEY_Re1,	200000
	.word KEY_Fa1,	200000
	.word 0,	050000
	@/////30/////
	.word KEY_Sif2,	600000
	.word 0,	050000
	.word KEY_Sif2,	200000
	.word 0,	050000
	.word KEY_Sif2,	200000
	.word 0,	050000
	.word KEY_Sif2,	200000
	.word 0,	050000
	.word KEY_Do2,	1000000
	.word 0,	1000000
	@/////40/////
