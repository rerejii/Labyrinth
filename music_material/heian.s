@ ���󥸥��ʡ���ʿ�¤Υ����ꥢ���~������ϡ�����~

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

@================================================================================
	
	.equ    KEY_2_Do, 65  @ 3C_��
	.equ    KEY_2_Dos, 69  @ 3C_��#
	.equ    KEY_2_Re, 73  @ 3C_��
	.equ    KEY_2_Res, 77  @ 3C_��#
	.equ    KEY_2_Mi, 82  @ 3C_��
	.equ    KEY_2_Fa, 87  @ 3C_�ե�
	.equ    KEY_2_Fas, 92  @ 3C_�ե�#
	.equ    KEY_2_So, 98  @ 3C_��
	.equ    KEY_2_Sos, 103  @ 3C_��#
	.equ    KEY_2_Ra, 110  @ 3C_��
	.equ    KEY_2_Ras, 116  @ 3C_��#
	.equ    KEY_2_Si, 123  @ 3C_��

	.equ    KEY_3_Do, 130  @ 3C_��
	.equ    KEY_3_Dos, 138  @ 3C_��#
	.equ    KEY_3_Re, 146  @ 3C_��
	.equ    KEY_3_Res, 155  @ 3C_��#
	.equ    KEY_3_Mi, 164  @ 3C_��
	.equ    KEY_3_Fa, 174  @ 3C_�ե�
	.equ    KEY_3_Fas, 185  @ 3C_�ե�#
	.equ    KEY_3_So, 196  @ 3C_��
	.equ    KEY_3_Sos, 207  @ 3C_��#
	.equ    KEY_3_Ra, 220  @ 3C_��
	.equ    KEY_3_Ras, 233  @ 3C_��#
	.equ    KEY_3_Si, 246  @ 3C_��

	.equ    KEY_4_Do, 261  @ 4C_��
	.equ    KEY_4_Dos, 277  @ 4C_��#
	.equ    KEY_4_Re, 293  @ 4C_��
	.equ    KEY_4_Res, 311  @ 4C_��#
	.equ    KEY_4_Mi, 329  @ 4C_��
	.equ    KEY_4_Fa, 349  @ 4C_�ե�
	.equ    KEY_4_Fas, 369  @ 4C_�ե�#
	.equ    KEY_4_So, 392  @ 4C_��
	.equ    KEY_4_Sos, 415  @ 4C_��#
	.equ    KEY_4_Ra, 440  @ 4C_��
	.equ    KEY_4_Ras, 466  @ 4C_��#
	.equ    KEY_4_Si, 493  @ 4C_��

	.equ    KEY_5_Do, 523  @ 5C_��
	.equ    KEY_5_Dos, 554  @ 5C_��#
	.equ    KEY_5_Re, 587  @ 5C_��
	.equ    KEY_5_Res, 622  @ 5C_��#
	.equ    KEY_5_Mi, 659  @ 5C_��
	.equ    KEY_5_Fa, 698  @ 5C_�ե�
	.equ    KEY_5_Fas, 739  @ 5C_�ե�#
	.equ    KEY_5_So, 783  @ 5C_��
	.equ    KEY_5_Sos, 830  @ 5C_��#
	.equ    KEY_5_Ra, 880  @ 5C_��
	.equ    KEY_5_Ras, 932  @ 5C_��#
	.equ    KEY_5_Si, 987  @ 5C_��

	.equ    KEY_6_Do, 1046  @ 6C_��
	.equ    KEY_6_Dos, 1108  @ 6C_��#
	.equ    KEY_6_Re, 1174  @ 6C_��
	.equ    KEY_6_Res, 1244  @ 6C_��#
	.equ    KEY_6_Mi, 1318  @ 6C_��
	.equ    KEY_6_Fa, 1396  @ 6C_�ե�
	.equ    KEY_6_Fas, 1479  @ 6C_�ե�#
	.equ    KEY_6_So, 1567  @ 6C_��
	.equ    KEY_6_Sos, 1661  @ 6C_��#
	.equ    KEY_6_Ra, 1760  @ 6C_��
	.equ    KEY_6_Ras, 1864  @ 6C_��#
	.equ    KEY_6_Si, 1975  @ 6C_��	
@================================================================================

	
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
@++++++test++++++++++++++++++++++++++++++++++++++++++++++
	mov	r1, #(1 << (10 % 32))
	str	r1, [r0, #(0x28 + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
@++++++test++++++++++++++++++++++++++++++++++++++++++++++
	mov	r1, #(1 << (10 % 32))
	str	r1, [r0, #(0x1C + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
music_size:	.word	241
	
@ ���ڤΥǡ���  ���ȿ�, �Ĥ餹����[1ns]
@ ���Υǡ�����word�����ǽ񤭹���Ǥ�������
music_data:
	.word KEY_4_Re, 200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	.word KEY_4_Res,200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	@///// 1 - 8 /////     @8

	.word KEY_4_Mi, 200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	.word KEY_4_Res,200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	@///// 2 - 8 /////     @16

	.word KEY_4_Re, 200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	.word KEY_4_Res,200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	@///// 3 - 8 /////     @24

	.word KEY_4_Mi, 200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	.word KEY_4_Res,200000
	.word KEY_4_So, 200000
	.word KEY_4_Ra, 200000
	.word KEY_5_Re, 200000
	@///// 4 - 8 /////     @32

	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 5 - 8 /////     @40

	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 6 - 8 /////     @48

	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 7 - 8 /////     @56

	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 8 - 8 /////     @64

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Fa, 400000
	@///// 9 - 4 /////     @68

	.word KEY_5_So, 400000
	.word KEY_5_Fa, 400000
	.word KEY_5_Mi, 400000
	.word KEY_5_Res,400000
	@///// 10 - 4 /////    @72

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Mi, 400000
	.word KEY_6_Do, 400000
	@///// 11 - 4 /////    @76

	.word KEY_5_Si, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Ra, 800000
	@///// 12 - 3 /////    @79

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Fa, 400000
	@///// 13 - 4 /////    @83

	.word KEY_5_So, 400000
	.word KEY_5_Fa, 400000
	.word KEY_5_Mi, 400000
	.word KEY_5_Res,400000
	@///// 14 - 4 /////    @87

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Mi, 400000
	.word KEY_6_Do, 400000
	@///// 15 - 4 /////    @91

	.word KEY_5_Si, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Ra, 800000
	@///// 16 - 3 /////    @94

	.word 0,	400000
	.word KEY_5_Ra, 400000
	.word 0,	400000
	.word KEY_5_Ra, 400000
	@///// 17 - 4 /////    @98

	.word 0,	400000
	.word KEY_5_Ra, 400000
	.word 0,	200000
	.word KEY_5_Ra, 100000
	.word KEY_5_Ras,100000
	.word KEY_6_Do,	400000
	@///// 18 - 6 /////    @104

	.word KEY_6_Re, 1200000
	.word KEY_6_Do, 400000
	@///// 19 - 2 /////    @106

	.word 0,	400000
	.word KEY_5_Sos,400000
	.word KEY_5_Ra, 800000
	@///// 20 - 3 /////    @109

	.word KEY_5_Fa, 400000
	.word 0,	600000
	.word KEY_5_Fa, 200000
	.word KEY_5_So,	200000
	.word KEY_5_Ra,	200000
	@///// 21 - 5 /////    @114

	.word KEY_5_Ras,800000
	.word KEY_6_Res,800000
	@///// 22 - 2 /////    @116

	.word KEY_6_Re, 800000
	.word KEY_6_Fa, 800000
	@///// 23 - 2 /////    @118

	.word KEY_6_Mi, 800000
	.word KEY_6_Res,800000
	@///// 24 - 2 /////    @120

	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 25 - 8 /////    @128

	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 26 - 8 /////    @136

	.word 0,	200000
	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_6_Re, 200000
	.word 0,	200000
	.word KEY_5_Res,200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 27 - 8 /////    @144

	.word 0,	200000
	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_6_Re, 200000
	.word 0,	200000
	.word KEY_5_Res,200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 28 - 8 /////    @152

	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 29 - 8 /////    @160

	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	.word KEY_5_Res,200000
	.word KEY_5_So, 200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 30 - 8 /////    @168

	.word 0,	200000
	.word KEY_5_Re, 200000
	.word KEY_5_So, 200000
	.word KEY_6_Re, 200000
	.word 0,	200000
	.word KEY_5_Res,200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 31 - 8 /////    @176

	.word 0,	200000
	.word KEY_5_Mi, 200000
	.word KEY_5_So, 200000
	.word KEY_6_Re, 200000
	.word 0,	200000
	.word KEY_5_Res,200000
	.word KEY_5_Ra, 200000
	.word KEY_6_Re, 200000
	@///// 32 - 8 /////    @184

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Mi, 400000
	@///// 33 - 4 /////    @188

	.word KEY_5_So, 400000
	.word KEY_5_Fa, 400000
	.word KEY_5_Mi, 400000
	.word KEY_5_Res,400000
	@///// 34 - 4 /////    @192

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Mi, 400000
	.word KEY_6_Do, 400000
	@///// 35 - 4 /////    @196

	.word KEY_5_Si, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_So, 800000
	@///// 36 - 3 /////    @199

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Mi, 400000
	@///// 37 - 4 /////    @203

	.word KEY_5_So, 400000
	.word KEY_5_Fa, 400000
	.word KEY_5_Mi, 400000
	.word KEY_5_Res,400000
	@///// 38 - 4 /////    @207

	.word KEY_5_Re, 400000
	.word KEY_5_Ra, 400000
	.word KEY_5_Mi, 400000
	.word KEY_6_Do, 400000
	@///// 39 - 4 /////    @211

	.word KEY_5_Si, 400000
	.word KEY_5_Sos,400000
	.word KEY_5_Ra, 800000
	@///// 40 - 3 /////    @214

	.word 0,	400000
	.word KEY_5_Ra, 400000
	.word 0,	400000
	.word KEY_5_Ra, 400000
	@///// 41 - 4 /////    @218

	.word 0,	400000
	.word KEY_5_Ra, 400000
	.word 0,	200000
	.word KEY_5_Ra, 100000
	.word KEY_5_Ras,100000
	.word KEY_6_Do,	400000
	@///// 42 - 6 /////    @224

	.word KEY_6_Re, 1200000
	.word KEY_6_Do, 400000
	@///// 43 - 2 /////    @226

	.word 0,	400000
	.word KEY_5_Sos,400000
	.word KEY_5_Ra, 800000
	@///// 44 - 3 /////    @229

	.word KEY_5_Fa, 400000
	.word 0,	600000
	.word KEY_5_Fa, 200000
	.word KEY_5_So,	200000
	.word KEY_5_Ra,	200000
	@///// 45 - 5 /////    @234

	.word KEY_5_Ras,800000
	.word KEY_6_Res,800000
	@///// 46 - 2 /////    @236

	.word KEY_6_Re, 800000
	.word KEY_6_Fa, 800000
	@///// 47 - 2 /////    @238

	.word KEY_6_Mi, 800000
	.word KEY_6_Res,800000
	@///// 48 - 2 /////    @240

	.word KEY_6_Re, 3200000
	@///// 49 - 1 /////    @241
