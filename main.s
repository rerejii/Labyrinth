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
	.equ	FIRST_TASK,		1			@ firstTaskを動かすかの判定スイッチ
	.equ	SW1,			0x0			@ スイッチ１
	.equ	SW2,			0x1			@ スイッチ2
	.equ	SW3,			0x2			@ スイッチ3
	.equ	SW4,			0x3			@ スイッチ4

	.equ	SELECT_MAP,		1			@ マップ選択画面での現在の選択マップ
	.equ	DIFFICULTY_POINT,	1			@ 難易度
	.equ	CHEAT_SWITE,		0			@ チートスイッチ

	.equ	SELECT_MUSIC,		0			@ 音楽選択値
	
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
	ldr	r1, =reset_mode
	mov	r2, #1
	strb	r2, [r1]
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
@======taskSet_firstMovie=====================================================================================================
taskSet_firstMovie:
@------firstMovie-----------------------------------------
firstTask_firstMovie:
	ldr	r1, =reset_mode
	ldr	r2, =movie_change_sw
	bl	firstMovie
@------input-----------------------------------------
firstTask_input:
	ldr	r1, =sw_value	
	bl	input
@------音楽タスク--------------------------------------------
firstTask_naito:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	bl	naito				@ music「ナイトオブナイツ」の呼び出し
@------Move the mapSelect-----------------------------------------
firstTask_chackInput:	
	mov	r1, #0				@ カウントリセット
	ldr	r2, =sw_value			@ sw_value
1:
	ldrb	r3, [r2, r1]
	cmp	r3, #1
	ldreq	r4, =reset_sw
	moveq	r5, #1
	streqb	r5, [r4]
	cmp	r1, #3
	addne	r1, r1, #1
	bne	1b
@------リセットタスク-------------------------------------------
firstTask_Reset:
	ldr	r1, =reset_sw			@ リセットを制御する変数reset_swの先頭番地を
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	ldreq	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bleq	inputReset			@ inputReset呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
@------動画移行タスク-------------------------------------------
firstTask_nextMovie:
	ldr	r1, =movie_change_sw
	ldrb	r2, [r1]
	cmp	r2, #1
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ movie_change_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	beq	taskSet_LabyMoji		@ マップ選択画面に戻る
	
@******入力値初期化タスク***************************************
firstTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し

@******初期動作OFFタスク***************************************
firstTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------taskSet_firstMovie loop--------------------------------------	
	b	taskSet_firstMovie		@ taskをloopさせて、それぞれのtaskを判定させる	
	
@=============================================================================================================================
@======taskSet_LabyMoji=====================================================================================================
taskSet_LabyMoji:
@------firstMovie-----------------------------------------
LabiMojiTask_firstMovie:
	ldr	r1, =reset_mode
	bl	Labymoji
@------input-----------------------------------------
LabiMojiTask_input:
	ldr	r1, =sw_value	
	bl	input				
@------Move the mapSelect-----------------------------------------
LabiMojiTask_chackInput:	
	mov	r1, #0				@ カウントリセット
	ldr	r2, =sw_value			@ sw_value
1:
	ldrb	r3, [r2, r1]
	cmp	r3, #1
	ldreq	r4, =reset_sw
	moveq	r5, #1
	streqb	r5, [r4]
	cmp	r1, #3
	addne	r1, r1, #1
	bne	1b
@------リセットタスク-------------------------------------------
LabiMojiTask_Reset:
	ldr	r1, =reset_sw			@ リセットを制御する変数reset_swの先頭番地を
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	ldreq	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bleq	inputReset			@ inputReset呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
	
@******入力値初期化タスク***************************************
LabiMojiTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し


	
@******初期動作OFFタスク***************************************
LabiMojiTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------音楽タスク--------------------------------------------
LabiMojiTask_naito:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	bl	naito				@ music「ナイトオブナイツ」の呼び出し
@------taskSet_LabyMoji loop--------------------------------------	
	b	taskSet_LabyMoji		@ taskをloopさせて、それぞれのtaskを判定させる

	
@=============================================================================================================================
@======taskSet_map_select=====================================================================================================
taskSet_map_select:				@ loopここから
@------画面出力タスク-----------------------------------------
mapTask_mapSelect_print:
	ldr	r1, =mapSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	ldr	r2, =reset_mode			@ r2にreset_modeの先頭番地
	bl	mapSelect_print			@ printを呼び出し
@------入力受付タスク-----------------------------------------
mapTask_input:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------マップ変更タスク---------------------------------------
mapTask_mapChange:
	ldr	r1, =mapSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	ldr	r2, =sw_value			@ r1にsw_valueの先頭番地を
	bl	mapChange			@ mapChangeの呼び出し
@------難易度変更タスク---------------------------------------
mapTask_difficultyChange:
	ldr	r1, =mapSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	ldr	r2, =sw_value			@ r1にsw_valueの先頭番地を
	bl	difficultyChange		@ difficultyChangeの呼び出し
@------音楽タスク--------------------------------------------
mapTask_unabara:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	bl	unabara				@ music「海原」の呼び出し
@------チートタスク--------------------------------------------
mapTask_cheat:
	ldr	r1, =mapSelect_paramerers	@ r2にmapSelect_paramerersの先頭番地を
	ldr	r2, =reset_mode			@ r1にreset_modeの先頭番地
	bl	check_cheatComand		@ check_cheatComandの呼び出し
@------ラビリンスゲーム移行タスク-------------------------------
mapTask_check_sw1:	
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	ldrb	r1, [r1, #SW1]			@ SW1
	cmp	r1, #1				@ SW1が押されたかの判定
	bne	mapTask_check_sw1_end		@ 違うなら終了
mapTask_checkTask:	
	bl	musicStop			@ musicStop呼び出し
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	ldr	r3, =mapSelect_paramerers	@ r3にmapSelect_paramerersの先頭番地を
	ldrb	r1, [r3, #SELECT_MAP_NUMBER]	@ セレクトナンバーを受け取る
	cmp	r1, #0				@ BadApple起動?
mapTask_labyrinthData:
	beq	taskSet_BadApple		@ taskSet_BadAppleに飛ぶ
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =mapSelect_paramerers	@ r3にmapSelect_paramerersの先頭番地を
	bl	labyrinthData			@ labyrinthDataの呼び出し
	b	taskSet_startAnime		@ strarAnimeタスクに飛べ
mapTask_check_sw1_end:
@******入力値初期化タスク***************************************
mapTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
@------リセット判定---------------------------------------
mapTask_checkMusicMode:
	ldr	r1, =music_mode_sw		@ 
	ldr	r2, =reset_mode			@ 
	bl	musicMode_check			@ musicModeに移行かの判定
	ldrb	r2, [r1]			@ music_mode_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ music_mode_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_music_select		@ taskSet_music_selectへ
@******初期動作OFFタスク***************************************
mapTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------taskSet_play loop--------------------------------------	
	b	taskSet_map_select		@ taskをloopさせて、それぞれのtaskを判定させる

	
@=============================================================================================================================
@======taskSet_music_select===================================================================================================
taskSet_music_select:				@ loopここから
@------入力受付タスク-----------------------------------------
musicTask_input:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------画面出力タスク-----------------------------------------
musicTask_mapSelect_print:
	ldr	r1, =musicSelect_paramerers	@ r1にmusicSelect_paramerersの先頭番地を
	ldr	r2, =reset_mode			@ r2にreset_modeの先頭番地
	bl	musicSelect_print		@ printを呼び出し
@------音楽変更タスク-----------------------------------------
musicTask_musicChange:
	ldr	r1, =musicSelect_paramerers	@ r1にmapSelect_paramerersの先頭番地を
	ldr	r2, =sw_value			@ r1にsw_valueの先頭番地を
	ldr	r3, =reset_mode			@ r2にreset_modeの先頭番地
	bl	musicChange			@ musicChangeの呼び出し
@------音楽タスク--------------------------------------------
musicTask_main:
	ldr	r3, =musicSelect_paramerers	@ musicSelect_paramerers
	ldrb	r3, [r3, #SELECT_MAP_NUMBER]	@ 選択中のマップ値を取り出す
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	cmp	r3, #1
	bleq	unabara				@ music「unabara」の呼び出し
	cmp	r3, #2
	bleq	akisisters			@ music「akisisters」の呼び出し
	cmp	r3, #3
	bleq	greengreens			@ music「greengreens」の呼び出し
	cmp	r3, #4
	bleq	bigbridge			@ music「bigbridge」の呼び出し
	cmp	r3, #5
	bleq	kirakira			@ music「kirakira」の呼び出し
	cmp	r3, #6
	bleq	heian				@ music「heian」の呼び出し
	cmp	r3, #7
	bleq	katyusya			@ music「katyusya」の呼び出し
	cmp	r3, #8
	bleq	naito				@ music「naito」の呼び出し
	cmp	r3, #9
	bleq	Fanfare_soundVer		@ music「Fanfare_soundVer」の呼び出し
	cmp	r3, #10
	bleq	DQ_dead_soundVer		@ music「DQ_dead_soundVer」の呼び出し
	cmp	r3, #11
	bleq	bad_music			@ music「bad_music」の呼び出し
	
@------バックタスク--------------------------------------------
musicTask_back:
	ldr	r1, =musicSelect_paramerers	@ musicSelect_paramerers
	ldr	r2, =sw_value			@ r2にスイッチの値を
	ldr	r3, =reset_sw			@ r3にreset_swの座標を
	bl	back_check			@ back_chekcに飛べ
@******初期動作OFFタスク***************************************
musicTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@******入力値初期化タスク***************************************
musicTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
@------リセット判定---------------------------------------
musicTask_checkReset:
	ldr	r1, =reset_sw
	bl	reset_check			@ resetを掛けるかの判定
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
@------taskSet_music loop--------------------------------------	
	b	taskSet_music_select		@ taskをloopさせて、それぞれのtaskを判定させる
	
	
@=============================================================================================================================
@======taskSet_BadApple=======================================================================================================
taskSet_BadApple:				@ loopここから
@------入力受付タスク-----------------------------------------
appleTask_input:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------画面出力----------------------------------------------
appleTask_bad_pv:
	ldr	r1, =reset_mode			@ r1にreset_modeの座標を
	bl	bad_pv
@------音声出力----------------------------------------------
appleTask_bad_music:
	ldr	r1, =reset_mode			@ r1にreset_modeの座標を
	bl	bad_music
@******初期動作OFFタスク***************************************
appleTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------リセット判定---------------------------------------
appleTask_checkReset:
	ldr	r1, =reset_sw
	bl	reset_check			@ resetを掛けるかの判定
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
@------taskSet_BadApple loop--------------------------------------	
	b	taskSet_BadApple		@ taskをloopさせて、それぞれのtaskを判定させる	


@=============================================================================================================================
@======taskSet_startAnime===========================================================================================================
taskSet_startAnime:				@ loopここから

@------画面出力タスク-----------------------------------------
strAniTask_print:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =reset_mode			@ r3にreset_modeの先頭番地を
	ldr	r4, =check_next			@ r4にcheck_nextの先頭番地を
	bl	startAnimation			@ startAnimationを呼び出し

@------ゲーム移行判定---------------------------------------
strAniTask_movePlay:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地を
	ldr	r2, =check_next			@ 次に移行するかの判定値格納番地
	bl	movePlayCheck			@ playに移るかの判定
	ldrb	r3, [r2]			@ 移行判定値を受け取る
	cmp	r3, #1				@ 移行するかの判定
	bne	strAniTask_movePlay_end		@ 判定終了
	mov	r3, #0				@ 0を格納
	strb	r3, [r2]			@ フラグを折る
	mov	r2, #1				@ 1を格納
	ldr	r3, =reset_mode			@ reset_modeの座標を受け取る
	strb	r2, [r3]			@ reset_modeを起動する
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	mov	r2, #1				@ 0を格納
	strb	r2, [r1, #TASK_FIRST_SW]	@ first_taskを1に
	bl	musicStop			@ musicStop呼び出し
	b	taskSet_play			@ playに移行
strAniTask_movePlay_end:	
	
	
@******初期動作OFFタスク***************************************
strAniTask_firstEnd:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1, #TASK_FIRST_SW]	@ first_taskを0に
strAniTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff


@------リセット判定---------------------------------------
strAniTask_checkReset:
	ldr	r1, =reset_sw
	bl	reset_check			@ resetを掛けるかの判定
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
	
@------taskSet_startAnime loop--------------------------------------	
	b	taskSet_startAnime		@ taskをloopさせて、それぞれのtaskを判定させる
	
@=============================================================================================================================
@======taskSet_play===========================================================================================================
taskSet_play:					@ loopここから
@------画面出力タスク-----------------------------------------
playTask_print:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	bl	print				@ printを呼び出し
@------入力受付タスク-----------------------------------------
playTask_input_playVer:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	input				@ inputを呼び出し
@------移動判定タスク-----------------------------------------
playTask_move:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =sw_value			@ r3にsw_valueの先頭番地を
	bl	move				@ moveを呼び出し
@------松明判定タスク-----------------------------------------
playTask_torch:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	bl	torch				@ torchを呼び出し
@------緑LED判定タスク---------------------------------------
playTask_led:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	bl	led				@ ledを呼び出し
@------音楽タスク--------------------------------------------
playTask_unabara:
	ldr	r3, =mapSelect_paramerers	@ mapSelect_paramerers
	ldrb	r3, [r3, #SELECT_MAP_NUMBER]	@ 選択中のマップ値を取り出す
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	cmp	r3, #1
	bleq	akisisters			@ music「akisisters」の呼び出し
	cmp	r3, #2
	bleq	greengreens			@ music「greengreens」の呼び出し
	cmp	r3, #3
	bleq	bigbridge			@ music「bigbridge」の呼び出し
	cmp	r3, #4
	bleq	kirakira			@ music「kirakira」の呼び出し
	cmp	r3, #5
	bleq	heian				@ music「heian」の呼び出し
	cmp	r3, #6
	bleq	katyusya			@ music「katyusya」の呼び出し
@******初期動作OFFタスク***************************************
playTask_firstEnd:
	ldr	r1, =labyrinth_paramerers	@ r1にlabyrinth_paramerersの先頭番地を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1, #TASK_FIRST_SW]	@ first_taskを0に
playTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@******入力値初期化タスク***************************************
playTask_inputReset:
	ldr	r1, =sw_value			@ r1にsw_valueの先頭番地を
	bl	inputReset			@ inputReset呼び出し
@------ゲームオーバ判定---------------------------------------
playTask_checkGameover:	
	ldr	r1, =labyrinth_paramerers	@ r1にsw_valueの先頭番地を
	ldrb	r2, [r1, #TORCH_LEVEL]		@ 松明レベルを取り出す
	cmp	r2, #0				@ 松明レベルが0?
	moveq	r1, #1				@ リセットモードON
	ldreq	r2, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r1, [r2]			@ 初期化モード起動
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_gameOver		@ ゲームオーバ用タスクセットに飛べ
@------ゲームクリア判定---------------------------------------
playTask_checkGameclear:
	ldr	r1, =labyrinth_paramerers	@ r1にsw_valueの先頭番地を
	ldrb	r2, [r1, #PLAYER_COORDINATE_X]	@ プレイヤーのx座標
	ldrb	r3, [r1, #MAP_COORDINATE_X]	@ マップのx座標
	add	r2, r2, r3			@ プレイヤーが存在している座標を求める
	ldrb	r3, [r1, #GOAL_COORDINATE_X]	@ ゴールのx座標
	cmp	r2, r3				@ x座標がゴールと同じか?
	bne	playTask_checkGameclear_end	@ 違うなら判定終了
	ldrb	r2, [r1, #PLAYER_COORDINATE_Y]	@ プレイヤーのy座標
	ldrb	r3, [r1, #MAP_COORDINATE_Y]	@ マップのy座標
	add	r2, r2, r3			@ プレイヤーが存在している座標を求める
	ldrb	r3, [r1, #GOAL_COORDINATE_Y]	@ ゴールのy座標
	cmp	r2, r3				@ y座標がゴールと同じか?
	moveq	r1, #1
	ldreq	r2, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r1, [r2]			@ 初期化モード起動
	moveq	r1, #(1 << (LED_PORT % 32))	@ 格納値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_gameClear		@ ゲームクリア用タスクセットに飛べ
playTask_checkGameclear_end:	
@------リセット判定---------------------------------------
playTask_checkReset:
	ldr	r1, =reset_sw
	bl	reset_check			@ resetを掛けるかの判定
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
	
@------taskSet_play loop--------------------------------------	
	b	taskSet_play			@ taskをloopさせて、それぞれのtaskを判定させる


@============================================================================================================================
@======taskSet_gameClear=====================================================================================================
taskSet_gameClear:				@ loopここから
@------音楽タスク--------------------------------------------
clrTask_unabara:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	bl	Fanfare				@ music「Fanfare」の呼び出し
@------ゲームクリア表現タスク-------------------------------------
clrTask_clearPrint:
	ldr	r1, =reset_mode			@ 初期化するかの判定
	ldr	r2, =next_start			@ 次のステージに進むフラグ番地
	bl	clearPrint			@ clearPrintの呼び出し
@------ネクストステージタスク-------------------------------------
clrTask_nextCheck:	
	ldr	r1, =next_start			@ 次のステージに進むフラグ番地
	ldrb	r2, [r1]			@ フラグ状況の取得
	cmp	r2, #1				@ フラグが立っているか
	bne	clrTask_nextCheck_end		@ フラグが立っていなければ終了
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ フラグ初期化
	ldr	r1, =mapSelect_paramerers	@ mapSelect_paramerersの先頭番地を受け取る
	ldrb	r2, [r1, #SELECT_MAP_NUMBER]	@ 現在選択中のマップの値を受け取る
	cmp	r2, #MAP_MAX			@ 現在のマップが最終か?
	addne	r2, r2, #1			@ マップを1つ進める
	moveq	r2, #1				@ マップを最初に戻す
	strb	r2, [r1, #SELECT_MAP_NUMBER]	@ マップの値を更新する
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にlabyrinth_paramerersの先頭番地を
	ldr	r3, =mapSelect_paramerers	@ r3にmapSelect_paramerersの先頭番地を
	bl	labyrinthData			@ labyrinthDataの呼び出し(ラビリンスの更新)
	bl	musicStop			@ musicStop呼び出し
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	b	taskSet_play			@ ゲーム開始
clrTask_nextCheck_end:	
@******初期動作OFFタスク***************************************
clrTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------リセット判定---------------------------------------
clrTask_checkReset:
	ldr	r1, =reset_sw
	bl	reset_check			@ resetを掛けるかの判定
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
@------taskSet_gameClear loop--------------------------------------	
	b	taskSet_gameClear		@ taskをloopさせて、それぞれのtaskを判定させる
	
@============================================================================================================================
@======taskSet_gameOver======================================================================================================
taskSet_gameOver:				@ loopここから

@------ゲームオーバ表現タスク-------------------------------------
outTask_gameoverPrint:
	ldr	r1, =labyrinth_data		@ r1にlabyrinth_dataの先頭番地を
	ldr	r2, =labyrinth_paramerers	@ r2にsw_valueの先頭番地を
	ldr	r3, =reset_sw			@ r3にリセットを制御する変数reset_swの先頭番地を
	ldr	r4, =reset_mode			@ r4にreset_modeの先頭番地
	bl	gameoverPrint			@ gameoverPrint呼び出し
	ldrb	r1, [r3]			@ reset_swの値を受け取る
	cmp	r3, #1				@ リセットをかけるか?
	beq	outTask_Reset			@ リセット
@------音楽タスク--------------------------------------------
outTask_unabara:
	ldr	r1, =reset_mode			@ r1にreset_modeの先頭番地
	bl	DQ_dead				@ music「DQの全滅」の呼び出し
@------リセット判定---------------------------------------------
outTask_checkReset:
	ldr	r1, =reset_sw			@ リセットを制御する変数reset_swの先頭番地を
	bl	reset_check			@ resetを掛けるかの判定
@------リセットタスク-------------------------------------------
outTask_Reset:
	ldr	r1, =reset_sw			@ リセットを制御する変数reset_swの先頭番地を
	ldrb	r2, [r1]			@ reset_swの値を受け取る
	cmp	r2, #1				@ リセットONか?
	moveq	r2, #0				@ 0を格納
	streqb	r2, [r1]			@ reset_swを初期化
	moveq	r2, #1				@ 1を格納
	ldreq	r3, =reset_mode			@ reset_modeの座標を受け取る
	streqb	r2, [r3]			@ reset_modeを起動する
	moveq	r1, #(1 << (LED_PORT % 32))	@ LEDポートに格納する値を取得
	streq	r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]	@ LEDを消す
	bleq	musicStop			@ musicStop呼び出し
	beq	taskSet_map_select		@ マップ選択画面に戻る
@******初期動作OFFタスク***************************************
outTask_resetMode_off:	
	ldr	r1, =reset_mode			@ reset_modeの座標を
	mov	r2, #0				@ 0を格納
	strb	r2, [r1]			@ 初期動作をoff
@------taskSet_gameover loop--------------------------------------	
	b	taskSet_gameOver		@ taskをloopさせて、それぞれのtaskを判定させる
	
@======safety================================================
safety_loop:
	b	safety_loop			@ 万一のためのloop

@======data==================================================
	.section .data
movie_change_sw:
	.byte
	
@プレイモードに移行するかのスイッチ
check_next:
	.byte 0
	
@ミュージックモードにいこうするかのスイッチ
music_mode_sw:
	.byte 0
@ミュージックモードのパラメータ
musicSelect_paramerers:
	.byte SELECT_MUSIC
	
@clear状態から次のステージに進む判定
next_start:
	.byte 0
	
@リセットをするか否かの判定値
reset_sw:
	.byte 0

@初期化モード
reset_mode:
	.byte 0
@マップ選択時のパラメータ
mapSelect_paramerers:
	.byte SELECT_MAP
	.byte DIFFICULTY_POINT
	.byte CHEAT_SWITE
	
@ゲーム時のパラメータ
labyrinth_paramerers:
	.byte LABYRINTH_SIZE_X, LABYRINTH_SIZE_Y 
	.byte MAP_START_X, MAP_START_Y
	.byte PLAYER_START_X, PLAYER_START_Y
	.byte GOAL_X, GOAL_Y
	.byte TORCH_START
	.byte TORCH_SECONDS
	.byte TORCH_POWER
	.byte FIRST_TASK

@スイッチの状態 ここには長押し入力を弾いた、「動作判定に使われる値」が格納される
sw_value:		.byte 0, 0, 0, 0

@ラビリンスの種類 ステージ選択の際やマップの読み込みに使う
labyrinth_type:		.byte 0

@ラビリンスのマップ 0床 1壁 
labyrinth_data:		.space 2000




	
