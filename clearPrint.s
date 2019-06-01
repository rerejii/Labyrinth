@------printについて-------------------------------
@ドットマトリックスLED出力用のサブルーチンです
@受け取ったマップデータや座標データを元に表示します
@現在マップの選択機能はprintにはつけてません
@おそらくメインのlabyrinthで選択機能をつける事になるでしょう
@------------------------------------------------
	@-----print固有定数-----
	.equ	PV_TIME,		210000		@ 壁用
	.equ	BLOCK_SIZE, 8		@ コマ一つの大きさ
	.equ	DATA_SIZE, 50		@ 行の長さ

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	first
@------------------------
	.include "include.inc" 
	.section .text
	.global clearPrint

clearPrint:		
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
@-----初期動作-----------------------------------------	
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る

@------print_numberの初期化------
	mov	r12, #0				@ loopカウント
	ldr	r11, =print_number		@ 書き込むデータ番号座標
	mov	r10, #0				@ 0を格納
1:
	strb	r10, [r11, r12]			@ 値を更新
	cmp	r12, #3				@ loopが終了したか?
	addne	r12, r12, #1			@ loopカウントアップ
	movne	r10, r10, lsr #BYTE		@ 書き込み終わったbitをずらす
	bne	1b				@ loop
	
@------time_pvの初期化-------------------------------
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	ldr	r11, =PV_TIME			@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_pv			@ time_pvの番地取得
	mov	r9, #3				@ loopカウント
1:
	strb	r10, [r11, r9]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r9, #0				@ looe_end?
	subne	r9, r9, #1			@ カウントダウン
	bne	1b				@ loop
first_end:

@------time_pvの判定-------------------------------
c_time_pv:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_pv			@ time_pvの番地取得
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
	bcc	c_time_pv_end			@ 判定終了

	ldr	r12, =PV_TIME			@ timeを受け取る
	add	r10, r10, r12			@ 次の起動時間を求める
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_pv			@ time_pvの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
	@------print_number更新------
	mov	r12, #3				@ loopカウント
	ldr	r11, =print_number		@ print_numberの番地取得
	mov	r8, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r8, r8, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r8, r8, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	ldr	r12, =DATA_SIZE
	cmp	r8, r12
	addne	r8, r8, #1			@ 参照dataを更新
	moveq	r8, #0				@ 最初に戻る
	moveq	r7, #1				@ 1を確保
	streqb	r7, [r2]			@ 次のステージに進むフラグ番地フラグに1を
	
	mov	r12, #0				@ loopカウント
	ldr	r11, =print_number		@ 書き込むデータ番号座標
1:
	strb	r8, [r11, r12]			@ 値を更新
	cmp	r12, #3				@ loopが終了したか?
	addne	r12, r12, #1			@ loopカウントアップ
	movne	r8, r8, lsr #BYTE		@ 書き込み終わったbitをずらす
	bne	1b				@ loop
	
c_time_pv_end:


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
	
buffer_in_map:
	
	@ ---マップデータの列データをbufferに格納---

	@------print_number取り出し------
	mov	r12, #3				@ loopカウント
	ldr	r11, =print_number		@ print_numberの番地取得
	mov	r7, #0				@ 初期化
1:
	ldrb	r9, [r11, r12]			@ 受け取る
	add	r7, r7, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r7, r7, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	ldr	r8, =data		@ dataの番地を受け取る
	mov	r9, #BLOCK_SIZE		@ data一つあたりの大きさを受け取る
	mul	r9, r7, r9		@ コマ番号*dataサイズ
	ldr	r12, =print_row		@ print_rowを受け取る
	ldrb	r12, [r12]		@ 出力すべき行を受け取る
	add	r9, r9, r12		@ 表示する行に合わせてずらす
	ldrb	r8, [r8, r9]		@ dataから受け取る
	mov	r9, #0			@ loop用カウンター
	mov	r10, #1			@ 論理積用の1
set_loop:
	tst	r8, r10, lsl r9		@ 表示する行目のbitのみ取り出し判定
	movne	r11, #1			@ 取り出したbitが1の時	
	moveq	r11, #0			@ 取り出したbitが0の時
	ldr	r7, =frame_buffer
	strb	r11, [r7, r9]		@ 判定した値をframe_bufferに格納
	cmp	r9, #7			@ loop継続判定
	addne	r9, r9, #1		@ loop回数を増やす
	bne	set_loop		@ 列をすべて回りきれてないならloop
	@ -------------------------
buffer_in_map_end:

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
	
@出力すべきデータ
print_number:	.word 0

@壁の表示間隔の時間管理用
time_pv:	.word 0

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1

print_row:	.byte 0

data:	.byte 0, 92, 66, 66, 66, 220, 0, 0
.byte 0, 92, 66, 66, 66, 220, 0, 0
.byte 0, 46, 33, 33, 33, 238, 0, 0
.byte 0, 46, 33, 33, 33, 238, 0, 0
.byte 0, 23, 16, 16, 16, 247, 0, 0
.byte 0, 23, 16, 16, 16, 247, 0, 0
.byte 0, 11, 8, 8, 8, 123, 0, 0
.byte 0, 11, 8, 8, 8, 123, 0, 0
.byte 0, 133, 132, 132, 132, 189, 0, 0
.byte 0, 194, 66, 194, 66, 222, 0, 0
.byte 0, 194, 66, 194, 66, 222, 0, 0
.byte 0, 225, 33, 225, 33, 239, 0, 0
.byte 0, 225, 33, 225, 33, 239, 0, 0
.byte 0, 112, 16, 112, 16, 119, 0, 0
.byte 0, 112, 16, 112, 16, 119, 0, 0
.byte 0, 184, 136, 184, 136, 187, 0, 0
.byte 0, 184, 136, 184, 136, 187, 0, 0
.byte 0, 220, 68, 220, 68, 93, 0, 0
.byte 0, 220, 68, 220, 68, 93, 0, 0
.byte 0, 238, 162, 238, 162, 174, 0, 0
.byte 0, 238, 162, 238, 162, 174, 0, 0
.byte 0, 119, 81, 119, 81, 87, 0, 0
.byte 0, 119, 81, 119, 81, 87, 0, 0
.byte 0, 187, 168, 187, 168, 171, 0, 0
.byte 0, 187, 168, 187, 168, 171, 0, 0
.byte 0, 221, 84, 221, 84, 85, 0, 0
.byte 0, 221, 84, 221, 84, 85, 0, 0
.byte 0, 238, 42, 238, 42, 42, 0, 0
.byte 0, 238, 42, 238, 42, 42, 0, 0
.byte 0, 119, 149, 119, 149, 149, 0, 0
.byte 0, 119, 149, 119, 149, 149, 0, 0
.byte 0, 59, 74, 59, 74, 74, 0, 0
.byte 0, 59, 74, 59, 74, 74, 0, 0
.byte 0, 157, 165, 157, 37, 165, 0, 0
.byte 0, 157, 165, 157, 37, 165, 0, 0
.byte 0, 78, 82, 78, 18, 82, 0, 0
.byte 0, 78, 82, 78, 18, 82, 0, 0
.byte 0, 39, 41, 39, 9, 41, 0, 0
.byte 0, 39, 41, 39, 9, 41, 0, 0
.byte 0, 19, 20, 19, 4, 20, 0, 0
.byte 0, 19, 20, 19, 4, 20, 0, 0
.byte 0, 9, 10, 9, 2, 10, 0, 0
.byte 0, 9, 10, 9, 2, 10, 0, 0
.byte 0, 4, 5, 4, 1, 5, 0, 0
.byte 0, 4, 5, 4, 1, 5, 0, 0
.byte 0, 2, 2, 2, 0, 2, 0, 0
.byte 0, 2, 2, 2, 0, 2, 0, 0
.byte 0, 1, 1, 1, 0, 1, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
.byte 0, 0, 0, 0, 0, 0, 0, 0
