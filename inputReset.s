@------inputResetについて-------------------------------
@スイッチの入力をリセット(0に)するためのサブルーチンです
@-----------------------------------------------------

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	sw_valueの先頭番地
@------------------------

	.section .text
	.global  inputReset
inputReset:
@------データの保存-------------------------------------
backup:
	str	r12, [sp, #-4]!	@ push
@------初期化------------------------------------------
reset:	
	mov	r12, #0				@ 代入値
	mov	r11, #0				@ カウント
reset_loop:
	strb	r12, [r1, r11]			@ リセット
	cmp	r11, #3				@ 4回loop
	addne	r11, #1				@ カウントアップ
	bne	reset_loop			@ loop
@------終了--------------------------------------------
return:
	ldr	r12, [sp], #4		@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ 万一のためのloop
