@スイッチの入力受付用のサブルーチンです
@連続入力については入力を弾いて0を返します
@スイッチの値はsw_valueに書き込んで返します
@------------------------------------------------

	@-----プログラム上で設定した定数-----


@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	musicSelect_paramerers
@r2,	sw_valueの先頭番地
@r3,	reset_sw	
@------------------------
	.include "include.inc"
	.section .text
	.global  back_check
back_check:	
@------データの保存-------------------------------------
backup:
	str	r11, [sp, #-4]!	@ push
	str	r12, [sp, #-4]!	@ push
@------スイッチの状態更新--------------------------------
sw_check:
	ldrb	r12, [r2, #SW1]					@ sw1の状態を受け取る
	cmp	r12, #1						@ sw1が押されているか
	bne	return						@ 押されていなければ終了
	ldrb	r12, [r1, #MUSIC_SELECT]			@ 選択中の値を受けとる
	cmp	r12, #0						@ 終了番地か?
	bne	return						@ 選択されていなければ判定終了
	mov	r12, #1						@ 1を格納
	strb	r12, [r3]					@ resetモードon
@------終了--------------------------------------------
return:
	ldr	r12, [sp], #4		@ pop
	ldr	r11, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ 万一のためのloop

@======data==========================================
	.section .data

