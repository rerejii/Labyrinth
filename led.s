@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	labyrinth_paramerersの先頭番地
@r2~12,	演算用及び受け渡し用	
@------------------------
	.include "include.inc" 
	.section .text
	.global led
led:
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

	mov	r12, #3				@ loopカウント
	ldr	r11, =add_time_led		@ add_time_ledの番地取得
	mov	r10, #0				@ 初期化
	ldrb	r8, [r1, #TORCH_LEVEL]		@ トーチレベルを受け取る
	mov	r8, r8, lsl #2			@ 4倍して座標を求める
1:
	add	r9, r12, r8			@ 座標を算出
	ldrb	r9, [r11, r9]			@ 受け取る
	add	r10, r10, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r10, r10, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	
	ldr	r12, =TIMER_BASE		@ システムタイマのベースアドレス
	ldr	r12, [r12, #CLO]    		@ (TIMER_BASE + オフセット)番地から読み出し
	
	add	r10, r10, r12			@ 起動までの時間を調整
	ldr	r11, =time_led			@ time_ledの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop
first_end:

	ldrb	r12, [r1, #TORCH_LEVEL]		@ 松明レベルを取り出す
	cmp	r12, #0				@ 松明レベルが0なら
	@ GPIO #10 に 0 を出力
	moveq	r7, #(1 << (LED_PORT % 32))
	streq	r7, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	beq	return

c_time_led:
	mov	r12, #0				@ loopカウント
	ldr	r11, =time_led			@ time_inputの番地取得
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
	@ GPIO #10 に 0 を出力
	movcc	r7, #(1 << (LED_PORT % 32))
	strcc	r7, [r0, #(GPCLR0 + LED_PORT / 32 * 4)]
	bcc	return				@ 終了

	mov	r12, #3				@ loopカウント
	ldr	r11, =add_time_led		@ add_time_ledの番地取得
	mov	r7, #0				@ 初期化
	ldrb	r8, [r1, #TORCH_LEVEL]		@ トーチレベルを受け取る
	mov	r8, r8, lsl #2			@ 4倍して座標を求める
1:
	add	r9, r12, r8			@ 座標を算出
	ldrb	r9, [r11, r9]			@ 受け取る
	add	r7, r7, r9			@ 足す
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	movne	r7, r7, lsl #BYTE		@ 受け取ったByteをずらして調整
	bne	1b				@ loop
	add	r10, r10, r7			@ 時間の更新
	
	ldrb	r12, [r1, #TORCH_POWER]		@ 松明の強さを取り出す
	rsb	r12, r12, #100			@ 減っているPOWERを算出
	mov	r11, #10			@ 10
	mul	r12, r11, r12			@ 10倍する
	add	r10, r10, r12			@ 減っているPOWERをLEDに影響させる
	
	ldr	r11, =time_led			@ time_ledの番地取得
	mov	r12, #3				@ loopカウント
1:
	strb	r10, [r11, r12]			@ 更新
	mov	r10, r10, lsr #BYTE		@ 書き込み終わった1Byteを右にずらす
	cmp	r12, #0				@ looe_end?
	subne	r12, r12, #1			@ カウントダウン
	bne	1b				@ loop

	@ GPIO #10 に 1 を出力
	mov     r7, #(1 << (LED_PORT % 32))
	str     r7, [r0, #(GPSET0 + LED_PORT / 32 * 4)]
	

@-----終了--------------------------------------------	
return:
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	ldr	r8, [sp], #4			@ pop
	ldr	r7, [sp], #4			@ pop
	bx	r14

@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ 万一のためのloop

@======data==========================================
	.section .data

light_sw:	.byte 0
	
@このサブレジスタを呼び出したのは始めてかのフラグ
first_flag:	.byte 1	
	
@トーチレベルに合わせた時間セット
add_time_led:	.word 0, 3200, 2200, 1200, 200

@LED判定に使う時間を格納
time_led:	.word 0
	
