@------inputについて-------------------------------
@スイッチの入力受付用のサブルーチンです
@連続入力については入力を弾いて0を返します
@スイッチの値はsw_valueに書き込んで返します
@------------------------------------------------

	@-----プログラム上で設定した定数-----
	.equ	INPUT_TIME,		1000			@ task_input用(0.001秒)

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	sw_valueの先頭番地
@------------------------
	.include "include.inc"
	.section .text
	.global  input
input:
@------データの保存-------------------------------------
backup:
	str	r9, [sp, #-4]!	@ push
	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push

first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	ldr	r11, =INPUT_TIME		@ 初期タイムを受け取る
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_input		@ time_inputの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
first_end:	
	
c_time_input:
	
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_input		@ time_inputの番地取得
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
	bcc	return				@ 終了

	ldr	r12, =INPUT_TIME		@ 定数INPUT_TIMEを取得
	add	r10, r10, r12			@ 起動までの時間を調整
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_input		@ time_inputの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
@------スイッチの状態更新--------------------------------
sw_check:
	mov	r12, #0						@ loopカウント用
sw_check_loop:
	ldr	r11, =switch_port				@ switch_portの座標を受け取る
	ldrb	r11, [r11, r12]					@ スイッチのポートを受け取る
	@#(GPLEV0 + SWITCH_PORT / 32 * 4)
	mov	r10, r11, lsr #5				@ 32で割る(r11のスイッチポート番号は後で使うため保護)
	mov	r10, r10, lsl #2				@ 4で掛ける
	add	r10, r10, #GPLEV0				@ GPIOポートの入力値が格納されている番地のオフセットを足す
	
	ldr	r10, [r0, r10]					@ スイッチの状態を受け取る
	mov	r9, #1						@ 1
	and	r10, r9, r10, lsr r11				@ 論理積によりスイッチの値を取り出す(r11はスイッチポート番号)
	cmp	r10, #0						@ スイッチの値が0 or 0以外
	bne	sw_on
	
sw_off:
	mov	r9, #0						@ 0を
	strb	r9, [r1, r12]					@ sw_valueに書き込む
	ldr	r11, =sw_lock					@ sw_lockの座標を受け取る
	mov	r10, #0						@ ロック値0
	b	sw_end						@ sw_onを飛ばす
sw_on:	
	ldr	r11, =sw_lock					@ sw_lockの座標を受け取る
	ldrb	r10, [r11, r12]					@ スイッチのロック状態を受け足る
	cmp	r10, #0						@ スイッチがロックされているかの判定
	moveq	r9, #1						@ ロックされていないなら1を
	movne	r9, #0						@ ロックされているなら0を
	strb	r9, [r1, r12]					@ 値をsw_valueに書き込む
	mov	r10, #1						@ ロック値1

sw_end:
	ldr	r11, =sw_lock					@ sw_lockの座標を受け取る
	strb	r10, [r11, r12]					@ ロック値を更新(1以上=LOOK,0=UNLOOK)
	cmp	r12, #3						@ 4スイッチとも判定をおこなったか
	addmi	r12, r12, #1					@ カウントプラス
	bmi	sw_check_loop					@ すべてのスイッチの判定が終わってなければloop
@------終了--------------------------------------------
return:
@+++++++++++++++++++++++++++++++
@	mov	r9, #1
@	strb	r9, [r1]
@++++++++++++++++++++++++++++++
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	ldr	r10, [sp], #4		@ pop
	ldr	r9, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ 万一のためのloop

@======data==========================================
	.section .data
@スイッチポートのまとめ
switch_port:	.byte SWITCH1_PORT, SWITCH2_PORT, SWITCH3_PORT, SWITCH4_PORT
@連続入力防止用ロック値 1=LOOK,0=UNLOOK
sw_lock:	.byte 0, 0, 0, 0

time_input:	.word 0
	
@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1


