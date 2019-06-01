	@-----サブルーチン固有定数-----
	
	
@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	musicSelect_paramerersの先頭番地
@r2, 	sw_valueの先頭番地
@r3,	reset_mode
@--------------------------

@------ボタンの割り振りについて----------------------
@sw1: 左←
@sw2: 右→
@sw3: 上↑
@sw4: 下↓
@------------------------------------------------
	.include "include.inc" 
	.section .text
	.global  musicChange

musicChange:
@------データの保存-------------------------------------
backup:
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push
	str	r14, [sp, #-4]!			@ push

sw3:
	mov	r12, #2				@ sw3判定
	ldrb	r11, [r2, r12]			@ sw3の値を受け取る
	cmp	r11, #1				@ sw3が押されているか
	bne	sw3_end				@ 押されていなければ判定終了
	ldrb	r10, [r1, #MUSIC_SELECT]	@ Map値を受け取る
	cmp	r10, #MUSIC_MIN			@ 既に端なら
	beq	sw3_end				@ 判定終了
	sub	r10, r10, #1			@ Map値を減らす
	strb	r10, [r1, #MUSIC_SELECT]	@ Map値を更新
	bl	musicStop			@ musicStop呼び出し
	mov	r10, #1				@ 1を格納
	strb	r10, [r3]			@ 初期化処理有効
sw3_end:	
	
sw4:	
	mov	r12, #3				@ sw4判定
	ldrb	r11, [r2, r12]			@ sw4の値を受け取る
	cmp	r11, #1				@ sw4が押されているか
	bne	sw4_end				@ 押されていなければ判定終了
	ldrb	r10, [r1, #MUSIC_SELECT]	@ Map値を受け取る
	cmp	r10, #MUSIC_MAX			@ 既に端なら
	beq	sw4_end				@ 判定終了
	add	r10, r10, #1			@ Map値を減らす
	strb	r10, [r1, #MUSIC_SELECT]	@ Map値を更新
	bl	musicStop			@ musicStop呼び出し
	mov	r10, #1				@ 1を格納
	strb	r10, [r3]			@ 初期化処理有効
sw4_end:	
	
@------終了--------------------------------------------
return:
	ldr	r14, [sp], #4			@ pop
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	bx	r14
