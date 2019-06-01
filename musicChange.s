	@-----���֥롼�����ͭ���-----
	
	
@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	musicSelect_paramerers����Ƭ����
@r2, 	sw_value����Ƭ����
@r3,	reset_mode
@--------------------------

@------�ܥ���γ�꿶��ˤĤ���----------------------
@sw1: ����
@sw2: ����
@sw3: �墬
@sw4: ����
@------------------------------------------------
	.include "include.inc" 
	.section .text
	.global  musicChange

musicChange:
@------�ǡ�������¸-------------------------------------
backup:
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push
	str	r14, [sp, #-4]!			@ push

sw3:
	mov	r12, #2				@ sw3Ƚ��
	ldrb	r11, [r2, r12]			@ sw3���ͤ�������
	cmp	r11, #1				@ sw3��������Ƥ��뤫
	bne	sw3_end				@ ������Ƥ��ʤ����Ƚ�꽪λ
	ldrb	r10, [r1, #MUSIC_SELECT]	@ Map�ͤ�������
	cmp	r10, #MUSIC_MIN			@ ����ü�ʤ�
	beq	sw3_end				@ Ƚ�꽪λ
	sub	r10, r10, #1			@ Map�ͤ򸺤餹
	strb	r10, [r1, #MUSIC_SELECT]	@ Map�ͤ򹹿�
	bl	musicStop			@ musicStop�ƤӽФ�
	mov	r10, #1				@ 1���Ǽ
	strb	r10, [r3]			@ ���������ͭ��
sw3_end:	
	
sw4:	
	mov	r12, #3				@ sw4Ƚ��
	ldrb	r11, [r2, r12]			@ sw4���ͤ�������
	cmp	r11, #1				@ sw4��������Ƥ��뤫
	bne	sw4_end				@ ������Ƥ��ʤ����Ƚ�꽪λ
	ldrb	r10, [r1, #MUSIC_SELECT]	@ Map�ͤ�������
	cmp	r10, #MUSIC_MAX			@ ����ü�ʤ�
	beq	sw4_end				@ Ƚ�꽪λ
	add	r10, r10, #1			@ Map�ͤ򸺤餹
	strb	r10, [r1, #MUSIC_SELECT]	@ Map�ͤ򹹿�
	bl	musicStop			@ musicStop�ƤӽФ�
	mov	r10, #1				@ 1���Ǽ
	strb	r10, [r3]			@ ���������ͭ��
sw4_end:	
	
@------��λ--------------------------------------------
return:
	ldr	r14, [sp], #4			@ pop
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	bx	r14
