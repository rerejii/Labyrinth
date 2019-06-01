@------print�ˤĤ���-------------------------------
@�ɥåȥޥȥ�å���LED�����ѤΥ��֥롼����Ǥ�
@������ä��ޥåץǡ������ɸ�ǡ����򸵤�ɽ�����ޤ�
@���ߥޥåפ�����ǽ��print�ˤϤĤ��Ƥޤ���
@�����餯�ᥤ���labyrinth������ǽ��Ĥ�����ˤʤ�Ǥ��礦
@------------------------------------------------
	@-----print��ͭ���-----
	.equ	GOAL_TIME,		400000		@ ��������(0.4��)
	.equ	WALL_TIME,		3000		@ ����(0.002��)
	.equ	TORCH_TIME,		8000		@ �ȡ�����(0.008��)
	.equ	NEXT_TORCH_TIME,	500000		@ ���������뤵���Ѥ�륿���ߥ�(0.5��)
	

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	labyrinth_data����Ƭ����
@r2, 	labyrinth_paramerers����Ƭ����
@r3, 	sw_value����Ƭ����
@------------------------
	.include "include.inc" 
	.section .text
	.global  startAnimation

startAnimation:		
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
	ldrb	r12, [r2, #TASK_FIRST_SW]	@ ���ư��Ƚ���ͤ�������
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
@------time_goal�ν����-------------------------------	
	ldr	r11, =GOAL_TIME			@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_goal			@ time_goal�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop
@------time_wall�ν����-------------------------------
	ldr	r11, =WALL_TIME			@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_wall			@ time_wall�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop
@------time_torch�ν����------------------------------
	ldr	r11, =TORCH_TIME		@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_torch		@ time_torch�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop
@------time_next_torch�ν����-------------------------
	ldr	r11, =NEXT_TORCH_TIME		@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_next_torch		@ time_torch�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop

	ldr	r10, =torch_power		@ torch_power��������
	mov	r9, #0				@ 0���Ǽ����
	strb	r9, [r10]			@ torch_power����������
	
first_end:
@------time_goal��Ƚ��-------------------------------	
c_time_goal:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_goal			@ time_goal�����ϼ���
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
	bcc	c_time_goal_end			@ Ƚ�꽪λ
	ldr	r12, =GOAL_TIME			@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_goal			@ time_goal�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop
	
	ldr	r12, =print_goal		@ print_goal�κ�ɸ��������
	ldrb	r11, [r12]			@ ����/���������椹���ͤ�������
	cmp	r11, #0				@ ���߾����ʤ�
	moveq	r10, #1				@ 1���Ǽ
	movne	r10, #0				@ 0���Ǽ
	strb	r10, [r12]			@ ����
c_time_goal_end:
@------time_wall��Ƚ��-------------------------------
c_time_wall:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_wall			@ time_wall�����ϼ���
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
	bcc	c_time_wall_end			@ Ƚ�꽪λ

	ldr	r12, =WALL_TIME			@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_wall			@ time_wall�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop
	
	mov	r12, #0				@ �������8��
	ldr	r11, =check_time_row		@ ���٤ƤιԤ���ɽ����ǽ�ˤ���
	mov	r10, #1				@ �񤭴����Ѥ�1
c_time_wall_loop:
	strb	r10, [r11, r12]			@ ɽ����ǽ�˽񤭴���
	cmp	r12, #7				@ ���٤ƽ񤭴���������ä���
	addne	r12, r12, #1			@ 1��­��
	bne	c_time_wall_loop			@ loop		
c_time_wall_end:
	
@------time_torch��Ƚ��------------------------------
c_time_torch:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_torch		@ time_torch�����ϼ���
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
	bcc	c_time_torch_end		@ Ƚ�꽪λ

	ldr	r12, =TORCH_TIME		@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_torch		@ time_torch�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	mov	r12, #0				@ ������Ƚ����
	ldr	r11, =print_torch		@ ��ɸ��������
	mov	r10, #1				@ ������
1:	
	strb	r10, [r11, r12]			@ �ͤι���
	cmp	r12, #7				@ loop�Υ������Ƚ��
	addne	r12, r12, #1			@ ������ȥ��å�
	bne	1b				@ loop
c_time_torch_end:
	
@------time_next_torch��Ƚ��------------------------------
c_time_next_torch:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_next_torch		@ time_next_torch�����ϼ���
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
	bcc	c_time_next_torch_end		@ Ƚ�꽪λ

	ldr	r12, =NEXT_TORCH_TIME		@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_next_torch		@ time_next_torch�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	ldr	r12, =torch_power		@ torch_power
	ldrb	r11, [r12]			@ ���ߤ�torch_power��������
	cmp	r11, #4				@ ���˺����ͤ�
	addne	r11, r11, #1			@ torch_power��ץ饹
	strb	r11, [r12]			@ �ͤ򹹿�
c_time_next_torch_end:	
	
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
	
buffer_in_check:
	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldr	r11, =check_time_row
	ldrb	r10, [r11, r12]			@ check_time_row��ꡢɽ�����٤�����Ƚ��
	cmp	r10, #1				@ 1�ʤ�ɽ��
	bne	buffer_in_map_end		@ 0�ʤ�ޥå���ɽ��
	mov	r10, #0				@ ɽ��������0���᤹
	strb	r10, [r11, r12]			@ print_row��0��
buffer_in_map:	
	@ ---�ޥåץǡ�������ǡ�����buffer�˳�Ǽ---
	mov	r12, #0				@ ���ɥ쥹��Ǽ�Ѥ˽����
	ldrb	r11, [r2, #LABY_COORDINATE_X]	@ ��ӥ�󥹤Υ�����x��������
	ldrb	r10, [r2, #MAP_COORDINATE_Y]	@ �ޥåפκ�ɸy��������
	ldr	r9, =print_row			@ ���Ϥ��٤��Ԥ���¸���Ƥ����ɸ
	ldrb	r9, [r9]			@ ���Ϥ��٤����ֹ�μ���
	add	r10, r10, r9			@ �Կ���ץ饹
	mul	r12, r11, r10			@ �ݤ���路�ƥޥåפθ����Ϥ�y��ɸ�����
	ldrb	r11, [r2, #MAP_COORDINATE_X]	@ �ޥåפκ�ɸx��������
	add	r12, r12, r11			@ �ޥåפκ�ɸ�����
	ldr	r11, =frame_buffer		@ frame_buffer�κ�ɸ��������
	mov	r10, #0				@ loop���������
buffer_in_map_loop:
	mov	r9, r12				@ r9�˺�ɸ�򥳥ԡ�
	add	r9, r9, r10			@ ������Ȥ�­��
	ldrb	r8, [r1, r9]			@ 1Byte�������
	strb	r8, [r11, r10]			@ frame_buffer�κ�ɸ��1Byte�񤭹���
	cmp	r10, #7				@ 8Byte�񤭹������?
	addne	r10, r10, #1			@ ������ȥ��å�
	bne	buffer_in_map_loop		@ loop
	@ -------------------------
buffer_in_map_end:



buffer_in_goal:
	ldr	r12, =print_goal		@ print_goal�κ�ɸ��������
	ldrb	r12, [r12]			@ ����/���������椹���ͤ�������
	cmp	r12, #1				@ ���� or ����
	bne	buffer_in_goal_end		@ �����ʤ齪λ
	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldrb	r11, [r2, #MAP_COORDINATE_Y]	@ ����ɽ�����Ƥ���ޥå׺�ɸy��������
	add	r12, r12, r11			@ �ޥå׺�ɸ��­��
	ldrb	r11, [r2, #GOAL_COORDINATE_Y]	@ goal��y��ɸ��������
	cmp	r11, r12			@ goal�Τ���Ԥ�ɽ�����뤫?
	bne	buffer_in_goal_end		@ �㤦�ʤ鼡�Υ�������
	mov	r12, #0				@ �����0~7�ޤǿ�����쥸����
	ldrb	r11, [r2, #GOAL_COORDINATE_X]	@ goal��x��ɸ��������
	mov	r10, #1				@ ��Ǽ����1�����
	ldr	r9, =frame_buffer		@ frame_buffer�κ�ɸ��������
	ldrb	r8, [r2, #MAP_COORDINATE_X]	@ ����ɽ�����Ƥ���ޥå׺�ɸy��������
buffer_in_goal_loop:
	cmp	r11, r8				@ ���ߤ����goal�����뤫
	streqb	r10, [r9, r12]			@ goal��񤭹���
	cmp	r12, #7				@ Ƚ�꽪λ?
	addne	r12, r12, #1			@ 1��­��
	addne	r8, r8, #1			@ Ƚ��Ԥ�1��­��
	bne	buffer_in_goal_loop		@ loop
buffer_in_goal_end:


buffer_in_player:	
	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyer��y��ɸ��������
	cmp	r11, r12			@ pleyer�Τ���Ԥ�ɽ�����뤫?
	bne	buffer_in_player_end		@ �㤦�ʤ鼡�Υ�������
	mov	r12, #0				@ �����0~7�ޤǿ�����쥸����
	ldrb	r11, [r2, #PLAYER_COORDINATE_X]	@ pleyer��x��ɸ��������
	mov	r10, #1				@ ��Ǽ����1�����
	ldr	r9, =frame_buffer		@ frame_buffer�κ�ɸ��������
buffer_in_player_loop:
	cmp	r12, r11			@ ���ߤ����pleyer����뤫
	streqb	r10, [r9, r12]			@ pleyer��񤭹���
	cmp	r12, #7				@ Ƚ�꽪λ?
	addne	r12, r12, #1			@ 1��­��
	bne	buffer_in_player_loop		@ loop
buffer_in_player_end:
	
buffer_torch:
	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyer��y��ɸ��������
	cmp	r11, r12			@ �ɤä����礭��?
	subpl	r10, r11, r12			@ �����ͤ���Ф�
	submi	r10, r12, r11			@ �����ͤ���Ф�
	ldr	r12, =torch_power		@ torch_power��������
	ldrb	r12, [r12]			@ torch_power����
	add	r10, r10, r12, lsl #3		@ ������٥��8�ܤ���­��
	ldr	r11, =torch_rengs		@ �����ε�Υtorch_rengs�κ�ɸ
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
	ldrls	r9, =print_torch		@ ��ɸ��������
	ldrlsb	r9, [r9, r8]			@ ��Ǽ���٤��ͤ�������
	ldrls	r8, =frame_buffer		@ frame_buffer�κ�ɸ��������
	strlsb	r9, [r8, r12]			@ �����ʤ��ϰϤ�ä�
	cmp	r12, #7				@ ���٤ƤιԤ�Ƚ�꽪��ä�?
	addne	r12, r12, #1			@ ������ȥ��å�
	bne	1b

	ldr	r12, =print_row			@ print_row��������
	ldrb	r12, [r12]			@ ���Ϥ��٤��Ԥ�������
	ldr	r11, =print_torch		@ ��ɸ��������
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

@�ե졼��Хåե��ꥻ�å���
all_zero:	.byte 0, 0, 0, 0, 0, 0, 0, 0
	
@���Ϥ��٤��Ԥ���¸
print_row:	.byte 0

@����������Ǵ���
print_goal:	.byte 0

@����������Ǵֳ֤λ��ִ�����
time_goal:	.word 0

@�ɤ�ɽ���ֳ֤λ��ִ�����
time_wall:	.word 0

@�����θ������ϰϤ�����
time_torch:	.word 0

@������ɽ������
print_torch:	.byte	0, 0, 0, 0, 0, 0, 0, 0

@ɽ������Ԥ���֤Ǵ�������ǡ��� ���֤ˤʤ�Ȥ��٤ƣ��� ɽ�������Ԥ�0�����
check_time_row:		.byte 0, 0, 0, 0, 0, 0, 0, 0

@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1

@�����ζ���
torch_power:	.byte 0

@�����μ����ʳ��˰ܤ����
time_next_torch:	.word 0	

torch_rengs:	.byte	0, 0, 0, 0, 0, 0, 0, 0 @�ѥ0
		.byte	2, 2, 0, 0, 0, 0, 0, 0 @�ѥ1
		.byte	3, 3, 2, 0, 0, 0, 0, 0 @�ѥ2
		.byte	4, 4, 3, 2, 0, 0, 0, 0 @�ѥ3
		.byte	5, 5, 4, 4, 3, 0, 0, 0 @�ѥ4
	
