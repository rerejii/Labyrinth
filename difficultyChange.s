@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	mapSelect_paramerers����Ƭ����
@r2, 	sw_value����Ƭ����
@--------------------------

@------�ܥ���γ�꿶��ˤĤ���----------------------
@sw1: ����
@sw2: ����
@sw3: �墬
@sw4: ����
@------------------------------------------------
	.include "include.inc" 
	.section .text
	.global  difficultyChange

difficultyChange:
@------�ǡ�������¸-------------------------------------
backup:
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push

sw2:
	mov	r12, #1				@ sw2Ƚ��
	ldrb	r11, [r2, r12]			@ sw2���ͤ�������
	cmp	r11, #1				@ sw2��������Ƥ��뤫
	bne	sw2_end				@ ������Ƥ��ʤ����Ƚ�꽪λ
	ldrb	r10, [r1, #DIFFICULTY_POINT]	@ ������ͤ�������
	cmp	r10, #DIFFICULTY_MAX		@ ����MAX�ʤ�
	moveq	r10, #0				@ ����٤��᤹
	addne	r10, r10, #1			@ ������ͤ����䤹
	strb	r10, [r1, #DIFFICULTY_POINT]	@ ������ͤ򹹿�
sw2_end:	
	
@------��λ--------------------------------------------
return:
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	bx	r14
