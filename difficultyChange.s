@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	mapSelect_paramerersの先頭番地
@r2, 	sw_valueの先頭番地
@--------------------------

@------ボタンの割り振りについて----------------------
@sw1: 左←
@sw2: 右→
@sw3: 上↑
@sw4: 下↓
@------------------------------------------------
	.include "include.inc" 
	.section .text
	.global  difficultyChange

difficultyChange:
@------データの保存-------------------------------------
backup:
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push

sw2:
	mov	r12, #1				@ sw2判定
	ldrb	r11, [r2, r12]			@ sw2の値を受け取る
	cmp	r11, #1				@ sw2が押されているか
	bne	sw2_end				@ 押されていなければ判定終了
	ldrb	r10, [r1, #DIFFICULTY_POINT]	@ 難易度値を受け取る
	cmp	r10, #DIFFICULTY_MAX		@ 既にMAXなら
	moveq	r10, #0				@ 難易度を戻す
	addne	r10, r10, #1			@ 難易度値を増やす
	strb	r10, [r1, #DIFFICULTY_POINT]	@ 難易度値を更新
sw2_end:	
	
@------終了--------------------------------------------
return:
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	bx	r14
