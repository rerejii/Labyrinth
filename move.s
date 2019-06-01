@------moveについて--------------------------------
@マップの表示部分の変更と、プレイヤーの移動似ついてのサブメソッドです。
@マップは、画面表示部分のの左上の座標基準となってmap_xyに格納されています。
@プレイヤーは8*8の画面上のどこに存在するかの座標をplayer_xyに格納されています。	
@基本はプレイヤーが中央の4ドットのどこかに存在するようにマップを移動させます
@CAは、Coordinate Adjustment(座標調整)の略です
@------------------------------------------------
	
@------マップとプレイヤーの移動アルゴリズムについて-------
@1. プレイヤーが中央4ドット内に存在する場合 ->
@1.1. 移動する方向にプレイヤーを移動させた場合中央4ドット内に収まるなら「プレイヤーを移動させる」
@1.2. 移動する方向にプレイヤーを移動させた場合中央4ドット外にでるなら ->
@1.2.1 マップを動かしてもマップの端を越えて移動することがないなら「マップを動かす」
@1.2.2 マップを動かす事でマップの端を越える場合はプレイヤーを中央4ドットの外に出して「プレイヤーを移動させる」
@
@2. プレイヤーが中央4ドット外に存在する場合 ->
@2.1. 移動することで中央4ドットに近づく場合なら「プレイヤーを移動させる」
@2.2. 移動することで中央4ドットから離れる場合 ->
@2.2.1. マップを動かしてもマップの端を越えて移動することがないなら「マップを動かす」
@2.2.2. マップを動かす事でマップの端を越える場合は「プレイヤーを移動させる」
@------------------------------------------------

@------ボタンの割り振りについて----------------------
@sw1: 左←
@sw2: 右→
@sw3: 上↑
@sw4: 下↓
@------------------------------------------------

	@-----moce固有定数-----
	.equ	COORDINATE_X,		0x00		@ x座標を示す
	.equ	COORDINATE_Y,		0x01		@ y座標を示す
	.equ	CA_LEFT,		0		@ 左に進む判定の際の座標調整用
	.equ	CA_LIGHT,		8		@ 右に進む判定の際の座標調整用
	.equ	CA_UP,			0		@ 上に進む判定の際の座標調整用
	.equ	CA_DOUN,		8		@ 下に進む判定の際の座標調整用
	.equ	SW_LEFT,		0		@ 左に進む判定の際のスイッチ番号
	.equ	SW_LIGHT,		1		@ 右に進む判定の際のスイッチ番号
	.equ	SW_UP,			2		@ 上に進む判定の際のスイッチ番号
	.equ	SW_DOUN,		3		@ 下に進む判定の際のスイッチ番号
	
@---レジスタの種類------------
@r0, 	GPIO_BASE
@r1,	labyrinth_dataの先頭番地
@r2, 	labyrinth_paramerersの先頭番地
@r3, 	sw_value
@--------------------------
	.include "include.inc" 
	.section .text
	.global  move

move:

@------データの保存-------------------------------------
backup:
	str	r6, [sp, #-4]!			@ push
	str	r7, [sp, #-4]!			@ push
	str	r8, [sp, #-4]!			@ push
	str	r9, [sp, #-4]!			@ push
	str	r10, [sp, #-4]!			@ push
	str	r11, [sp, #-4]!			@ push
	str	r12, [sp, #-4]!			@ push

@------プレイヤーが中央4ドット内に存在する場合--------------
str:
	mov	r12, #0				@ カウント初期化
move_loop:	
	ldrb	r11, [r3, r12]			@ スイッチの状況を受け取る
	cmp	r11, #1				@ スイッチがonか?
	bne	end_check			@ offならそのスイッチの判定を終了
	ldr	r11, =xy_data			@ xy軸のどちらを見るかの判定用のデータの座標を受け取る
	ldrb	r11, [r11, r12]			@ xy軸のどちらを見るかの判定用のデータを受け取る
	cmp	r11, #COORDINATE_X
	ldreqb	r10, [r2, #PLAYER_COORDINATE_X]	@ プレイヤーの座標xを受け取る
	ldrneb	r10, [r2, #PLAYER_COORDINATE_Y]	@ プレイヤーの座標yを受け取る
	
	ldr	r9, =ca_data			@ ca_dataの座標を受け取る
	ldrb	r9, [r9, r12]			@ 上下左右に進むため、座標を足すべきか引くべきかの判定用にデータを受け取る
	cmp	r9, #0				@ 0なら上左であるから座標を減らす、それ以外なら下右であるから座標を増やす
	subeq	r8, r10, #1			@ 0なら上左であるから座標を1減らす
	addne	r8, r10, #1			@ それ以外なら下右であるから座標を1増やす
	cmp	r8, #8				@ 画面外にでないかの判定
	beq	end_check			@ 画面外に出そうなら判定終了
	cmp	r8, #-1				@ 画面外にでないかの判定
	beq	end_check			@ 画面外に出そうなら判定終了
	@------壁判定------------------------------------------
	str	r9, [sp, #-4]!			@ push
	ldrb	r7, [r2, #LABY_COORDINATE_X]	@ ラビリンスのサイズxを受け取る
	ldrb	r6, [r2, #MAP_COORDINATE_Y]	@ マップの座標yを受け取る
	cmp	r11, #COORDINATE_Y		@ 現在判定中の座標軸がxであるか
	moveq	r9, r8				@ プレイヤーの移動後の行を取得
	ldrneb	r9, [r2, #PLAYER_COORDINATE_Y]	@ プレイヤーが存在している行を取得
	add	r6, r6, r9			@ 行数をプラス
	mul	r6, r7, r6			@ 現在 or 移動先のプレイヤーの座標に当たるラビリンスの座標データの行のみを取得
	ldrb	r7, [r2, #MAP_COORDINATE_X]	@ マップの座標xを受け取る
	add	r6, r6, r7			@ マップ座標分ずらす
	cmp	r11, #COORDINATE_X		@ 現在判定中の座標軸がxであるか
	moveq	r7, r8				@ プレイヤーの移動後の列を取得
	ldrneb	r7, [r2, #PLAYER_COORDINATE_X]	@ プレイヤーが存在している列を取得
	add	r6, r6, r7			@ ここで移動先に当たるラビリンスの座標データを取得できる
	ldrb	r6, [r1 ,r6]			@ ラビリンスの座標データを受け取る
	cmp	r6, #0				@ 移動先は床or壁か?
	ldr	r9, [sp], #4			@ pop
	bne	end_check			@ 壁なら移動せずに判定終了
	@-----------------------------------------------------
	cmp	r8, #3				@ 動かした先の座標が中央4ドットの中か
	beq	move_player			@ プレイヤーを動かす
	cmp	r8, #4				@ 動かした先の座標が中央4ドットの中か
	beq	move_player			@ プレイヤーを動かす
	@ここの時点で中央から中央に移動する際の判定は考えなくてよくなる
	cmp	r10, #4				@ 中心線で分けた際にどちらに分類されるか
	bcc	under_half			@ 中心より低い座標
over_half:
	cmp	r8, r10				@ 中心に近づいて入れば、座標が減っているはず
	bcc	move_player			@ 中心に向かって入れば、プレイヤーを動かす
	@ここを通過する時点で中心から離れる動きをしているのは確定
	cmp	r11, #COORDINATE_X
	ldreqb	r7, [r2, #LABY_COORDINATE_X]	@ labyrinth_size_xを受け取る
	ldrneb	r7, [r2, #LABY_COORDINATE_Y]	@ labyrinth_size_yを受け取る
	ldreqb	r6, [r2, #MAP_COORDINATE_X]	@ map_xを受け取る
	ldrneb	r6, [r2, #MAP_COORDINATE_Y]	@ map_yを受け取る
	add	r6, r6, r9			@ 座標調整用CAを足す(7になるはず)
	cmp	r6, r7				@ 現在のマップ表示位置が既に端であるか
	beq	move_player			@ 端ならプレイヤーを動かす
	bne	move_map			@ 端でないならマップを動かす
under_half:	
	cmp	r8, r10				@ 中心に近づいて入れば、座標が増えているはず
	bhi	move_player			@ 中心に向かって入れば、プレイヤーを動かす
	@ここを通過する時点で中心から離れる動きをしているのは確定
	mov	r7, #0				@ labyrinthの端(0)を格納
	cmp	r11, #COORDINATE_X
	ldreqb	r6, [r2, #MAP_COORDINATE_X]	@ map_xyを受け取る
	ldrneb	r6, [r2, #MAP_COORDINATE_Y]	@ map_xyを受け取る
	add	r6, r6, r9			@ 座標調整用CAを足す(0になるはず)
	cmp	r6, r7				@ 現在のマップ表示位置が既に端であるか
	beq	move_player			@ 端ならプレイヤーを動かす
	bne	move_map			@ 端でないならマップを動かす

move_player:
	cmp	r11, #COORDINATE_X
	streqb	r8, [r2, #PLAYER_COORDINATE_X]	@ プレイヤーの座標xを書き込む
	strneb	r8, [r2, #PLAYER_COORDINATE_Y]	@ プレイヤーの座標yを書き込む
	b	end_check

move_map:
	cmp	r11, #COORDINATE_X
	ldreqb	r6, [r2, #MAP_COORDINATE_X]	@ map_xyを受け取る
	ldrneb	r6, [r2, #MAP_COORDINATE_Y]	@ map_xyを受け取る
	cmp	r9, #0				@ CAが0なら上左であるから座標を減らす、それ以外なら下右であるから座標を増やす
	subeq	r6, r6, #1			@ 0なら上左であるから座標を1減らす
	addne	r6, r6, #1			@ それ以外なら下右であるから座標を1増やす
	cmp	r11, #COORDINATE_X
	streqb	r6, [r2, #MAP_COORDINATE_X]	@ map_xyを受け取る
	strneb	r6, [r2, #MAP_COORDINATE_Y]	@ map_xyを受け取る
end_check:	
	cmp	r12, #3				@ 4方向とも判定が終わったかの判定
	addne	r12, #1				@ カウントアップ
	bne	move_loop			@ 判定が終わっていなければloop
	
@------終了--------------------------------------------
return:
	@mov	r8, #4
	@strb	r8, [r2, #0]			@ プレイヤーの座標x or yを書き込む
	ldr	r12, [sp], #4			@ pop
	ldr	r11, [sp], #4			@ pop
	ldr	r10, [sp], #4			@ pop
	ldr	r9, [sp], #4			@ pop
	ldr	r8, [sp], #4			@ pop
	ldr	r7, [sp], #4			@ pop
	ldr	r6, [sp], #4			@ pop
	bx	r14
	
@------safety----------------------------------------
safety_loop:
	b	safety_loop		@ 万一のためのloop

@======data==========================================
	.section .data
@マップを動かすのかプレイヤーを動かすのかを判定する (0=マップ 1=プレイヤ)
move_check_data:	.byte	0, 0, 0, 0

@------ボタンの割り振りについて----------------------
@sw1: 左←
@sw2: 右→
@sw3: 上↑
@sw4: 下↓
@------------------------------------------------
@座標調整用のデータ集	
ca_data:		.byte	CA_LEFT, CA_LIGHT, CA_UP, CA_DOUN
@スイッチの判別番号
sw_data:		.byte	SW_LEFT, SW_LIGHT, SW_UP, SW_DOUN
@xy軸選択データ
xy_data:		.byte	COORDINATE_X, COORDINATE_X, COORDINATE_Y, COORDINATE_Y
