@------inputReset�ˤĤ���-------------------------------
@�����å������Ϥ�ꥻ�å�(0��)���뤿��Υ��֥롼����Ǥ�
@-----------------------------------------------------

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	sw_value����Ƭ����
@------------------------

	.section .text
	.global  inputReset
inputReset:
@------�ǡ�������¸-------------------------------------
backup:
	str	r12, [sp, #-4]!	@ push
@------�����------------------------------------------
reset:	
	mov	r12, #0				@ ������
	mov	r11, #0				@ �������
reset_loop:
	strb	r12, [r1, r11]			@ �ꥻ�å�
	cmp	r11, #3				@ 4��loop
	addne	r11, #1				@ ������ȥ��å�
	bne	reset_loop			@ loop
@------��λ--------------------------------------------
return:
	ldr	r12, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ ����Τ����loop