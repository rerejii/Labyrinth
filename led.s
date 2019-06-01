@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1,	labyrinth_paramerers����Ƭ����
@r2~12,	�黻�ѵڤӼ����Ϥ���	
@------------------------
	.include "include.inc" 
	.section .text
	.global led
led:
@-----�ǡ�������¸-------------------------------------
backup:
	str	r7, [sp, #-4]!			@ push
	str	r8, [sp, #-4]!			@ push
	str	r9, [sp, #-4]!			@ push
 	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push

@-----���ư�ưȽ��-----------------------------------------
first_now:
	ldrb	r12, [r1, #TASK_FIRST_SW]	@ ���ư��Ƚ���ͤ�������
	cmp	r12, #1				@ ���ư���ư���뤫?
	ldreq	r11, =first_flag		@ first_flag������
	streqb	r12, [r11]			@ �񤭹���
	
@-----�����ư----------------------------------------
first_task:
	ldr	r12, =first_flag		@ r12��first_flag������
	ldrb	r11, [r12]			@ �����ư�Υե饰�����
	cmp	r11, #1				@ ���Ƥε�ư��?
	bne	first_end			@ ��λ
	mov	r11, #0				@ 0��Ǽ
	strb	r11, [r12]			@ �ե饰���ޤ�

	mov	r12, #3				@ loop�������
	ldr	r11, =add_time_led		@ add_time_led�����ϼ���
	mov	r10, #0				@ �����
	ldrb	r8, [r1, #TORCH_LEVEL]		@ �ȡ�����٥��������
	mov	r8, r8, lsl #2			@ 4�ܤ��ƺ�ɸ�����
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
	ldr	r11, =time_led			@ time_led�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop
first_end:

	ldrb	r12, [r1, #TORCH_LEVEL]		@ ������٥����Ф�
	cmp	r12, #0				@ ������٥뤬0�ʤ�
	@ GPIO #10 �� 0 �����
	moveq	r7, #(1 << (LED_PORT % 32))
	streq	r7, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	beq	return

c_time_led:
	mov	r12, #0				@ loop�������
	ldr	r11, =time_led			@ time_input�����ϼ���
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
	@ GPIO #10 �� 0 �����
	movcc	r7, #(1 << (LED_PORT % 32))
	strcc	r7, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	bcc	return				@ ��λ

	mov	r12, #3				@ loop�������
	ldr	r11, =add_time_led		@ add_time_led�����ϼ���
	mov	r7, #0				@ �����
	ldrb	r8, [r1, #TORCH_LEVEL]		@ �ȡ�����٥��������
	mov	r8, r8, lsl #2			@ 4�ܤ��ƺ�ɸ�����
1:
	add	r9, r12, r8			@ ��ɸ�򻻽�
	ldrb	r9, [r11, r9]			@ �������
	add	r7, r7, r9			@ ­��
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	movne	r7, r7, lsl #BYTE		@ ������ä�Byte�򤺤餷��Ĵ��
	bne	1b				@ loop
	add	r10, r10, r7			@ ���֤ι���
	
	ldrb	r12, [r1, #TORCH_POWER]		@ �����ζ�������Ф�
	rsb	r12, r12, #100			@ ���äƤ���POWER�򻻽�
	mov	r11, #10			@ 10
	mul	r12, r11, r12			@ 10�ܤ���
	add	r10, r10, r12			@ ���äƤ���POWER��LED�˱ƶ�������
	
	ldr	r11, =time_led			@ time_led�����ϼ���
	mov	r12, #3				@ loop�������
1:
	strb	r10, [r11, r12]			@ ����
	mov	r10, r10, lsr #BYTE		@ �񤭹��߽���ä�1Byte�򱦤ˤ��餹
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ ������ȥ�����
	bne	1b				@ loop

	@ GPIO #10 �� 1 �����
	mov     r7, #(1 << (LED_PORT % 32))
	str     r7, [r0, #(GPSET0 + LED_PORT / 32 * 4)]
	

@-----��λ--------------------------------------------	
return:
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	ldr	r8, [sp], #4			@ pop
	ldr	r7, [sp], #4			@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ ����Τ����loop

@======data==========================================
	.section .data

light_sw:	.byte 0
	
@���Υ��֥쥸������ƤӽФ����ΤϻϤ�Ƥ��Υե饰
first_flag:	.byte 1	
	
@�ȡ�����٥�˹�碌�����֥��å�
add_time_led:	.word 0, 3200, 2200, 1200, 200

@LEDȽ��˻Ȥ����֤��Ǽ
time_led:	.word 0
	
