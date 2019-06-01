@------printについて-------------------------------
@ドットマトリックスLED出力用のサブルーチンです
@受け取ったマップデータや座標データを元に表示します
@現在マップの選択機能はprintにはつけてません
@おそらくメインのlabyrinthで選択機能をつける事になるでしょう
@------------------------------------------------
	@-----print固有定数-----
	.equ	WALL_TIME,		3000		@ 壁用(0.002秒)
	.equ	MAP_LINE_SIZE,		5		@ マップ選択マップは横5
	.equ	NUMBER_LINE_SIZE,	3		@ 数値データの横の長さ
	.equ	NUMBER_BLOCK_SIZE,	24		@ 数値データ一つの大きさ

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	mapSelect_paramerersの先頭番地
@r2, 	reset_modeの先頭番地
@------------------------
	.include "include.inc" 
	.section .text
	.global  musicSelect_print

musicSelect_print:		
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
	ldrb	r12, [r2]			@ 初期動作判定値を受け取る
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
first_end:
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
	ldr	r11, =check_time_row		@ check_time_rowの座標
	ldrb	r10, [r11, r12]			@ check_time_rowより、表示すべきかの判定
	cmp	r10, #1				@ 1なら表示
	bne	buffer_in_map_end		@ 0ならマップ非表示
	mov	r10, #0				@ 表示したら0に戻す
	strb	r10, [r11, r12]			@ print_rowに0を
buffer_in_map:	
	@ ---マップデータの列データをbufferに格納---
	mov	r12, #0				@ アドレス格納用に初期化
	ldrb	r11, [r1, #MUSIC_SELECT]	@ 選択中のマップ値を受け取る
	mov	r11, r11, lsl #1		@ 2倍
	ldr	r9, =print_row			@ 出力すべき行を保存している座標
	ldrb	r9, [r9]			@ 出力すべき行番号の取得
	add	r11, r11, r9			@ 表示する行分を足す
	ldr	r10, =MAP_LINE_SIZE		@ mapの１行分の長さを受け取る
	mul	r12, r10, r11			@ 読み込みを開始する座標の計算
	mul	r12, r11, r10			@ 掛け合わしてマップの現在地のy座標を求める
	ldr	r11, =frame_buffer		@ frame_bufferの座標を受け取る
	mov	r10, #0				@ loopカウント用
buffer_in_map_loop:
	mov	r9, r12				@ r9に座標をコピー
	add	r9, r9, r10			@ カウントを足す
	ldr	r7, =map_data
	ldrb	r8, [r7, r9]			@ 1Byte受け取る
	add	r9, r10, #3
	strb	r8, [r11, r9]			@ frame_bufferの座標に1Byte書き込む
	cmp	r10, #4				@ 5Byte書き込んだか?
	addne	r10, r10, #1			@ カウントアップ
	bne	buffer_in_map_loop		@ loop
	@ -------------------------
buffer_in_map_end:

buffer_in_number:	
	@ ---数値データの列データをbufferに格納---
	mov	r12, #0				@ アドレス格納用に初期化
	ldrb	r11, [r1, #MUSIC_SELECT]	@ 選択中のマップ値を受け取る
	ldr	r10, =NUMBER_BLOCK_SIZE		@ 1ブロックのサイズを受け取る
	mul	r11, r10, r11			@ 表示数値の番地を算出
	ldr	r9, =print_row			@ 出力すべき行を保存している座標
	ldrb	r9, [r9]			@ 出力すべき行番号の取得
	ldr	r8, =NUMBER_LINE_SIZE		@ numberの１行分の長さを受け取る
	mul	r9, r8, r9			@ 飛ばす行分の番地算出
	add	r10, r11, r9			@ 出力すべき行の番地を算出
	ldr	r11, =number_data		@ number_dataの先頭番地
	add	r12, r10, r11			@ r12に最終的な番地を
	ldr	r11, =frame_buffer		@ frame_bufferの座標を受け取る
	mov	r10, #0				@ loopカウント用
1:
	ldrb	r8, [r12, r10]			@ 1Byte受け取る
	add	r9, r10, #0			@ 書き込みの座標の調整
	strb	r8, [r11, r9]			@ frame_bufferの座標に1Byte書き込む
	cmp	r10, #2				@ 3Byte書き込んだか?
	addne	r10, r10, #1			@ カウントアップ
	bne	1b				@ loop
buffer_in_number_end:	

buffer_in_player:	
	ldr	r12, =print_row			@ print_rowを受け取る
	ldrb	r12, [r12]			@ 出力すべき行を受け取る
	mov	r11, #3				@ pleyerはy=3固定
	cmp	r11, r12			@ pleyerのいる行を表示するか?
	bne	buffer_in_player_end		@ 違うなら次のタスクへ
	mov	r12, #0				@ 列数を0~7まで数えるレジスタ
	ldrb	r11, [r1, #MUSIC_SELECT]	@ 選択中のマップ値を受け取る
	tst	r11, #1				@ 奇数か偶数か?
	moveq	r11, #6				@ Zフラグが立てば偶数->x6にプレイヤーを
	movne	r11, #4				@ Zフラグが消えれば奇数->x4にプレイヤーを
	mov	r10, #1				@ 格納する1を取得
	ldr	r9, =frame_buffer		@ frame_bufferの座標を受け取る
buffer_in_player_loop:
	cmp	r12, r11			@ 現在の列にpleyerが居るか
	streqb	r10, [r9, r12]			@ pleyerを書き込む
	cmp	r12, #7				@ 判定終了?
	addne	r12, r12, #1			@ 1を足す
	bne	buffer_in_player_loop		@ loop
buffer_in_player_end:
	
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

@壁の表示間隔の時間管理用
time_wall:	.word 0

@松明の表示制御
print_torch:	.byte	0, 0, 0, 0, 0, 0, 0, 0

@表示する行を時間で管理するデータ 時間になるとすべて１に 表示した行は0に戻る
check_time_row:		.byte 0, 0, 0, 0, 0, 0, 0, 0

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1

map_data:
	.byte	0, 0, 0, 0, 0
	.byte	0, 0, 0, 0, 0
	.byte	0, 0, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 1, 1
	.byte	0, 0, 1, 0, 1
	.byte	1, 1, 1, 1, 1
	.byte	1, 0, 1, 0, 0
	.byte	1, 1, 1, 0, 0
	.byte	0, 0, 0, 0, 0
	.byte	0, 0, 0, 0, 0

number_data:
	@B
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 0
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 1, 0
	.byte 0, 0, 0
	@0
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 0, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@1
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 0, 1, 0
	.byte 1, 1, 0
	.byte 0, 1, 0
	.byte 0, 1, 0
	.byte 1, 1, 1
	.byte 0, 0, 0
	@2
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 1, 1, 1
	.byte 1, 0, 0
	.byte 1, 1, 1
	.byte 0, 0, 0
	@3
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@4
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 0, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 0, 0, 1
	.byte 0, 0, 0
	@5
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 0
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@6
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@7
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 0, 0, 1
	.byte 0, 0, 1
	.byte 0, 0, 1
	.byte 0, 0, 0
	@8
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@9
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 1
	.byte 1, 1, 1
	.byte 0, 0, 0
	@A
	.byte 0, 0, 0
	.byte 0, 0, 0
	.byte 0, 1, 0
	.byte 1, 0, 1
	.byte 1, 1, 1
	.byte 1, 0, 1
	.byte 1, 0, 1
	.byte 0, 0, 0
	
