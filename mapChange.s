	@-----���֥롼�����ͭ���-----
	
	
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
	.global  mapChange

mapChange:
@------�ǡ�������¸-------------------------------------
backup:
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push

sw3:
	mov	r12, #2				@ sw3Ƚ��
	ldrb	r11, [r2, r12]			@ sw3���ͤ�������
	cmp	r11, #1				@ sw3��������Ƥ��뤫
	bne	sw3_end				@ ������Ƥ��ʤ����Ƚ�꽪λ
	ldrb	r10, [r1, #SELECT_MAP_NUMBER]	@ Map�ͤ�������
	cmp	r10, #MAP_MIN			@ ����ü�ʤ�
	beq	sw3_end				@ Ƚ�꽪λ
	sub	r10, r10, #1			@ Map�ͤ򸺤餹
	strb	r10, [r1, #SELECT_MAP_NUMBER]	@ Map�ͤ򹹿�
sw3_end:	
	
sw4:	
	mov	r12, #3				@ sw4Ƚ��
	ldrb	r11, [r2, r12]			@ sw4���ͤ�������
	cmp	r11, #1				@ sw4��������Ƥ��뤫
	bne	sw4_end				@ ������Ƥ��ʤ����Ƚ�꽪λ
	ldrb	r10, [r1, #SELECT_MAP_NUMBER]	@ Map�ͤ�������
	cmp	r10, #MAP_MAX			@ ����ü�ʤ�
	beq	sw4_end				@ Ƚ�꽪λ
	add	r10, r10, #1			@ Map�ͤ򸺤餹
	strb	r10, [r1, #SELECT_MAP_NUMBER]	@ Map�ͤ򹹿�
sw4_end:	
	
@------��λ--------------------------------------------
return:
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	bx	r14
