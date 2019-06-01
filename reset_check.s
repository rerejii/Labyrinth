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
	.global  reset_check
reset_check:	
@------データの保存-------------------------------------
backup:
	str	r9, [sp, #-4]!	@ push
	str	r10, [sp, #-4]!	@ push
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push

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
	beq	return						@ 押されていないスイッチがあれば終了
	cmp	r12, #3						@ すべてのスイッチの判定が終了したか?
	addne	r12, r12, #1					@ カウントアップ
	bne	sw_check_loop					@ loop
reset_on:
	mov	r12, #1						@ 1を格納
	strb	r12, [r1]					@ リセットONを格納
	
@------終了--------------------------------------------
return:
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
