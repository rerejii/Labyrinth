@------input�ˤĤ���-------------------------------
@�����å������ϼ����ѤΥ��֥롼����Ǥ�
@Ϣ³���ϤˤĤ��Ƥ����Ϥ��Ƥ���0���֤��ޤ�
@�����å����ͤ�sw_value�˽񤭹�����֤��ޤ�
@------------------------------------------------

	@-----�ץ���������ꤷ�����-----
	.equ	INPUT_TIME,		1000			@ task_input��(0.001��)

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	sw_value����Ƭ����
@------------------------
	.include "include.inc"
	.section .text
	.global  reset_check
reset_check:	
@------�ǡ�������¸-------------------------------------
backup:
	str	r9, [sp, #-4]!	@ push
	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push

@------�����å��ξ��ֹ���--------------------------------
sw_check:
	mov	r12, #0						@ loop���������
sw_check_loop:
	ldr	r11, =switch_port				@ switch_port�κ�ɸ��������
	ldrb	r11, [r11, r12]					@ �����å��Υݡ��Ȥ�������
	@#(GPLEV0 + SWITCH_PORT / 32 * 4)
	mov	r10, r11, lsr #5				@ 32�ǳ��(r11�Υ����å��ݡ����ֹ�ϸ�ǻȤ������ݸ�)
	mov	r10, r10, lsl #2				@ 4�ǳݤ���
	add	r10, r10, #GPLEV0				@ GPIO�ݡ��Ȥ������ͤ���Ǽ����Ƥ������ϤΥ��ե��åȤ�­��
	
	ldr	r10, [r0, r10]					@ �����å��ξ��֤�������
	mov	r9, #1						@ 1
	and	r10, r9, r10, lsr r11				@ �����Ѥˤ�ꥹ���å����ͤ���Ф�(r11�ϥ����å��ݡ����ֹ�)
	cmp	r10, #0						@ �����å����ͤ�0 or 0�ʳ�
	beq	return						@ ������Ƥ��ʤ������å�������н�λ
	cmp	r12, #3						@ ���٤ƤΥ����å���Ƚ�꤬��λ������?
	addne	r12, r12, #1					@ ������ȥ��å�
	bne	sw_check_loop					@ loop
reset_on:
	mov	r12, #1						@ 1���Ǽ
	strb	r12, [r1]					@ �ꥻ�å�ON���Ǽ
	
@------��λ--------------------------------------------
return:
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	ldr	r10, [sp], #4		@ pop
	ldr	r9, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ ����Τ����loop

@======data==========================================
	.section .data
@�����å��ݡ��ȤΤޤȤ�
switch_port:	.byte SWITCH1_PORT, SWITCH2_PORT, SWITCH3_PORT, SWITCH4_PORT
