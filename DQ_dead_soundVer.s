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
@================================================================================
	@.equ	TIME_BLOCK, 62500
	.equ	TIME_BLOCK, 100000
	
	.equ    KEY_2_Do, 65  @ 3C_ド
	.equ    KEY_2_Dos, 69  @ 3C_ド#
	.equ    KEY_2_Re, 73  @ 3C_レ
	.equ    KEY_2_Res, 77  @ 3C_レ#
	.equ    KEY_2_Mi, 82  @ 3C_ミ
	.equ    KEY_2_Fa, 87  @ 3C_ファ
	.equ    KEY_2_Fas, 92  @ 3C_ファ#
	.equ    KEY_2_So, 98  @ 3C_ソ
	.equ    KEY_2_Sos, 103  @ 3C_ソ#
	.equ    KEY_2_Ra, 110  @ 3C_ラ
	.equ    KEY_2_Ras, 116  @ 3C_ラ#
	.equ    KEY_2_Si, 123  @ 3C_シ

	.equ    KEY_3_Do, 130  @ 3C_ド
	.equ    KEY_3_Dos, 138  @ 3C_ド#
	.equ    KEY_3_Re, 146  @ 3C_レ
	.equ    KEY_3_Res, 155  @ 3C_レ#
	.equ    KEY_3_Mi, 164  @ 3C_ミ
	.equ    KEY_3_Fa, 174  @ 3C_ファ
	.equ    KEY_3_Fas, 185  @ 3C_ファ#
	.equ    KEY_3_So, 196  @ 3C_ソ
	.equ    KEY_3_Sos, 207  @ 3C_ソ#
	.equ    KEY_3_Ra, 220  @ 3C_ラ
	.equ    KEY_3_Ras, 233  @ 3C_ラ#
	.equ    KEY_3_Si, 246  @ 3C_シ

	.equ    KEY_4_Do, 261  @ 4C_ド
	.equ    KEY_4_Dos, 277  @ 4C_ド#
	.equ    KEY_4_Re, 293  @ 4C_レ
	.equ    KEY_4_Res, 311  @ 4C_レ#
	.equ    KEY_4_Mi, 329  @ 4C_ミ
	.equ    KEY_4_Fa, 349  @ 4C_ファ
	.equ    KEY_4_Fas, 369  @ 4C_ファ#
	.equ    KEY_4_So, 392  @ 4C_ソ
	.equ    KEY_4_Sos, 415  @ 4C_ソ#
	.equ    KEY_4_Ra, 440  @ 4C_ラ
	.equ    KEY_4_Ras, 466  @ 4C_ラ#
	.equ    KEY_4_Si, 493  @ 4C_シ

	.equ    KEY_5_Do, 523  @ 5C_ド
	.equ    KEY_5_Dos, 554  @ 5C_ド#
	.equ    KEY_5_Re, 587  @ 5C_レ
	.equ    KEY_5_Res, 622  @ 5C_レ#
	.equ    KEY_5_Mi, 659  @ 5C_ミ
	.equ    KEY_5_Fa, 698  @ 5C_ファ
	.equ    KEY_5_Fas, 739  @ 5C_ファ#
	.equ    KEY_5_So, 783  @ 5C_ソ
	.equ    KEY_5_Sos, 830  @ 5C_ソ#
	.equ    KEY_5_Ra, 880  @ 5C_ラ
	.equ    KEY_5_Ras, 932  @ 5C_ラ#
	.equ    KEY_5_Si, 987  @ 5C_シ

	.equ    KEY_6_Do, 1046  @ 6C_ド
	.equ    KEY_6_Dos, 1108  @ 6C_ド#
	.equ    KEY_6_Re, 1174  @ 6C_レ
	.equ    KEY_6_Res, 1244  @ 6C_レ#
	.equ    KEY_6_Mi, 1318  @ 6C_ミ
	.equ    KEY_6_Fa, 1396  @ 6C_ファ
	.equ    KEY_6_Fas, 1479  @ 6C_ファ#
	.equ    KEY_6_So, 1567  @ 6C_ソ
	.equ    KEY_6_Sos, 1661  @ 6C_ソ#
	.equ    KEY_6_Ra, 1760  @ 6C_ラ
	.equ    KEY_6_Ras, 1864  @ 6C_ラ#
	.equ    KEY_6_Si, 1975  @ 6C_シ	
@================================================================================
	
	.section .init
	.global DQ_dead_soundVer
DQ_dead_soundVer:
@-----データの保存-------------------------------------
backup:
	str	r7, [sp, #-4]!	@ push
	str	r8, [sp, #-4]!	@ push
	str	r9, [sp, #-4]!	@ push
 	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
@-----初期動作起動判定-----------------------------------------
first_now:
	ldrb	r12, [r1]			@ 初期動作判定値を受け取る
	cmp	r12, #1				@ 初期動作を起動するか?
	ldreq	r11, =first_flag		@ first_flagの番地
	streqb	r12, [r11]			@ 書き込み
@------初期動作-----------------------------------
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る
@------read_pointの初期化------
	mov	r12, #0				@ loopカウント
	ldr	r11, =read_point		@ 書き込むデータ番号座標
	mov	r10, #0				@ 0を格納
1:
	strb	r10, [r11, r12]			@ 値を更新
	cmp	r12, #3				@ loopが終了したか?
	addne	r12, r12, #1			@ loopカウントアップ
	movne	r10, r10, lsr #BYTE		@ 書き込み終わったbitをずらす
	bne	1b				@ loop
	
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
music_size:	.word	20
	
@ 音楽のデータ  周波数, 鳴らす時間[1ns]
@ 音のデータをword形式で書き込んでください
music_data:
	.word KEY_5_Fa, TIME_BLOCK*4	@1
	.word KEY_5_Re, TIME_BLOCK*4
	.word KEY_4_Ra, TIME_BLOCK*4
	.word KEY_5_Fa, TIME_BLOCK*4
	.word KEY_5_Mi, TIME_BLOCK*4	
	.word KEY_5_Dos, TIME_BLOCK*4
	.word KEY_4_Ra, TIME_BLOCK*4
	.word KEY_5_Mi, TIME_BLOCK*4
	.word KEY_5_Re, TIME_BLOCK*4
	.word KEY_4_Ras, TIME_BLOCK*4
	@/////10/////
	.word KEY_4_So, TIME_BLOCK*4	@2
	.word KEY_5_Re, TIME_BLOCK*4
	.word KEY_5_Dos, TIME_BLOCK*4
	.word KEY_4_Ras, TIME_BLOCK*4
	.word KEY_4_Ra, TIME_BLOCK*4
	.word KEY_4_Sos, TIME_BLOCK*4
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_4_Sos, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*10
	.word 0, 1000000
