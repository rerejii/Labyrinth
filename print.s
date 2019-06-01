@------printについて-------------------------------
@ドットマトリックスLED出力用のサブルーチンです
@受け取ったマップデータや座標データを元に表示します
@現在マップの選択機能はprintにはつけてません
@おそらくメインのlabyrinthで選択機能をつける事になるでしょう
@------------------------------------------------
	@-----print固有定数-----
	.equ	GOAL_TIME,		400000		@ ゴール用(0.4秒)
	.equ	WALL_TIME,		3000		@ 壁用(0.002秒)
	.equ	TORCH_TIME,		8000		@ トーチ用(0.008秒)
	

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	labyrinth_dataの先頭番地
@r2, 	labyrinth_paramerersの先頭番地
@r3, 	sw_valueの先頭番地
@------------------------
	.include "include.inc" 
	.section .text
	.global  print

print:		
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
	ldrb	r12, [r2, #TASK_FIRST_SW]	@ 初期動作判定値を受け取る
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
@------time_goalの初期化-------------------------------	
	ldr	r11, =GOAL_TIME			@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_goal			@ time_goalの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop
@------time_wallの初期化-------------------------------
	ldr	r11, =WALL_TIME			@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_wall			@ time_wallの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop
@------time_torchの初期化------------------------------
	ldr	r11, =TORCH_TIME		@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_torch		@ time_torchの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop
first_end:
@------time_goalの判定-------------------------------	
c_time_goal:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_goal			@ time_goalの番地取得
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
	bcc	c_time_goal_end			@ 判定終了
	ldr	r12, =GOAL_TIME			@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_goal			@ time_goalの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
	ldr	r12, =print_goal		@ print_goalの座標を受け取る
	ldrb	r11, [r12]			@ 点灯/消灯を制御する値を受け取る
	cmp	r11, #0				@ 現在消灯なら
	moveq	r10, #1				@ 1を格納
	movne	r10, #0				@ 0を格納
	strb	r10, [r12]			@ 更新
c_time_goal_end:
@------time_wallの判定-------------------------------
c_time_wall:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_wall			@ time_wallの番地取得
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
	bcc	c_time_wall_end			@ 判定終了

	ldr	r12, =WALL_TIME			@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_wall			@ time_wallの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
	mov	r12, #0				@ カウント8回
	ldr	r11, =check_time_row		@ すべての行を一回表示可能にする
	mov	r10, #1				@ 書き換え用の1
c_time_wall_loop:
	strb	r10, [r11, r12]			@ 表示可能に書き換え
	cmp	r12, #7				@ すべて書き換えが終わったか
	addne	r12, r12, #1			@ 1を足す
	bne	c_time_wall_loop			@ loop		
c_time_wall_end:
	
@------time_torchの判定------------------------------
c_time_torch:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_torch		@ time_torchの番地取得
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
	bcc	c_time_torch_end		@ 判定終了

	ldr	r12, =TORCH_TIME		@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_torch		@ time_torchの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop

	mov	r12, #0				@ カウント初期化
	ldr	r11, =print_torch		@ 座標を受け取る
	mov	r10, #1				@ 代入値
1:	
	strb	r10, [r11, r12]			@ 値の更新
	cmp	r12, #7				@ loopのカウント判定
	addne	r12, r12, #1			@ カウントアップ
	bne	1b				@ loop
c_time_torch_end:

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
	
buffer_in_check:
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldr	r11, =check_time_row
	ldrb	r10, [r11, r12]			@ check_time_rowより、表示すべきかの判定
	cmp	r10, #1				@ 1なら表示
	bne	buffer_in_map_end		@ 0ならマップ非表示
	mov	r10, #0				@ 表示したら0に戻す
	strb	r10, [r11, r12]			@ print_rowに0を
buffer_in_map:	
	@ ---マップデータの列データをbufferに格納---
	mov	r12, #0				@ アドレス格納用に初期化
	ldrb	r11, [r2, #LABY_COORDINATE_X]	@ ラビリンスのサイズxを受け取る
	ldrb	r10, [r2, #MAP_COORDINATE_Y]	@ マップの座標yを受け取る
	ldr	r9, =print_row			@ 出力すべき行を保存している座標
	ldrb	r9, [r9]			@ 出力すべき行番号の取得
	add	r10, r10, r9			@ 行数をプラス
	mul	r12, r11, r10			@ 掛け合わしてマップの現在地のy座標を求める
	ldrb	r11, [r2, #MAP_COORDINATE_X]	@ マップの座標xを受け取る
	add	r12, r12, r11			@ マップの座標を求める
	ldr	r11, =frame_buffer		@ frame_bufferの座標を受け取る
	mov	r10, #0				@ loopカウント用
buffer_in_map_loop:
	mov	r9, r12				@ r9に座標をコピー
	add	r9, r9, r10			@ カウントを足す
	ldrb	r8, [r1, r9]			@ 1Byte受け取る
	strb	r8, [r11, r10]			@ frame_bufferの座標に1Byte書き込む
	cmp	r10, #7				@ 8Byte書き込んだか?
	addne	r10, r10, #1			@ カウントアップ
	bne	buffer_in_map_loop		@ loop
	@ -------------------------
buffer_in_map_end:



buffer_in_goal:
	ldr	r12, =print_goal		@ print_goalの座標を受け取る
	ldrb	r12, [r12]			@ 点灯/消灯を制御する値を受け取る
	cmp	r12, #1				@ 点灯 or 消灯
	bne	buffer_in_goal_end		@ 消灯なら終了
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldrb	r11, [r2, #MAP_COORDINATE_Y]	@ 現在表示しているマップ座標yを受け取る
	add	r12, r12, r11			@ マップ座標を足す
	ldrb	r11, [r2, #GOAL_COORDINATE_Y]	@ goalのy座標を受け取る
	cmp	r11, r12			@ goalのいる行を表示するか?
	bne	buffer_in_goal_end		@ 違うなら次のタスクへ
	mov	r12, #0				@ 列数を0~7まで数えるレジスタ
	ldrb	r11, [r2, #GOAL_COORDINATE_X]	@ goalのx座標を受け取る
	mov	r10, #1				@ 格納する1を取得
	ldr	r9, =frame_buffer		@ frame_bufferの座標を受け取る
	ldrb	r8, [r2, #MAP_COORDINATE_X]	@ 現在表示しているマップ座標yを受け取る
buffer_in_goal_loop:
	cmp	r11, r8				@ 現在の列にgoalがあるか
	streqb	r10, [r9, r12]			@ goalを書き込む
	cmp	r12, #7				@ 判定終了?
	addne	r12, r12, #1			@ 1を足す
	addne	r8, r8, #1			@ 判定行を1つ足す
	bne	buffer_in_goal_loop		@ loop
buffer_in_goal_end:


buffer_in_player:	
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyerのy座標を受け取る
	cmp	r11, r12			@ pleyerのいる行を表示するか?
	bne	buffer_in_player_end		@ 違うなら次のタスクへ
	mov	r12, #0				@ 列数を0~7まで数えるレジスタ
	ldrb	r11, [r2, #PLAYER_COORDINATE_X]	@ pleyerのx座標を受け取る
	mov	r10, #1				@ 格納する1を取得
	ldr	r9, =frame_buffer		@ frame_bufferの座標を受け取る
buffer_in_player_loop:
	cmp	r12, r11			@ 現在の列にpleyerが居るか
	streqb	r10, [r9, r12]			@ pleyerを書き込む
	cmp	r12, #7				@ 判定終了?
	addne	r12, r12, #1			@ 1を足す
	bne	buffer_in_player_loop		@ loop
buffer_in_player_end:
	
buffer_torch:
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldrb	r11, [r2, #PLAYER_COORDINATE_Y]	@ pleyerのy座標を受け取る
	cmp	r11, r12			@ どっちが大きい?
	subpl	r10, r11, r12			@ 絶対値を取り出す
	submi	r10, r12, r11			@ 絶対値を取り出す
	ldrb	r12, [r2, #TORCH_LEVEL]		@ 松明レベルを取り出す
	add	r10, r10, r12, lsl #3		@ 松明レベルを8倍して足す
	ldr	r11, =torch_rengs		@ 松明の距離torch_rengsの座標
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
	ldrls	r9, =print_torch		@ 座標を受け取る
	ldrlsb	r9, [r9, r8]			@ 格納すべき値を受け取る
	ldrls	r8, =frame_buffer		@ frame_bufferの座標を受け取る
	strlsb	r9, [r8, r12]			@ 見えない範囲を消す
	cmp	r12, #7				@ すべての行の判定終わった?
	addne	r12, r12, #1			@ カウントアップ
	bne	1b

	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	ldr	r11, =print_torch		@ 座標を受け取る
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

@フレームバッファリセット用
all_zero:	.byte 0, 0, 0, 0, 0, 0, 0, 0
	
@出力すべき行を保存
print_row:	.byte 0

@ゴールの点滅管理
print_goal:	.byte 0

@ゴールの点滅間隔の時間管理用
time_goal:	.word 0

@壁の表示間隔の時間管理用
time_wall:	.word 0

@松明の見える範囲の点滅
time_torch:	.word 0

@松明の表示制御
print_torch:	.byte	0, 0, 0, 0, 0, 0, 0, 0

@表示する行を時間で管理するデータ 時間になるとすべて１に 表示した行は0に戻る
check_time_row:		.byte 0, 0, 0, 0, 0, 0, 0, 0

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1

torch_rengs:	.byte	0, 0, 0, 0, 0, 0, 0, 0 @パワー0
		.byte	2, 2, 0, 0, 0, 0, 0, 0 @パワー1
		.byte	3, 3, 2, 0, 0, 0, 0, 0 @パワー2
		.byte	4, 4, 3, 2, 0, 0, 0, 0 @パワー3
		.byte	5, 5, 4, 4, 3, 0, 0, 0 @パワー4
	
