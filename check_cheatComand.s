@------input�ˤĤ���-------------------------------
@�����å������ϼ����ѤΥ��֥롼����Ǥ�
@Ϣ³���ϤˤĤ��Ƥ����Ϥ��Ƥ���0���֤��ޤ�
@�����å����ͤ�sw_value�˽񤭹�����֤��ޤ�
@------------------------------------------------

	@-----�ץ���������ꤷ�����-----
	.equ	CHANGE_TIME,		3000000			@ (3��)

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	sw_value����Ƭ����
@------------------------
	.include "include.inc"
	.section .text
	.global  check_cheatComand
check_cheatComand:	
@------�ǡ�������¸-------------------------------------
backup:
	str	r7, [sp, #-4]!	@ push
	str	r8, [sp, #-4]!	@ push
	str	r9, [sp, #-4]!	@ push
	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
@-----���ư�ưȽ��-----------------------------------------
first_now:
	ldrb	r12, [r2]			@ ���ư��Ƚ���ͤ�������
	cmp	r12, #1				@ ���ư���ư���뤫?
	ldreq	r11, =first_flag		@ first_flag������
	streqb	r12, [r11]			@ �񤭹���
@------���ư��-----------------------------------
first_task:
	ldr	r12, =first_flag		@ r12��first_flag������
	ldrb	r11, [r12]			@ �����ư�Υե饰�����
	cmp	r11, #1				@ ���Ƥε�ư��?
	bne	first_end			@ ��λ
	mov	r11, #0				@ 0��Ǽ
	strb	r11, [r12]			@ �ե饰���ޤ�
@------�����Ȳ��----------------------------------
	mov	r12, #0				@ 0���Ǽ
	strb	r12, [r1, #CHEAT_SW]		@�����å�ON_OFF���Ǽ
@------���ֹ���-----------------------------------
	ldr	r12, =TIMER_BASE		@ �����ƥॿ���ޤΥ١������ɥ쥹
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + ���ե��å�)���Ϥ����ɤ߽Ф�
	ldr	r10, =CHANGE_TIME		@ 3�ä�������
	add	r10, r10, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_change		@ time_change�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop	
first_end:
	
sw_check:
	mov	r12, #1				@ loop���������
	ldr	r11, =switch_port		@ switch_port�κ�ɸ��������
	ldrb	r11, [r11, r12]			@ �����å��Υݡ��Ȥ�������
	@#(GPLEV0 + SWITCH_PORT / 32 * 4)
	mov	r10, r11, lsr #5		@ 32�ǳ��(r11�Υ����å��ݡ����ֹ�ϸ�ǻȤ������ݸ�)
	mov	r10, r10, lsl #2		@ 4�ǳݤ���
	add	r10, r10, #GPLEV0		@ GPIO�ݡ��Ȥ������ͤ���Ǽ����Ƥ������ϤΥ��ե��åȤ�­��	
	ldr	r10, [r0, r10]			@ �����å��ξ��֤�������
	mov	r9, #1				@ 1
	and	r10, r9, r10, lsr r11		@ �����Ѥˤ�ꥹ���å����ͤ���Ф�(r11�ϥ����å��ݡ����ֹ�)
	cmp	r10, #0				@ �����å����ͤ�0 or 0�ʳ�
	beq	reset				@ ������Ƥ��ʤ������å��������3�åꥻ�å�
time_check:	
	@------time_sound����------
	ldr	r11, =time_change		@ time_change�����ϼ���
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
	bcc	return				@ ��ư���֤����äƤʤ���н�λ
musicMode_on_off:
	ldrb	r11, [r1, #CHEAT_SW]		@ �����Ⱦ��֤�������
	cmp	r11, #0				@ 0 or 1
	moveq	r12, #1				@ 1���Ǽ
	movne	r12, #0				@ 0���Ǽ
	strb	r12, [r1, #CHEAT_SW]		@�����å�ON_OFF���Ǽ
reset:
@------����3�ø��-----------------------------------
	ldr	r12, =TIMER_BASE		@ �����ƥॿ���ޤΥ١������ɥ쥹
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + ���ե��å�)���Ϥ����ɤ߽Ф�
	ldr	r10, =CHANGE_TIME		@ 3�ä�������
	add	r10, r10, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_change		@ time_change�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop		
	
@------��λ--------------------------------------------
return:
	ldrb	r11, [r1, #CHEAT_SW]		@ �����Ⱦ��֤�������
	cmp	r11, #0				@ 0 or 1
	@LED����
	movne	r1, #(1 << (LED_PORT % 32))
	strne	r1, [r0, #(GPSET0 + LED_PORT / 32 * 4)]
	@LED����
	moveq    r1, #(1 << (LED_PORT % 32))
	streq    r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	ldr	r10, [sp], #4		@ pop
	ldr	r9, [sp], #4		@ pop
	ldr	r8, [sp], #4		@ pop
	ldr	r7, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ ����Τ����loop

@======data==========================================
	.section .data
@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1	

@�����å��ݡ��ȤΤޤȤ�
switch_port:	.byte SWITCH1_PORT, SWITCH2_PORT, SWITCH3_PORT, SWITCH4_PORT

@�Ѥ��륿���ߥ󥰤�¬��
time_change:	.word	0
