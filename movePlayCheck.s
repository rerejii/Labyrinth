	.equ	NEXT_MODE_TIME,		3000000		@ ���ν����˼����Ϥ��ޤǤλ���

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1, 	reset_mode
@r2,	check_next	
@------------------------

	.include "include.inc" 
	.section .init
	.global movePlayCheck
movePlayCheck:
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
	ldrb	r12, [r1]			@ ���ư��Ƚ���ͤ�������
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
@------time_next_mode�ν����--------------------------
	ldr	r11, =NEXT_MODE_TIME		@ ����������������
	add	r10, r11, r12			@ ��ư�ޤǤλ��֤�Ĵ��
	ldr	r11, =time_next_mode		@ time_next_mode�����ϼ���
	mov	r9, #3				@ loop�������
1:
	strb	r10, [r11, r9]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ ������ȥ�����
	bne	1b				@ loop

	mov	r11, #0				@ 0���Ǽ
	strb	r11, [r2]			@ check_next�Υե饰���ޤ�	
first_end:

@------time_next_mode��Ƚ��------------------------------
c_time_next_mode:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_next_mode		@ time_next_mode�����ϼ���
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
	bcc	c_time_next_mode_end		@ Ƚ�꽪λ

	ldr	r12, =NEXT_MODE_TIME		@ time��������
	add	r10, r10, r12			@ ���ε�ư���֤����
	mov	r12, #3				@ loop�������
	ldr	r11, =time_next_mode		@ time_next_mode�����ϼ���
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	mov	r12, #1				@ 1���Ǽ
	strb	r12, [r2]			@ check_next��1���Ϥ�
c_time_next_mode_end:
	
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

@���ν����λ���
time_next_mode:
	.byte 0

@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1
