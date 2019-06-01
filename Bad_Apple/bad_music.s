@ ?ステージ使用音源　「Bad Apple!!」~東方より~
	
@======システム上の定数===================================================================
	.equ    PWM_HZ, 9600 * 1000
	.equ	GPIO_BASE,	0x3f200000	@ GPIOベースアドレス
	.equ	CM_BASE, 	0x3f101000	@クロックソースのベースアドレス
	.equ	PWM_BASE, 	0x3f20c000	@PWM を制御するためのレジスタのベースアドレス
	.equ	GPFSEL0,	0x00		@ GPIOポートの機能を選択する番地のオフセット
	.equ	GPSET0,		0x1C		@ GPIOポートの出力値を1にするための番地のオフセット
	.equ	GPCLR0,		0x28		@ GPIOボートの出力値を0にするための番地のオフセット
	.equ	CM_PWMCTL, 	0xa0
	.equ	CM_PWMDIV, 	0xa4
	.equ	GPFSEL_VEC0,	0x0
	.equ	GPFSEL_VEC1,	0x10000001	@ GPFSEL1 に設定する値 (GPIO #10 , #19 を出力用に設定)
	.equ	GPSET0,	0x1C			@ GPIOポートの出力値を1にするための番地のオフセット
	.equ	GPFSEL_VEC2,	0x0
	.equ	PWM_CLT, 	0x0
	.equ	PWM_PWEN2, 	8
	.equ	PWM_MSEN2, 	15
	.equ	PWM_RNG2, 	0x20
	.equ	PWM_DAT2, 	0x24
	.equ	LED_PORT,   10           @ LEDが接続されたGPIOのポート番号
	.equ	TIMER_BASE, 0x3f003000		@ システムタイマの制御レジスタのベースアドレス
	.equ	CLO,	 0x4			@ システムタイマの下位32bitを示すオフセット
	.equ	TIME1, 5000000
	.equ 	LED_PORT,   	10           @ LEDが接続されたGPIOのポート番号
	.equ	BYTE,			8			@ 8bit=1Byte
@======システム上の定数===================================================================

@======周波数定数===================================================================
	.equ	KEY_Re0, 146	@ レ2オク下
	.equ	KEY_Mi0, 164	@ ミ2オク下
	.equ	KEY_Fa0, 173	@ ファ2オク下
	.equ	KEY_Dos1, 277	@ ド♯1オク下
	.equ	KEY_Re1, 293	@ レ1オク下
	.equ	KEY_Res1, 311	@ レ♯1オク下
	.equ	KEY_Fa1, 349	@ ファ1オク下
	.equ	KEY_Fas1, 369	@ ファ#1オク下
	.equ	KEY_Sos1, 415	@ ソ♯1オク下
	.equ	KEY_Dos, 554	@ ド♯
	.equ	KEY_Res, 622	@ レ♯
	.equ	KEY_Fa,  698	@ ファ
	.equ	KEY_Fas, 739	@ ファ♯
	.equ	KEY_Sos, 830	@ ソ♯
	.equ	KEY_Ras, 932	@ ラ♯
	.equ	KEY_Dos2, 1108	@ ド♯1オク上
	.equ	KEY_Res2, 1244	@ レ♯1オク上
	.equ	KEY_Fa2,  1396	@ ファ1オク上
	.equ	KEY_Fas2, 1479	@ ファ♯1オク上
	.equ	KEY_Sos2, 1661	@ ソ♯1オク上
	.equ	KEY_Ras2, 1760	@ ラ♯1オク上
@======周波数定数===================================================================

	
	.section .init
	.global bad_music
bad_music:
@-----データの保存-------------------------------------
backup:
	str	r7, [sp, #-4]!	@ push
	str	r8, [sp, #-4]!	@ push
	str	r9, [sp, #-4]!	@ push
 	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
@------初期動作-----------------------------------
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る

	mov	r12, #3				@ loopカウント
	ldr	r11, =music_data		@ music_dataの番地取得
	mov	r10, #0				@ 初期化
	ldr	r8, =read_point			@ 読み込むデータ番号の番地
	ldrb	r8, [r8]			@ 読み込むデータ番号の番号を受け取る
	mov	r8, r8, lsl #3			@ 8倍して座標を求める
	add	r8, r8, #4			@ music_dataの流す時間の座標を求める
1:
	add	r9, r12, r8			@ 座標を算出
	ldrb	r9, [r11, r9]			@ 受け取る
	add	r10, r10, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r10, r10, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	
	add	r10, r10, r12			@ 起動までの時間を調整
	ldr	r11, =time_sound		@ time_soundの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
first_end:	

@------タイマー動作-----------------------------------
check_time_sound:
@------time_sound取得------
	ldr	r11, =time_sound		@ time_soundの番地取得
	mov	r10, #0				@ 初期化
	mov	r12, #0				@ loop初期化

1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r10, r10, r9			@ 足す
	cmp	r12, #3				@ looe_end?
	addne	r12, r12, #1			@ カウントダウン
	movne	r10, r10, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	cmp	r12, r10			@ 時間の判定
	bcc	check_time_sound_end		@ 起動時間に成ってなければ終了
@------read_point更新------
	mov	r12, #3				@ loopカウント
	ldr	r11, =read_point		@ 読み込むデータ番号座標
	mov	r8, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r8, r8, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r8, r8, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
@ここでr8にread_pointの値が格納される
	mov	r12, #3				@ loopカウント
	ldr	r11, =music_size		@ 読み込むデータ番号座標
	mov	r7, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r7, r7, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r7, r7, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
@ここでr7にmusic_sizeの値が格納される
	add	r8, r8, #1			@ r8に値を1つ足す(pointを進める)
	cmp	r8, r7				@ データの最後までいったか?
@++++++ここで、最後まで行った際の処理を書く++++++
	moveq	r8, #0				@ 最後まで行ったら最初にloop
@read_pointを更新
	mov	r12, #0				@ loopカウント
	ldr	r11, =read_point		@ 書き込むデータ番号座標
1:
	strb	r8, [r11, r12]			@ 値を更新
	cmp	r12, #3				@ loopが終了したか?
	addne	r12, r12, #1			@ loopカウントアップ
	movne	r8, r8, lsr #BYTE		@ 書き込み終わったbitをずらす
	bne	1b				@ loop
@------music_data->time取得------

	mov	r12, #3				@ loopカウント
	ldr	r11, =read_point		@ 読み込むデータ番号座標
	mov	r8, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r8, r8, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r8, r8, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	mov	r12, #3				@ loopカウント
	ldr	r11, =music_data		@ music_dataの番地取得
	mov	r7, #0				@ 初期化
	
	mov	r8, r8, lsl #3			@ 8倍して座標を求める
	add	r8, r8, #4			@ music_dataの流す時間の座標を求める
1:
	add	r9, r12, r8			@ 座標を算出
	ldrb	r9, [r11, r9]			@ 受け取る
	add	r7, r7, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r7, r7, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
@------time_sound更新------	
	add	r10, r10, r7			@ time合計算出
	ldr	r11, =time_sound		@ time_soundの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
check_time_sound_end:	
@------タイマー動作end-----------------------------------

	
@------music_dataの取得番地算出------
	mov	r12, #3				@ loopカウント
	ldr	r11, =read_point		@ 読み込むデータ番号座標
	mov	r8, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r8, r8, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r8, r8, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	mov	r8, r8, lsl #3			@ 8倍して座標調整
	mov	r12, #3				@ loopカウント
	ldr	r11, =music_data		@ music_dataの番地取得
@------周波数データの取得------
	mov	r12, #3				@ loopカウント
	mov	r10, #0				@ 初期化
1:
	add	r9, r12, r8			@ 座標を算出
	ldrb	r9, [r11, r9]			@ 受け取る
	add	r10, r10, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r10, r10, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop

	cmp	r10, #0
	@(PWM の動作モードを設定する)
	ldr	r12, =PWM_BASE		@ PWM を制御するためのレジスタのベースアドレス
	ldreq	r9, =(0 << PWM_PWEN2)	@ PWEN2bit目まで1を左シフト
	ldreq	r8, =(0 << PWM_MSEN2)	@ MSEN2bit目まで1を左シフト
	ldrne	r9, =(1 << PWM_PWEN2)	@ PWEN2bit目まで1を左シフト
	ldrne	r8, =(1 << PWM_MSEN2)	@ MSEN2bit目まで1を左シフト
	orr	r9, r9, r8		@ 合体
	str	r9, [r12, #PWM_CLT]
	beq	return
	
	@ 音を鳴らす
	ldr	r11, =PWM_HZ
	udiv	r10, r11, r10
	ldr	r12, =PWM_BASE
	str	r10, [r12, #PWM_RNG2]
	lsr	r10, r10, #1			
	str	r10, [r12, #PWM_DAT2]

@-----終了--------------------------------------------	
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
	b	safety_loop		@ 万一のためのloop

	
loop:
    b    loop

	.section .data

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1	
	
@読み込むdeta番号を格納する
read_point:	.word	0

@音を変えるタイミングを測る
time_sound:	.word	0

@=====================================================================
@========ここから先を編集してお使いください=================================
@=====================================================================

@ music_dataの個数をここに書き込んでください	
music_size:	.word	1042
	
@ 音楽のデータ  周波数, 鳴らす時間[1ns]
@ 音のデータをword形式で書き込んでください
music_data:
	@ 前奏
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Mi0,	100000
	.word 0,	050000
	@/////10/////
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	@/////20/////
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Fa0,	100000
	.word 0,	100000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	@/////30/////
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Mi0,	250000
	.word 0,	200000
	@/////40/////
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Fa0,	100000
	.word 0,	100000
	.word KEY_Mi0,	250000
	.word 0,	200000
	@/////50/////
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	@/////60/////
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	@/////70/////
	.word KEY_Fa0,	100000
	.word 0,	100000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	050000
	@/////80/////
	.word KEY_Mi0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Re0,	100000
	.word 0,	050000
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Mi0,	250000
	.word 0,	200000
	@/////90/////
	.word KEY_Mi0,	250000
	.word 0,	200000
	.word KEY_Fa0,	300000
	.word 0,	400000

	@前奏2
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	@/////10/////
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	@/////20/////
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	050000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	200000
	.word KEY_Fas1,	100000
	@/////30/////
	.word KEY_Sos1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	@/////40/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	@/////50/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Sos1,	200000
	.word 0,	050000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	100000
	.word KEY_Fas1,	200000
	@/////60/////
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	@/////70/////
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	@/////80/////
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	050000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	@/////90/////
	.word KEY_Sos1,	200000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	@/////100/////
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	@/////110/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Sos1,	200000
	.word 0,	050000
	.word KEY_Fas1,	100000
	@/////120/////
	.word KEY_Sos1,	100000
	.word KEY_Fas1,	200000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word 0,	050000
	
	@ Aメロ
	.word KEY_Res,	215000
	.word KEY_Fa, 	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	@/////10/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////20/////
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Dos,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////30/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////40/////
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	390000
	.word KEY_Fas,	390000
	@/////50/////
	.word KEY_Sos,	390000
	.word KEY_Ras,	390000
	.word KEY_Res,	215000
	.word KEY_Fa, 	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	@/////60////
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Dos,	215000
	.word KEY_Fa,	215000
	@/////80/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	@/////90/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////100/////
	.word KEY_Fa,	390000
	.word KEY_Fas,	390000
	.word KEY_Sos,	390000
	.word KEY_Ras,	390000

	@サビ
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	@/////10/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	@/////20/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	@/////30/////
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	@/////40/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////50/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	@/////60/////
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	@/////80/////
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	@/////90/////
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Res2,	215000
	.word KEY_Fa2,	215000
	.word KEY_Fas2,	215000
	.word KEY_Fa2,	215000
	@/////100/////
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	@/////110/////

	@間奏前サビ
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	@/////10/////
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	@/////20/////
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	@/////30/////
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	@/////40/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	@/////50/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	@/////60/////
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////80/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	@/////90/////
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Res2,	215000
	.word KEY_Fa2,	215000
	@/////100/////
	.word KEY_Fas2,	215000
	.word KEY_Fa2,	215000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	@/////110/////
	.word KEY_Dos,	215000
	.word KEY_Res,	400000
	.word KEY_Dos1,	400000
	.word 0,	050000

	@間奏
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	@/////10/////
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	@/////20/////
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	050000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	200000
	.word KEY_Fas1,	100000
	@/////30/////
	.word KEY_Sos1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	@/////40/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	@/////50/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Sos1,	200000
	.word 0,	050000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	100000
	.word KEY_Fas1,	200000
	@/////60/////
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	@/////70/////
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	@/////80/////
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	050000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	@/////90/////
	.word KEY_Sos1,	200000
	.word KEY_Fas1,	100000
	.word KEY_Sos1,	100000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	@/////100/////
	.word 0,	050000
	.word KEY_Res1,	200000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Res1,	200000
	@/////110/////
	.word 0,	100000
	.word KEY_Res1,	100000
	.word 0,	100000
	.word KEY_Res1,	100000
	.word KEY_Dos1,	100000
	.word KEY_Res1,	100000
	.word 0,	050000
	.word KEY_Sos1,	200000
	.word 0,	050000
	.word KEY_Fas1,	100000
	@/////120/////
	.word KEY_Sos1,	100000
	.word KEY_Fas1,	200000
	.word KEY_Res1,	100000
	.word KEY_Fas1,	100000
	.word 0,	050000

	@Aメロ2
	.word KEY_Res,	215000
	.word KEY_Fa, 	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	@/////10/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////20/////
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Dos,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////30/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////40/////
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	390000
	.word KEY_Fas,	390000
	@/////50/////
	.word KEY_Sos,	390000
	.word KEY_Ras,	390000
	.word KEY_Res,	215000
	.word KEY_Fa, 	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	@/////60////
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Dos,	215000
	.word KEY_Fa,	215000
	@/////80/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	370000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	375000
	.word KEY_Res,	380000
	.word KEY_Ras,	215000
	@/////90/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	375000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	@/////100/////
	.word KEY_Fa,	390000
	.word KEY_Fas,	390000
	.word KEY_Sos,	390000
	.word KEY_Ras,	390000

	@サビ2
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	@/////10/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	@/////20/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	@/////30/////
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	@/////40/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////50/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	@/////60/////
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	@/////80/////
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	@/////90/////
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Res2,	215000
	.word KEY_Fa2,	215000
	.word KEY_Fas2,	215000
	.word KEY_Fa2,	215000
	@/////100/////
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	@/////110/////

	@最終サビ
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	@/////10/////
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	@/////20/////
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	@/////30/////
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	@/////40/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	@/////50/////
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	@/////60/////
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	@/////70/////
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	.word KEY_Dos,	215000
	.word KEY_Res,	365000
	.word KEY_Dos,	215000
	.word KEY_Res,	215000
	.word KEY_Fa,	215000
	@/////80/////
	.word KEY_Fas,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Res,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	@/////90/////
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Dos2,	215000
	.word KEY_Res2,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Ras,	365000
	.word KEY_Res2,	215000
	.word KEY_Fa2,	215000
	@/////100/////
	.word KEY_Fas2,	215000
	.word KEY_Fa2,	215000
	.word KEY_Res2,	215000
	.word KEY_Dos2,	215000
	.word KEY_Ras,	365000
	.word KEY_Sos,	215000
	.word KEY_Ras,	215000
	.word KEY_Sos,	215000
	.word KEY_Fas,	215000
	.word KEY_Fa,	215000
	@/////110/////
	.word KEY_Dos,	215000
	.word KEY_Res,	365000

	@終奏
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	@/////10/////
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	400000
	.word 0,	200000
	@/////20/////
	.word KEY_Mi0,	200000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	@/////30/////
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	400000
	.word 0,	200000
	.word KEY_Mi0,	200000
	.word 0,	200000
	@/////40/////
	.word KEY_Mi0,	100000
	.word 0,	100000
	.word KEY_Mi0,	200000
	.word 0,	1200000
	
