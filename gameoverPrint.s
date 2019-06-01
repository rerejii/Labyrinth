
	@-----gameoverPrint固有定数-----
	.equ	SCREEN_TIME,		8000		@ トーチ用(0.008秒)
	.equ	DECREASE_TIME,		400000		@ 減少タイム(0.2秒)
	.equ	DECEEASE_MAX,		20		@ 減少レベルの最大

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	labyrinth_dataの先頭番地
@r2, 	labyrinth_paramerersの先頭番地
@r3, 	reset_swの先頭番地
@r4, 	reset_modeの先頭番地	
@------------------------
	.include "include.inc" 
	.section .text
	.global  gameoverPrint

gameoverPrint:		
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
	ldrb	r12, [r4]			@ 初期動作判定値を受け取る
	cmp	r12, #1				@ 初期動作を起動するか?
	ldreq	r11, =first_flag		@ first_flagの番地
	streqb	r12, [r11]			@ 書き込み
@-----初期動作-----------------------------------------	
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
@------time_screenの初期化-------------------------------	
	ldr	r11, =SCREEN_TIME		@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_screen		@ time_goalの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop
@------time_decreaseの初期化-------------------------------
	ldr	r11, =DECREASE_TIME		@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_decrease		@ time_wallの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop

	ldr	r12, =count_decrease		@ 座標を受け取る
	mov	r11, #0				@ 0を格納
	strb	r11, [r12]			@ 値の更新
first_end:

@------time_screenの判定------------------------------
c_time_screen:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_screen		@ time_screenの番地取得
	mov	r10, #0				@ 初期化
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
	bcc	c_time_screen_end		@ 判定終了

	ldr	r12, =SCREEN_TIME		@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_screen		@ time_screenの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop

	mov	r12, #0				@ カウント初期化
	ldr	r11, =print_screen		@ 座標を受け取る
	mov	r10, #1				@ 代入値
1:	
	strb	r10, [r11, r12]			@ 値の更新
	cmp	r12, #7				@ loopのカウント判定
	addne	r12, r12, #1			@ カウントアップ
	bne	1b				@ loop
c_time_screen_end:

@------time_decreaseの判定------------------------------
c_time_decrease:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_decrease		@ time_decreaseの番地取得
	mov	r10, #0				@ 初期化
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
	bcc	c_time_decrease_end		@ 判定終了

	ldr	r12, =DECREASE_TIME		@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_decrease		@ time_decreaseの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop

	ldr	r12, =count_decrease		@ 座標を受け取る
	ldrb	r11, [r12]			@ 値を受け取る
	cmp	r11, #DECEEASE_MAX		@ maxサイズを受け取る
	addne	r11, r11, #1			@ 代入値
	strneb	r11, [r12]			@ 値の更新
	moveq	r11, #1				@ 代入値1
	streqb	r11, [r3]			@ reset_swに1を格納
c_time_decrease_end:

@------col(列)の削除----------------------------------
col_dlt:
	@   いったん列をすべて消灯
	mov	r11, #0
	ldr	r12, =col_port
col_dlt_loop:
	ldrb	r9, [r12, r11]			@ colポート番号を取り出す
	mov	r10, #1				@ 1を格納
	mov	r10, r10, lsl r9		@ 1を立てる場所を特定する
	str	r10, [r0, #GPCLR0]		@ 無効
	cmp	r11, #7				@ loopが終了したか
	addne	r11, r11, #1			@ 次の列に
	bne	col_dlt_loop			@ loop

@------row(行)設定------------------------------------
row_str:
	@ 行を指定
	mov	r11, #0				@ 行数を0~7まで数えるレジスタ
	ldr	r12, =row_port			@ LEDの行のポート集の先頭番地
row_loop:
	ldrb	r9, [r12, r11]			@ ポート番号を取り出す
	mov	r10, #1				@ 特定の場所に立てる1を格納
	mov	r10, r10, lsl r9		@ 1を立てる場所を特定する
	ldr	r9, =print_row			@ print_rowを受け取る
	ldrb	r9, [r9]			@ 出力すべき行を受け取る
	cmp	r9, r11				@ 選択している行が表示すべき行か?
	strne	r10, [r0, #GPSET0]		@ 無効
	streq	r10, [r0, #GPCLR0]		@ 有効
	cmp	r11, #7				@ loopが終了したか
	addne	r11, r11, #1			@ 次の行に
	bne	row_loop			@ loop

@------列設定-----------------------------------------------
buffer_in_zero:
	mov	r12, #0				@ カウント用
	mov	r11, #0				@ 代入値
	ldr	r10, =frame_buffer		@ frame_bufferの座標を受け取る
buffer_in_zero_loop:
	strb	r11, [r10, r12]			@ frame_bufferを0で初期化
	cmp	r12, #7				@ loopがおわったか？
	addne	r12, r12, #1			@ カウントアップ
	bne	buffer_in_zero_loop
	
buffer_screen:
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyerのy座標を受け取る
	cmp	r11, r12			@ どっちが大きい?
	subpl	r10, r11, r12			@ 絶対値を取り出す
	submi	r10, r12, r11			@ 絶対値を取り出す
	ldr	r12, =count_decrease		@ count_decreaseの座標を受け取る
	ldrb	r12, [r12]			@ 参照する距離を求める値を受け取る
	add	r10, r10, r12, lsl #3		@ 座標を8倍して足す
	ldr	r11, =screen_rengs		@ 松明の距離screen_rengsの座標
	ldrb	r11, [r11, r10]			@ 松明の距離を取り出す
	mov	r12, #0				@ カウント初期化
	ldrb	r10, [r2, #PLAYER_COORDINATE_X]	@ pleyerのx座標を受け取る
1:	
	cmp	r10, r12			@ どっちが大きい?
	subpl	r9, r10, r12			@ 絶対値を取り出す
	submi	r9, r12, r10			@ 絶対値を取り出す
	cmp	r11, r9				@ 松明の距離が届く範囲か?
	ldr	r8, =print_row			@ print_rowを受け取る
	ldrb	r8, [r8]			@ 出力すべき行を受け取る
	ldrhi	r9, =print_screen		@ 座標を受け取る
	ldrhib	r9, [r9, r8]			@ 格納すべき値を受け取る
	ldrhi	r8, =frame_buffer		@ frame_bufferの座標を受け取る
	strhib	r9, [r8, r12]			@ 値を格納していく
	movls	r9, #0				@ 0を入れる
	strhib	r9, [r8, r12]			@ 闇を入れよう
	cmp	r12, #7				@ すべての行の判定終わった?
	addne	r12, r12, #1			@ カウントアップ
	bne	1b

	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldr	r11, =print_screen		@ 座標を受け取る
	mov	r10, #0				@ 代入値
	strb	r10, [r11 ,r12]			@ 更新

col_str:	
	@ 列を指定
	mov	r11, #0				@ 列数を0~7まで数えるレジスタ
	ldr	r12, =col_port			@ LEDの列のポート集の先頭番地
col_loop:
	ldrb	r9, [r12, r11]			@ ポート番号を取り出す
	mov	r10, #1				@ 特定の場所に立てる1を格納
	mov	r10, r10, lsl r9		@ 1を立てる場所を特定する
	ldr	r9, =frame_buffer		@ frame_bufferの座標を受け取る
	ldrb	r9, [r9, r11]			@ frame_bufferより値を受け取る
	cmp	r9, #1				@ 選択している列は表示すべきか?
	strne	r10, [r0, #GPCLR0]		@ 無効
	streq	r10, [r0, #GPSET0]		@ 有効
	cmp	r11, #7				@ loopが終了したか
	addne	r11, r11, #1			@ 次の列に
	bne	col_loop			@ loop
row_up:
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r9, [r12]			@ 出力すべき行を受け取る
	cmp	r9, #7				@ すべての行を出力したか
	addne	r9, r9, #1			@ 行の出力カウントアップ
	moveq	r9, #0				@ 行の出力カウントリセット
	strb	r9, [r12]			@ print_rowを更新

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

@======data==========================================
	.section .data
@ドットマトリックスの行のポート番号のまとめ
col_port:	.byte COL1_PORT, COL2_PORT, COL3_PORT, COL4_PORT
		.byte COL5_PORT, COL6_PORT, COL7_PORT, COL8_PORT
@ドットマトリックスの列のポート番号のまとめ
row_port:	.byte ROW1_PORT, ROW2_PORT, ROW3_PORT, ROW4_PORT
		.byte ROW5_PORT, ROW6_PORT, ROW7_PORT, ROW8_PORT
@フレームバッファ
frame_buffer:	.byte 0, 0, 0, 0, 0, 0, 0, 0
	
@出力すべき行を保存
print_row:	.byte 0

@出力減少管理タイム
time_decrease:	.word 0

@画面の表示管理タイム
time_screen:	.word 0

@表示する行を時間で管理するデータ 時間になるとすべて１に 表示した行は0に戻る
print_screen:		.byte 0, 0, 0, 0, 0, 0, 0, 0

@適用する範囲を求めるのに使う
count_decrease:		.byte 0

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1

screen_rengs:	.byte	8, 8, 8, 8, 8, 8, 8, 8
		.byte	8, 8, 8, 8, 8, 8, 7, 7
		.byte	8, 8, 8, 8, 7, 7, 6, 6
		.byte	8, 8, 7, 7, 6, 6, 5, 5
		.byte	7, 7, 6, 6, 5, 5, 4, 4
		.byte	6, 6, 5, 5, 4, 4, 3, 2
		.byte	5, 5, 4, 4, 3, 0, 0, 0
		.byte	4, 4, 3, 2, 0, 0, 0, 0
		.byte	3, 3, 2, 0, 0, 0, 0, 0 
		.byte	2, 2, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	1, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0
		.byte	0, 0, 0, 0, 0, 0, 0, 0

	
	
