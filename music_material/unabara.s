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
	.equ    KEY_ra,  440    @ ラ
	.equ	KEY_si,  494	@ シ
	.equ	KEY_do,  523	@ ド
	.equ	KEY_re,  587	@ レ
	.equ	KEY_mi,  659	@ ミ
	.equ	KEY_fa,  740	@ ファ#
	.equ	KEY_so,  784	@ ソ
	@ 高音
	.equ	KEY_ra2, 880	@ ラ
	.equ	KEY_si2, 932	@ シ
	.equ	KEY_do2, 1046	@ ド
	.equ	KEY_re2, 1174	@ レ
@======周波数定数===================================================================

	
	.section .init
	.global unabara
unabara:
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
music_size:	.word	126
	
@ 音楽のデータ  周波数, 鳴らす時間[1ns]
@ 音のデータをword形式で書き込んでください
music_data:
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_so, 	500000
	.word KEY_fa, 	125000	
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	250000
	.word KEY_re, 	250000
	.word KEY_mi, 	500000
	.word 0,	250000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000	
	.word KEY_ra2, 	562500
	.word KEY_so, 	187500
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	250000
	.word KEY_ra2, 	250000
	.word KEY_mi, 	500000
	.word 0,	250000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_so, 	500000
	.word KEY_fa, 	125000	
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	250000
	.word KEY_re, 	250000
	.word KEY_mi, 	500000
	.word 0,	250000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000
	.word KEY_ra, 	125000
	.word KEY_si,	125000
	.word KEY_do,	125000
	.word 0,	125000	
	.word KEY_ra2, 	562500
	.word KEY_so, 	187500
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	125000
	.word KEY_so, 	125000
	.word KEY_fa, 	250000
	.word KEY_ra2, 	250000
	.word KEY_mi, 	500000
	.word 0,	5000
	.word KEY_mi, 	245000
	.word KEY_fa, 	250000
	.word KEY_so, 	750000
	.word KEY_fa, 	125000
	.word KEY_mi, 	125000
	.word KEY_re, 	500000
	.word KEY_si, 	500000
	.word KEY_mi, 	1500000
	.word 0,	5000
	.word KEY_mi, 	245000
	.word KEY_fa, 	250000
	.word KEY_so, 	750000
	.word KEY_fa, 	125000
	.word KEY_mi, 	125000
	.word KEY_re, 	500000
	.word KEY_fa, 	500000
	.word KEY_mi, 	1500000
	.word 0,	5000
	.word KEY_mi, 	245000
	.word KEY_fa, 	250000
	.word KEY_so, 	500000
	.word KEY_ra2, 	250000
	.word KEY_so, 	250000
	.word KEY_fa, 	250000
	.word KEY_mi, 	250000
	.word KEY_re, 	250000
	.word KEY_fa, 	250000
	.word KEY_do2, 	500000
	.word KEY_re2, 	250000
	.word KEY_do2, 	250000
	.word KEY_si2, 	250000
	.word KEY_ra2, 	250000
	.word KEY_so, 	250000
	.word KEY_si2, 	250000
	.word KEY_ra2, 	2000000
	.word 0,	1525000
