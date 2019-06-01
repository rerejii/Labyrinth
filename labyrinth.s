@++++++test++++++++++++++++++++++++++++++++++++++++++++++
@	mov	r1, #(1 << (10 % 32))
@	str	r1, [r0, #(0x1C + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@---�쥸�����μ���------------
@r0, 	GPIO_BASE
@r1~12,	�黻�ѵڤӼ����Ϥ���	
@------------------------
	.equ	LABYRINTH_SIZE_X,	20			@ ��ӥ�󥹤�x�����Υ�����
	.equ	LABYRINTH_SIZE_Y,	19			@ ��ӥ�󥹤�y�����Υ�����
	.equ	PLAYER_START_X,		5			@ �ץ쥤�䡼�������Ȼ�x��ɸ
	.equ	PLAYER_START_Y,		6			@ �ץ쥤�䡼�������Ȼ�y��ɸ
	.equ	MAP_START_X,		12			@ �ޥåפΥ������Ȼ�x��ɸ
	.equ	MAP_START_Y,		11			@ �ޥåפΥ������Ȼ�y��ɸ
	.equ	GOAL_X,			2			@ �ޥåפΥ������Ȼ�x��ɸ
	.equ	GOAL_Y,			0			@ �ޥåפΥ������Ȼ�y��ɸ
	.equ	TORCH_START,		4			@ �����Υ������Ȼ����̥�٥�
	.equ	TORCH_SECONDS,		10			@ ������٥뤬����ޤǤ��ÿ�
	.equ	TORCH_POWER,		0			@ ����LEDĴ����

	.equ	SELECT_MAP,		1			@ �ޥå�������̤Ǥθ��ߤ�����ޥå�
	.equ	PLAYER_START_MAP_Y,	4
	
	.include "include.inc" 
	.section .init
	.global _start
_start:

@-----�����쥸����------------------------------------------
	ldr	r0, =GPIO_BASE			@ �١������ɥ쥹
	mov	sp, #STACK			@ �����å��ݥ���
@------�������----------------------------------------------
	@ LED�ȥǥ����쥤�Ѥ�IO�ݡ��Ȥ���Ϥ����ꤹ��
	ldr	r1, =GPFSEL_VEC0
	str	r1, [r0, #GPFSEL0 + 0]
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL0 + 4]
	ldr	r1, =GPFSEL_VEC2
	str	r1, [r0, #GPFSEL0 + 8]
@-----(PWM �Υ���å������������ꤹ��)-------------------------------------------
	@ Set PWM clock source
	@src = osc, divider = 2.0
	
	ldr     r12, =CM_BASE
	ldr     r11, =0x5a000021                     @  src = osc, enable=false
	str     r11, [r12, #CM_PWMCTL]

1:    @ wait for busy bit to be cleared
	ldr     r11, [r12, #CM_PWMCTL]
	tst     r11, #0x80
	bne     1b

	ldr     r11, =(0x5a000000 | (2 << 12))  @ div = 2.0
	str     r11, [r12, #CM_PWMDIV]
	ldr     r11, =0x5a000211                   @ src = osc, enable=true
	str     r11, [r12, #CM_PWMCTL]
@----------------==-=-==-===-=-=-==-=-=-==-==---==-==-=-=-=--==-=-=-==-=-=-
@=============================================================================================================================
@======taskSet_map_select=====================================================================================================
taskSet_map_select:				@ loop��������
@------���̽��ϥ�����-----------------------------------------
mapTask_mapSelect_print:
	ldr	r1, =mapSelect_paramerers	@ r1��mapSelect_paramerers����Ƭ���Ϥ�
	bl	mapSelect_print			@ print��ƤӽФ�
@------���ϼ��ե�����-----------------------------------------
mapTask_input_mapVer:
	ldr	r1, =sw_value			@ r1��sw_value����Ƭ���Ϥ�
	bl	input				@ input��ƤӽФ�
@------�ޥå��ѹ�������---------------------------------------
mapTask_mapChange:
	ldr	r1, =mapSelect_paramerers	@ r1��mapSelect_paramerers����Ƭ���Ϥ�
	ldr	r2, =sw_value			@ r1��sw_value����Ƭ���Ϥ�
	bl	mapChange			@ mapChange�θƤӽФ�
mapTask_unabara:	
	bl	unabara				@ music�ֳ����פθƤӽФ�
@******�����ͽ����������***************************************
mapTask_inputReset:
	ldr	r1, =sw_value			@ r1��sw_value����Ƭ���Ϥ�
	bl	inputReset			@ inputReset�ƤӽФ�
@------taskSet_play loop--------------------------------------	
	b	taskSet_map_select		@ task��loop�����ơ����줾���task��Ƚ�ꤵ����

@------��ӥ�󥹥ǡ����񤭹��ߥ�����-------------------------------
	ldr	r1, =labyrinth_data		@ r1��labyrinth_data����Ƭ���Ϥ�
	ldr	r2, =labyrinth_paramerers	@ r2��labyrinth_paramerers����Ƭ���Ϥ�
	ldr	r3, =mapSelect_paramerers	@ r3��mapSelect_paramerers����Ƭ���Ϥ�

	
@=============================================================================================================================
@======taskSet_play===========================================================================================================
taskSet_play:					@ loop��������
@------���̽��ϥ�����-----------------------------------------
task_print:
	ldr	r1, =labyrinth_data		@ r1��labyrinth_data����Ƭ���Ϥ�
	ldr	r2, =labyrinth_paramerers	@ r2��labyrinth_paramerers����Ƭ���Ϥ�
	bl	print				@ print��ƤӽФ�
@------���ϼ��ե�����-----------------------------------------
task_input_playVer:
	ldr	r1, =sw_value			@ r1��sw_value����Ƭ���Ϥ�
	bl	input				@ input��ƤӽФ�
@------��ưȽ�꥿����-----------------------------------------
task_move:
	ldr	r1, =labyrinth_data		@ r1��labyrinth_data����Ƭ���Ϥ�
	ldr	r2, =labyrinth_paramerers	@ r2��labyrinth_paramerers����Ƭ���Ϥ�
	ldr	r3, =sw_value			@ r3��sw_value����Ƭ���Ϥ�
	bl	move				@ move��ƤӽФ�
@------����Ƚ�꥿����-----------------------------------------
task_torch:
	ldr	r1, =labyrinth_paramerers	@ r1��labyrinth_paramerers����Ƭ���Ϥ�
	bl	torch				@ torch��ƤӽФ�
@------��LEDȽ�꥿����---------------------------------------
task_led:
	ldr	r1, =labyrinth_paramerers	@ r1��labyrinth_paramerers����Ƭ���Ϥ�
	bl	led				@ led��ƤӽФ�
@******�����ͽ����������***************************************
task_inputReset:
	ldr	r1, =sw_value			@ r1��sw_value����Ƭ���Ϥ�
	bl	inputReset			@ inputReset�ƤӽФ�
@------�����४����Ƚ��---------------------------------------
task_checkGameover:	
	ldr	r1, =labyrinth_paramerers	@ r1��sw_value����Ƭ���Ϥ�
	ldrb	r2, [r1, #TORCH_LEVEL]		@ ������٥����Ф�
	cmp	r2, #0				@ ������٥뤬0?
	moveq	r7, #(1 << (10 % 32))
	streq	r7, [r0, #(0x28 + 10 / 32 * 4)]
	beq	taskSet_gameover		@ �����४�����ѥ��������åȤ�����
@------taskSet_play loop--------------------------------------	
	b	taskSet_play			@ task��loop�����ơ����줾���task��Ƚ�ꤵ����

	
@============================================================================================================================
@======taskSet_gameover======================================================================================================
taskSet_gameover:				@ loop��������

@------�����४����ɽ��������-------------------------------------
task_gameoverPrint:
	ldr	r1, =labyrinth_data		@ r1��labyrinth_data����Ƭ���Ϥ�
	ldr	r2, =labyrinth_paramerers	@ r1��sw_value����Ƭ���Ϥ�
	bl	gameoverPrint			@ gameoverPrint�ƤӽФ�
	
@------taskSet_gameover loop--------------------------------------	
	b	taskSet_gameover		@ task��loop�����ơ����줾���task��Ƚ�ꤵ����
	
@======safety================================================
safety_loop:
	b	safety_loop			@ ����Τ����loop

@======data==================================================
	.section .data

mapSelect_paramerers:
	.byte SELECT_MAP
	.byte PLAYER_START_MAP_Y
	
labyrinth_paramerers:
	.byte LABYRINTH_SIZE_X, LABYRINTH_SIZE_Y 
	.byte MAP_START_X, MAP_START_Y
	.byte PLAYER_START_X, PLAYER_START_Y
	.byte GOAL_X, GOAL_Y
	.byte TORCH_START
	.byte TORCH_SECONDS
	.byte TORCH_POWER

@�����å��ξ��� �����ˤ�Ĺ�������Ϥ��Ƥ�������ư��Ƚ��˻Ȥ����͡פ���Ǽ�����
sw_value:		.byte 0, 0, 0, 0

@��ӥ�󥹤μ��� ���ơ�������κݤ�ޥåפ��ɤ߹��ߤ˻Ȥ�
labyrinth_type:		.byte 0

@��ӥ�󥹤Υޥå� 0�� 1�� ��x20*��y19
labyrinth_data:		.byte 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
			.byte 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
			.byte 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
			.byte 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1
			.byte 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1
			.byte 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1
			.byte 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1
			.byte 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1
			.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1
			.byte 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
			.byte 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1
			.byte 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1
			.byte 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1
			.byte 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1
			.byte 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
			.byte 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0 ,1, 1, 0, 1, 0, 1
			.byte 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1
			.byte 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1
			.byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1

	
