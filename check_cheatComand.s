@------inputについて-------------------------------
@スイッチの入力受付用のサブルーチンです
@連続入力については入力を弾いて0を返します
@スイッチの値はsw_valueに書き込んで返します
@------------------------------------------------

	@-----プログラム上で設定した定数-----
	.equ	CHANGE_TIME,		3000000			@ (3秒)

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	sw_valueの先頭番地
@------------------------
	.include "include.inc"
	.section .text
	.global  check_cheatComand
check_cheatComand:	
@------データの保存-------------------------------------
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
@------初期動作-----------------------------------
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る
@------チート解除----------------------------------
	mov	r12, #0				@ 0を格納
	strb	r12, [r1, #CHEAT_SW]		@スイッチON_OFFを格納
@------時間更新-----------------------------------
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	ldr	r10, =CHANGE_TIME		@ 3秒を受け取る
	add	r10, r10, r12			@ 起動までの時間を調整
	ldr	r11, =time_change		@ time_changeの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop	
first_end:
	
sw_check:
	mov	r12, #1				@ loopカウント用
	ldr	r11, =switch_port		@ switch_portの座標を受け取る
	ldrb	r11, [r11, r12]			@ スイッチのポートを受け取る
	@#(GPLEV0 + SWITCH_PORT / 32 * 4)
	mov	r10, r11, lsr #5		@ 32で割る(r11のスイッチポート番号は後で使うため保護)
	mov	r10, r10, lsl #2		@ 4で掛ける
	add	r10, r10, #GPLEV0		@ GPIOポートの入力値が格納されている番地のオフセットを足す	
	ldr	r10, [r0, r10]			@ スイッチの状態を受け取る
	mov	r9, #1				@ 1
	and	r10, r9, r10, lsr r11		@ 論理積によりスイッチの値を取り出す(r11はスイッチポート番号)
	cmp	r10, #0				@ スイッチの値が0 or 0以外
	beq	reset				@ 押されていないスイッチがあれば3秒リセット
time_check:	
	@------time_sound取得------
	ldr	r11, =time_change		@ time_changeの番地取得
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
	bcc	return				@ 起動時間に成ってなければ終了
musicMode_on_off:
	ldrb	r11, [r1, #CHEAT_SW]		@ チート状態を受け取る
	cmp	r11, #0				@ 0 or 1
	moveq	r12, #1				@ 1を格納
	movne	r12, #0				@ 0を格納
	strb	r12, [r1, #CHEAT_SW]		@スイッチON_OFFを格納
reset:
@------次の3秒後へ-----------------------------------
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	ldr	r10, =CHANGE_TIME		@ 3秒を受け取る
	add	r10, r10, r12			@ 起動までの時間を調整
	ldr	r11, =time_change		@ time_changeの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop		
	
@------終了--------------------------------------------
return:
	ldrb	r11, [r1, #CHEAT_SW]		@ チート状態を受け取る
	cmp	r11, #0				@ 0 or 1
	@LED点灯
	movne	r1, #(1 << (LED_PORT % 32))
	strne	r1, [r0, #(GPSET0 + LED_PORT / 32 * 4)]
	@LED消灯
	moveq    r1, #(1 << (LED_PORT % 32))
	streq    r1, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	
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
@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1	

@スイッチポートのまとめ
switch_port:	.byte SWITCH1_PORT, SWITCH2_PORT, SWITCH3_PORT, SWITCH4_PORT

@変えるタイミングを測る
time_change:	.word	0
