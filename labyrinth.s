@++++++test++++++++++++++++++++++++++++++++++++++++++++++
@	mov	r1, #(1 << (10 % 32))
@	str	r1, [r0, #(0x1C + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1~12,	演算用及び受け渡し用	
@------------------------
	.equ	LABYRINTH_SIZE_X,	20			@ ラビリンスのx方向のサイズ
	.equ	LABYRINTH_SIZE_Y,	19			@ ラビリンスのy方向のサイズ
	.equ	PLAYER_START_X,		5			@ プレイヤースタート時x座標
	.equ	PLAYER_START_Y,		6			@ プレイヤースタート時y座標
	.equ	MAP_START_X,		12			@ マップのスタート時x座標
	.equ	MAP_START_Y,		11			@ マップのスタート時y座標
	.equ	GOAL_X,			2			@ マップのスタート時x座標
	.equ	GOAL_Y,			0			@ マップのスタート時y座標
	.equ	TORCH_START,		4			@ 松明のスタート時残量レベル
	.equ	TORCH_SECONDS,		10			@ 松明レベルが減るまでの秒数
	.equ	TORCH_POWER,		0			@ 松明LED調整用

	.equ	SELECT_MAP,		1			@ マップ選択画面での現在の選択マップ
	.equ	PLAYER_START_MAP_Y,	4
	
	.include "include.inc" 
	.section .init
	.global _start
_start:

@-----役固定レジスタ------------------------------------------
	ldr	r0, =GPIO_BASE			@ ベースアドレス
	mov	sp, #STACK			@ スタックポインタ
@------初期設定----------------------------------------------
	@ LEDとディスレイ用のIOポートを出力に設定する
	ldr	r1, =GPFSEL_VEC0
	str	r1, [r0, #GPFSEL0 + 0]
	ldr	r1, =GPFSEL_VEC1
	str	r1, [r0, #GPFSEL0 + 4]
	ldr	r1, =GPFSEL_VEC2
	str	r1, [r0, #GPFSEL0 + 8]
@-----(PWM のクロックソースを設定する)-------------------------------------------
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
taskSet_map_select:				@ loopここから
@------画面出力タスク-----------------------------------------
mapTask_mapSelect_print:
	ldr	r1, =mapSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	bl	mapSelect_print			@ printを呼び出し
@------入力受付タスク-----------------------------------------
mapTask_input_mapVer:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------マップ変更タスク---------------------------------------
mapTask_mapChange:
	ldr	r1, =mapSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	ldr	r2, =sw_value			@ r1にsw_valueの先頭番地を
	bl	mapChange			@ mapChangeの呼び出し
mapTask_unabara:	
	bl	unabara				@ music「海原」の呼び出し
@******入力値初期化タスク***************************************
mapTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
@------taskSet_play loop--------------------------------------	
	b	taskSet_map_select		@ taskをloopさせて、それぞれのtaskを判定させる

@------ラビリンスデータ書き込みタスク-------------------------------
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =mapSelect_paramerers	@ r3にmapSelect_paramerersの先頭番地を

	
@=============================================================================================================================
@======taskSet_play===========================================================================================================
taskSet_play:					@ loopここから
@------画面出力タスク-----------------------------------------
task_print:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	bl	print				@ printを呼び出し
@------入力受付タスク-----------------------------------------
task_input_playVer:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------移動判定タスク-----------------------------------------
task_move:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =sw_value			@ r3にsw_valueの先頭番地を
	bl	move				@ moveを呼び出し
@------松明判定タスク-----------------------------------------
task_torch:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	bl	torch				@ torchを呼び出し
@------緑LED判定タスク---------------------------------------
task_led:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	bl	led				@ ledを呼び出し
@******入力値初期化タスク***************************************
task_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
@------ゲームオーバ判定---------------------------------------
task_checkGameover:	
	ldr	r1, =labyrinth_paramerers	@ r1にsw_valueの先頭番地を
	ldrb	r2, [r1, #TORCH_LEVEL]		@ 松明レベルを取り出す
	cmp	r2, #0				@ 松明レベルが0?
	moveq	r7, #(1 << (10 % 32))
	streq	r7, [r0, #(0x28 + 10 / 32 * 4)]
	beq	taskSet_gameover		@ ゲームオーバ用タスクセットに飛べ
@------taskSet_play loop--------------------------------------	
	b	taskSet_play			@ taskをloopさせて、それぞれのtaskを判定させる

	
@============================================================================================================================
@======taskSet_gameover======================================================================================================
taskSet_gameover:				@ loopここから

@------ゲームオーバ表現タスク-------------------------------------
task_gameoverPrint:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r1にsw_valueの先頭番地を
	bl	gameoverPrint			@ gameoverPrint呼び出し
	
@------taskSet_gameover loop--------------------------------------	
	b	taskSet_gameover		@ taskをloopさせて、それぞれのtaskを判定させる
	
@======safety================================================
safety_loop:
	b	safety_loop			@ 万一のためのloop

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

@スイッチの状態 ここには長押し入力を弾いた、「動作判定に使われる値」が格納される
sw_value:		.byte 0, 0, 0, 0

@ラビリンスの種類 ステージ選択の際やマップの読み込みに使う
labyrinth_type:		.byte 0

@ラビリンスのマップ 0床 1壁 横x20*縦y19
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

	
