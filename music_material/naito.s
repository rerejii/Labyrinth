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
	
@======周波数定数===================================================================
	.equ    KEY_4A, 440     @ 440Hz のときの1周期のクロック数
	.equ	KEY_Res, 622	@ レ♯
	.equ	KEY_Fas, 739	@ ファ♯
	.equ	KEY_Fa,  698	@ ファ
	.equ	KEY_Sos, 830	@ ソ♯
	.equ	KEY_Ras, 932	@ ラ♯
	.equ	KEY_Res, 622	@ レ♯
	.equ	KEY_Dos, 554	@ ド♯
	.equ	KEY_Fas2, 1479	@ ファ♯1オク
	.equ	KEY_Fa2,  1396	@ ファ1オク
	.equ	KEY_Res2, 1244	@ レ♯1オク
	.equ	KEY_Dos2, 1108	@ ド♯1オク
	.equ	KEY_Ras2, 1760	@ ラ♯1オク
	.equ	KEY_Sos2, 1661	@ ソ♯1オク
@======周波数定数===================================================================

	
	.section .init
	.global _start
_start:

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

@======ここからテンプレ===============================================================================================================
	@(GPIO #19 を含め，GPIOの用途を設定する)
	@ LEDとディスプレイ用のIOポートを出力に設定する
	ldr	r0, =GPIO_BASE
	ldr	r11, =GPFSEL_VEC0
	str	r11, [r0, #GPFSEL0]
	ldr	r11, =GPFSEL_VEC1
	str	r11, [r0, #GPFSEL0 + 4]
	ldr	r11, =GPFSEL_VEC2
	str	r11, [r0, #GPFSEL0 + 8]
	
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

	@(PWM の動作モードを設定する)
	ldr	r12, =PWM_BASE		@ PWM を制御するためのレジスタのベースアドレス
	ldr	r11, =(1 << PWM_PWEN2)	@ PWEN2bit目まで1を左シフト
	ldr	r10, =(1 << PWM_MSEN2)	@ MSEN2bit目まで1を左シフト
	orr	r11, r11, r10		@ 合体
	str	r11, [r12, #PWM_CLT]
@======ここまでテンプレ===============================================================================================================

	

@------タイマー動作-----------------------------------
check_time_sound:
@++++++test++++++++++++++++++++++++++++++++++++++++++++++
	mov	r1, #(1 << (10 % 32))
	str	r1, [r0, #(0x28 + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
	beq	check_time_sound

	@ 音を鳴らす
	ldr	r11, =PWM_HZ
	udiv	r10, r11, r10
	ldr	r12, =PWM_BASE
	str	r10, [r12, #PWM_RNG2]
	lsr	r10, r10, #1			
	str	r10, [r12, #PWM_DAT2]
@++++++test++++++++++++++++++++++++++++++++++++++++++++++
	mov	r1, #(1 << (10 % 32))
	str	r1, [r0, #(0x1C + 10 / 32 * 4)]
@++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	b	check_time_sound


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
music_size:	.word	323
	
@ 音楽のデータ  周波数, 鳴らす時間[1ns]
@ 音のデータをword形式で書き込んでください
music_data:
	.word KEY_4_Re, TIME_BLOCK*2	@1
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2	
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Fa, TIME_BLOCK
	.word KEY_4_Mi, TIME_BLOCK*2
	@/////10/////
	.word KEY_4_Re, TIME_BLOCK*2	@2
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK*2
	.word KEY_5_Dos, TIME_BLOCK*2
	.word KEY_4_Re, TIME_BLOCK*2	@3
	@/////20/////
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Fa, TIME_BLOCK
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Re, TIME_BLOCK*2	@4
	@/////30/////
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_4_Do, TIME_BLOCK*2
	.word KEY_4_Dos, TIME_BLOCK*2	@5
	.word KEY_4_Mi, TIME_BLOCK*2	
	.word KEY_4_Ra, TIME_BLOCK*2
	@/////40/////
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Fa, TIME_BLOCK
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Re, TIME_BLOCK*2	@6
	.word KEY_4_Ra, TIME_BLOCK*2
	@/////50/////
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK*2
	.word KEY_5_Dos,  TIME_BLOCK*2
	.word KEY_4_Re, TIME_BLOCK*2	@7
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	@/////60/////
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Fa, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_4_So, TIME_BLOCK
	.word KEY_4_Fa, TIME_BLOCK
	.word KEY_4_Mi, TIME_BLOCK*2
	.word KEY_4_Re, TIME_BLOCK*2	@8
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_4_So, TIME_BLOCK
	@/////70/////
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word 0,	1000
	.word KEY_5_Mi, TIME_BLOCK-1000
	.word KEY_5_Do, TIME_BLOCK
	@/////80/////
	.word KEY_5_Dos,  TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2	@9
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	@/////90/////
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*2	@10
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_6_Dos,  TIME_BLOCK*2
	@/////100/////
	.word KEY_5_Re, TIME_BLOCK*2	@11
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK*2
	@/////110/////
	.word KEY_5_Re, TIME_BLOCK*2	@12
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK*2
	.word KEY_5_Dos, TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*2	@13
	@/////120/////
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*2	@14
	@/////130/////
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_6_Dos,  TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*2	@15
	.word KEY_5_Ra, TIME_BLOCK*2
	@/////140/////
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*2	@16
	.word KEY_5_Ra, TIME_BLOCK*2
	@/////150/////
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word 0,	1000
	.word KEY_5_Ra, TIME_BLOCK*2-1000
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_6_Fa, TIME_BLOCK
	.word KEY_6_Mi, TIME_BLOCK
	.word KEY_6_Re, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2 @17
	@/////160/////
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	@/////170/////
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2 @18
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2
	@/////180/////
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2 @19
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	@/////190/////
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2 @20
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_6_Dos, TIME_BLOCK*2
	@/////200/////
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2 @21
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	@/////210/////
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2 @22
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	@/////220/////
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Fas, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2 @23
	.word KEY_4_So, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_4_So, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	@/////230/////
	.word KEY_4_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Ras, TIME_BLOCK*3 @24
	.word 0,	10000
	.word KEY_5_Ras, TIME_BLOCK*3-10000
	.word 0,	10000
	@/////240/////
	.word KEY_5_Ras, TIME_BLOCK*2-10000
	.word KEY_6_Do, TIME_BLOCK*4
	.word KEY_5_Do, TIME_BLOCK*4
	.word KEY_4_Ra, TIME_BLOCK*2 @25
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	@/////250/////	
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2 @26
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	@/////260/////
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2 @27
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	@/////270/////	
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	.word KEY_5_Re, TIME_BLOCK*2 @28
	.word KEY_5_Ra, TIME_BLOCK*2
	@/////280/////
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_6_Dos, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_4_Ra, TIME_BLOCK*2 @29
	.word KEY_5_Fa, TIME_BLOCK*2
	@/////290/////
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK
	.word KEY_5_Mi, TIME_BLOCK
	.word KEY_5_Do, TIME_BLOCK
	@/////300/////
	.word KEY_5_Re, TIME_BLOCK*2 @30
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Ra, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_4_Ra, TIME_BLOCK	
	.word KEY_6_Do, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_Fa, TIME_BLOCK*2
	.word KEY_5_Fas, TIME_BLOCK*2
	@/////310/////	
	.word KEY_5_So, TIME_BLOCK*2 @31
	.word KEY_4_So, TIME_BLOCK
	.word KEY_5_So, TIME_BLOCK
	.word KEY_4_Ras, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK*2
	.word KEY_5_Ra, TIME_BLOCK*2
	.word KEY_5_So, TIME_BLOCK/2
	.word KEY_5_Ra, TIME_BLOCK/2
	.word KEY_5_So, TIME_BLOCK
	.word KEY_5_Fa, TIME_BLOCK*2
	@/////320/////
	.word KEY_5_Mi, TIME_BLOCK*2
	.word KEY_5_Re, TIME_BLOCK*8 @32
	.word 0, TIME_BLOCK*8
