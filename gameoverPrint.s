
	@-----gameoverPrint��ͭ���-----
	.equ	SCREEN_TIME,		8000		@ �ȡ�����(0.008��)
	.equ	DECREASE_TIME,		400000		@ ����������(0.2��)
	.equ	DECEEASE_MAX,		20		@ ������٥�κ���

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	labyrinth_data����Ƭ����
@r2, 	labyrinth_paramerers����Ƭ����
@r3, 	reset_sw����Ƭ����
@r4, 	reset_mode����Ƭ����	
@------------------------
	.include "include.inc" 
	.section .text
	.global  gameoverPrint

gameoverPrint:		
@-----�ǡ�������¸-------------------------------------
backup:
	str	r7, [sp, #-4]!	@ push
	str	r8, [sp, #-4]!	@ push
	str	r9, [sp, #-4]!	@ push
 	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
@-----���ư�ưȽ��-----------------------------------------
first_now:
	ldrb	r12, [r4]			@ ���ư��Ƚ���ͤ�������
	cmp	r12, #1				@ ���ư���ư���뤫?
	ldreq	r11, =first_flag		@ first_flag������
	streqb	r12, [r11]			@ �񤭹���
@-----���ư��-----------------------------------------	
first_task:
	ldr	r12, =first_flag		@ r12��first_flag������
	ldrb	r11, [r12]			@ �����ư�Υե饰�����
	cmp	r11, #1				@ ���Ƥε�ư��?
	bne	first_end			@ ��λ
	mov	r11, #0				@ 0��Ǽ
	strb	r11, [r12]			@ �ե饰���ޤ�
	ldr	r12, =TIMER_BASE		@ �����ƥॿ���ޤΥ١������ɥ쥹
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + ���ե��å�)���Ϥ����ɤ߽Ф�
@------time_screen�ν����-------------------------------	
	ldr	r11, =SCREEN_TIME		@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_screen		@ time_goal�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop
@------time_decrease�ν����-------------------------------
	ldr	r11, =DECREASE_TIME		@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_decrease		@ time_wall�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop

	ldr	r12, =count_decrease		@ ��ɸ��������
	mov	r11, #0				@ 0���Ǽ
	strb	r11, [r12]			@ �ͤι���
first_end:

@------time_screen��Ƚ��------------------------------
c_time_screen:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_screen		@ time_screen�����ϼ���
	mov	r10, #0				@ �����
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
	bcc	c_time_screen_end		@ Ƚ�꽪λ

	ldr	r12, =SCREEN_TIME		@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_screen		@ time_screen�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	mov	r12, #0				@ ������Ƚ����
	ldr	r11, =print_screen		@ ��ɸ��������
	mov	r10, #1				@ ������
1:	
	strb	r10, [r11, r12]			@ �ͤι���
	cmp	r12, #7				@ loop�Υ������Ƚ��
	addne	r12, r12, #1			@ ������ȥ��å�
	bne	1b				@ loop
c_time_screen_end:

@------time_decrease��Ƚ��------------------------------
c_time_decrease:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_decrease		@ time_decrease�����ϼ���
	mov	r10, #0				@ �����
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
	bcc	c_time_decrease_end		@ Ƚ�꽪λ

	ldr	r12, =DECREASE_TIME		@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_decrease		@ time_decrease�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	ldr	r12, =count_decrease		@ ��ɸ��������
	ldrb	r11, [r12]			@ �ͤ�������
	cmp	r11, #DECEEASE_MAX		@ max��������������
	addne	r11, r11, #1			@ ������
	strneb	r11, [r12]			@ �ͤι���
	moveq	r11, #1				@ ������1
	streqb	r11, [r3]			@ reset_sw��1���Ǽ
c_time_decrease_end:

@------col(��)�κ��----------------------------------
col_dlt:
	@   ���ä�����򤹤٤ƾ���
	mov	r11, #0
	ldr	r12, =col_port
col_dlt_loop:
	ldrb	r9, [r12, r11]			@ col�ݡ����ֹ����Ф�
	mov	r10, #1				@ 1���Ǽ
	mov	r10, r10, lsl r9		@ 1��Ω�Ƥ�������ꤹ��
	str	r10, [r0, #GPCLR0]		@ ̵��
	cmp	r11, #7				@ loop����λ������
	addne	r11, r11, #1			@ �������
	bne	col_dlt_loop			@ loop

@------row(��)����------------------------------------
row_str:
	@ �Ԥ����
	mov	r11, #0				@ �Կ���0~7�ޤǿ�����쥸����
	ldr	r12, =row_port			@ LED�ιԤΥݡ��Ƚ�����Ƭ����
row_loop:
	ldrb	r9, [r12, r11]			@ �ݡ����ֹ����Ф�
	mov	r10, #1				@ ����ξ���Ω�Ƥ�1���Ǽ
	mov	r10, r10, lsl r9		@ 1��Ω�Ƥ�������ꤹ��
	ldr	r9, =print_row			@ print_row��������
	ldrb	r9, [r9]			@ ���Ϥ��٤��Ԥ�������
	cmp	r9, r11				@ ���򤷤Ƥ���Ԥ�ɽ�����٤��Ԥ�?
	strne	r10, [r0, #GPSET0]		@ ̵��
	streq	r10, [r0, #GPCLR0]		@ ͭ��
	cmp	r11, #7				@ loop����λ������
	addne	r11, r11, #1			@ ���ιԤ�
	bne	row_loop			@ loop

@------������-----------------------------------------------
buffer_in_zero:
	mov	r12, #0				@ ���������
	mov	r11, #0				@ ������
	ldr	r10, =frame_buffer		@ frame_buffer�κ�ɸ��������
buffer_in_zero_loop:
	strb	r11, [r10, r12]			@ frame_buffer��0�ǽ����
	cmp	r12, #7				@ loop������ä�����
	addne	r12, r12, #1			@ ������ȥ��å�
	bne	buffer_in_zero_loop
	
buffer_screen:
	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyer��y��ɸ��������
	cmp	r11, r12			@ �ɤä����礭��?
	subpl	r10, r11, r12			@ �����ͤ���Ф�
	submi	r10, r12, r11			@ �����ͤ���Ф�
	ldr	r12, =count_decrease		@ count_decrease�κ�ɸ��������
	ldrb	r12, [r12]			@ ���Ȥ����Υ������ͤ�������
	add	r10, r10, r12, lsl #3		@ ��ɸ��8�ܤ���­��
	ldr	r11, =screen_rengs		@ �����ε�Υscreen_rengs�κ�ɸ
	ldrb	r11, [r11, r10]			@ �����ε�Υ����Ф�
	mov	r12, #0				@ ������Ƚ����
	ldrb	r10, [r2, #PLAYER_COORDINATE_X]	@ pleyer��x��ɸ��������
1:	
	cmp	r10, r12			@ �ɤä����礭��?
	subpl	r9, r10, r12			@ �����ͤ���Ф�
	submi	r9, r12, r10			@ �����ͤ���Ф�
	cmp	r11, r9				@ �����ε�Υ���Ϥ��ϰϤ�?
	ldr	r8, =print_row			@ print_row��������
	ldrb	r8, [r8]			@ ���Ϥ��٤��Ԥ�������
	ldrhi	r9, =print_screen		@ ��ɸ��������
	ldrhib	r9, [r9, r8]			@ ��Ǽ���٤��ͤ�������
	ldrhi	r8, =frame_buffer		@ frame_buffer�κ�ɸ��������
	strhib	r9, [r8, r12]			@ �ͤ��Ǽ���Ƥ���
	movls	r9, #0				@ 0�������
	strhib	r9, [r8, r12]			@ �Ǥ�����褦
	cmp	r12, #7				@ ���٤ƤιԤ�Ƚ�꽪��ä�?
	addne	r12, r12, #1			@ ������ȥ��å�
	bne	1b

	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldr	r11, =print_screen		@ ��ɸ��������
	mov	r10, #0				@ ������
	strb	r10, [r11 ,r12]			@ ����

col_str:	
	@ ������
	mov	r11, #0				@ �����0~7�ޤǿ�����쥸����
	ldr	r12, =col_port			@ LED����Υݡ��Ƚ�����Ƭ����
col_loop:
	ldrb	r9, [r12, r11]			@ �ݡ����ֹ����Ф�
	mov	r10, #1				@ ����ξ���Ω�Ƥ�1���Ǽ
	mov	r10, r10, lsl r9		@ 1��Ω�Ƥ�������ꤹ��
	ldr	r9, =frame_buffer		@ frame_buffer�κ�ɸ��������
	ldrb	r9, [r9, r11]			@ frame_buffer����ͤ�������
	cmp	r9, #1				@ ���򤷤Ƥ������ɽ�����٤���?
	strne	r10, [r0, #GPCLR0]		@ ̵��
	streq	r10, [r0, #GPSET0]		@ ͭ��
	cmp	r11, #7				@ loop����λ������
	addne	r11, r11, #1			@ �������
	bne	col_loop			@ loop
row_up:
	ldr	r12, =print_row			@ print_row��������
	ldrb	r9, [r12]			@ ���Ϥ��٤��Ԥ�������
	cmp	r9, #7				@ ���٤ƤιԤ���Ϥ�����
	addne	r9, r9, #1			@ �Ԥν��ϥ�����ȥ��å�
	moveq	r9, #0				@ �Ԥν��ϥ�����ȥꥻ�å�
	strb	r9, [r12]			@ print_row�򹹿�

@-----��λ--------------------------------------------	
return:
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
@�ɥåȥޥȥ�å����ιԤΥݡ����ֹ�ΤޤȤ�
col_port:	.byte COL1_PORT, COL2_PORT, COL3_PORT, COL4_PORT
		.byte COL5_PORT, COL6_PORT, COL7_PORT, COL8_PORT
@�ɥåȥޥȥ�å�������Υݡ����ֹ�ΤޤȤ�
row_port:	.byte ROW1_PORT, ROW2_PORT, ROW3_PORT, ROW4_PORT
		.byte ROW5_PORT, ROW6_PORT, ROW7_PORT, ROW8_PORT
@�ե졼��Хåե�
frame_buffer:	.byte 0, 0, 0, 0, 0, 0, 0, 0
	
@���Ϥ��٤��Ԥ���¸
print_row:	.byte 0

@���ϸ�������������
time_decrease:	.word 0

@���̤�ɽ������������
time_screen:	.word 0

@ɽ������Ԥ���֤Ǵ�������ǡ��� ���֤ˤʤ�Ȥ��٤ƣ��� ɽ�������Ԥ�0�����
print_screen:		.byte 0, 0, 0, 0, 0, 0, 0, 0

@Ŭ�Ѥ����ϰϤ����Τ˻Ȥ�
count_decrease:		.byte 0

@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1

screen_rengs:	.byte	8, 8, 8, 8, 8, 8, 8, 8
		.byte	8, 8, 8, 8, 8, 8, 7, 7
		.byte	8, 8, 8, 8, 7, 7, 6, 6
		.byte	8, 8, 7, 7, 6, 6, 5, 5
		.byte	7, 7, 6, 6, 5, 5, 4, 4
		.byte	6, 6, 5, 5, 4, 4, 3, 2
		.byte	5, 5, 4, 4, 3, 0, 0, 0
		.byte	4, 4, 3, 2, 0, 0, 0, 0
		.byte	3, 3, 2, 0, 0, 0, 0, 0 
		.byte	2, 2, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0

	
	
