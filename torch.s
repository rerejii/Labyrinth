	@-----torch固有定数--------
	.equ	MS10,		10000			@ 0.001秒
	.equ	SECOND,		1000000			@ 1秒
	.equ	TORCH_TIME,	100000000		@ 松明レベル管理時間(10秒)

@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	labyrinth_paramerersの先頭番地
@r2~12,	演算用及び受け渡し用	
@------------------------
	.include "include.inc" 
	.section .text
	.global  torch

torch:
@-----データの保存-------------------------------------
backup:
	str	r7, [sp, #-4]!			@ push
	str	r8, [sp, #-4]!			@ push
	str	r9, [sp, #-4]!			@ push
 	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push
@-----初期動作起動判定-----------------------------------------
first_now:
	ldrb	r12, [r1, #TASK_FIRST_SW]	@ 初期動作判定値を受け取る
	cmp	r12, #1				@ 初期動作を起動するか?
	ldreq	r11, =first_flag		@ first_flagの番地
	streqb	r12, [r11]			@ 書き込み
@-----初期起動----------------------------------------
first_task:
	ldr	r12, =first_flag		@ r12にfirst_flagの番地
	ldrb	r11, [r12]			@ 初期起動のフラグを取得
	cmp	r11, #1				@ 初めての起動か?
	bne	first_end			@ 終了
	mov	r11, #0				@ 0格納
	strb	r11, [r12]			@ フラグを折る
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	ldrb	r11, [r1, #TORCH_SECONDS]	@ TORCH_TIMEを受け取る
	ldr	r10, =SECOND			@ 1秒
	mul	r11, r10, r11			@ 時間を算出する
	add	r10, r11, r12			@ 起動までの時間を調整
	ldr	r11, =time_torch		@ time_torchの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop

first_end:

time_tor:
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
	subcc	r9, r10, r12			@ 差分抽出
	movcs	r9, #0				@ 0
	ldrb	r8, [r1, #TORCH_SECONDS]	@ 秒の取得
	ldr	r7, =MS10			@ 0.1秒
	mul	r8, r7, r8			@ (松明減少時間/100)=1とした値
	udiv	r9, r9, r8			@ 100~0
	strb	r9, [r1, #TORCH_POWER]		@ 松明の強さを更新

	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	cmp	r12, r10			@ 時間の判定
	bcc	time_tor_end			@ 判定終了
	ldrb	r12, [r1, #TORCH_SECONDS]	@ TORCH_TIMEを受け取る
	ldr	r11, =SECOND			@ 1秒
	mul	r12, r11, r12			@ 時間を算出する	
	add	r10, r10, r12			@ 起動までの時間を調整
	mov	r12, #3				@ loopカウント
	ldr	r11, =time_torch		@ time_torchの番地取得
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
	
	ldrb	r12, [r1, #TORCH_LEVEL]		@ 松明レベルを受け取る
	cmp	r12, #0				@ 松明レベルが既に0なら
	beq	time_tor_end			@ 更新せず終了
	sub	r12, r12, #1			@ 松明レベルを減らす
	strb	r12, [r1, #TORCH_LEVEL]		@ 更新
time_tor_end:

	
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

@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1

@松明の減少管理
time_torch:	.word 0
