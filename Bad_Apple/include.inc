	@-----システム上で決められている定数-----
	.equ    PWM_HZ, 9600 * 1000
	.equ	GPIO_BASE,		0x3f200000		@ GPIOベースアドレス
	.equ	GPIO_BASE,	0x3f200000	@ GPIOベースアドレス
	.equ	CM_BASE, 	0x3f101000	@クロックソースのベースアドレス
	.equ	PWM_BASE, 	0x3f20c000	@PWM を制御するためのレジスタのベースアドレス
	.equ	GPFSEL0,		0x00			@ GPIOポートの機能を選択する番地のオフセット
	.equ	GPFSEL_VEC0,		0x01201000		@ GPFSEL0 に設定する値 (GPIO #4, #7, #8 を出力用に設定)
	.equ	GPFSEL_VEC1,		0x11249041		@ GPFSEL1 に設定する値 (GPIO #10, #12, #14, #15, #16, #17, #18 を出力用に設定)
	.equ	GPFSEL_VEC2,		0x00209249		@ GPFSEL2 に設定する値 (GPIO #20, #21, #22,#23, #24, #25, #27 を出力用に設定)
	.equ	CM_PWMCTL, 	0xa0
	.equ	CM_PWMDIV, 	0xa4
	.equ	PWM_CLT, 	0x0
	.equ	PWM_PWEN2, 	8
	.equ	PWM_MSEN2, 	15
	.equ	PWM_RNG2, 	0x20
	.equ	PWM_DAT2, 	0x24
	.equ	GPSET0,			0x1C			@ GPIOポートの出力値を1にするための番地のオフセット
	.equ	GPCLR0,			0x28			@ GPIOボートの出力値を0にするための番地のオフセット
	.equ	COL1_PORT,		27			@ ドットマトリックスLED1列目のポート番号
	.equ	COL2_PORT,		8			@ ドットマトリックスLED2列目のポート番号
	.equ	COL3_PORT,		25			@ ドットマトリックスLED3列目のポート番号
	.equ	COL4_PORT,		23			@ ドットマトリックスLED4列目のポート番号
	.equ	COL5_PORT,		24			@ ドットマトリックスLED5列目のポート番号
	.equ	COL6_PORT,		22			@ ドットマトリックスLED6列目のポート番号
	.equ	COL7_PORT,		17			@ ドットマトリックスLED7列目のポート番号
	.equ	COL8_PORT,		4			@ ドットマトリックスLED8列目のポート番号
	.equ	ROW1_PORT,		14			@ ドットマトリックスLED1行目のポート番号
	.equ	ROW2_PORT,		15			@ ドットマトリックスLED2行目のポート番号
	.equ	ROW3_PORT,		21			@ ドットマトリックスLED3行目のポート番号
	.equ	ROW4_PORT,		18			@ ドットマトリックスLED4行目のポート番号
	.equ	ROW5_PORT,		12			@ ドットマトリックスLED5行目のポート番号
	.equ	ROW6_PORT,		20			@ ドットマトリックスLED6行目のポート番号
	.equ	ROW7_PORT,		7			@ ドットマトリックスLED7行目のポート番号
	.equ	ROW8_PORT,		16			@ ドットマトリックスLED8行目のポート番号
	.equ 	GPLEV0,			0x34			@ GPIOポートの入力値が格納されている番地のオフセット
	.equ	SWITCH1_PORT,		13			@ スイッチ1が接続されたGPIOのポート番号
	.equ	SWITCH2_PORT,		26			@ スイッチ2が接続されたGPIOのポート番号
	.equ	SWITCH3_PORT,		5			@ スイッチ3が接続されたGPIOのポート番号
	.equ	SWITCH4_PORT,		6			@ スイッチ4が接続されたGPIOのポート番号
	.equ	TIMER_BASE,		0x3f003000		@ システムタイマの制御レジスタのベースアドレス
	.equ	CLO,			0x4			@ システムタイマの下位32bitを示すオフセット
	.equ	LED_PORT,	10			@ LEDが接続されたGPIOのポート番号
	@-----プログラム上で設定した定数-----
	.equ	STACK, 			0x8000			@ スタックポインタ
	.equ	LABYRINTH_SIZE_X,	20			@ ラビリンスのx方向のサイズ
	.equ	LABYRINTH_SIZE_Y,	19			@ ラビリンスのy方向のサイズ
	.equ	PLAYER_START_X,		5			@ プレイヤースタート時x座標
	.equ	PLAYER_START_Y,		6			@ プレイヤースタート時y座標
	.equ	MAP_START_X,		12			@ マップのスタート時x座標
	.equ	MAP_START_Y,		11			@ マップのスタート時y座標
	.equ	GOAL_X,			2			@ マップのスタート時x座標
	.equ	GOAL_Y,			0			@ マップのスタート時y座標
	.equ	TORCH_START,		4			@ 松明のスタート時残量レベル
	.equ	TORCH_SECONDS,		10			@ 松明レベルが減るまでの秒数
	.equ	TORCH_POWER,		0			@ 松明LED調整用
	.equ	BYTE,			8			@ 8bit=1Byte
	.equ	COORDINATE_X,		0x00			@ x座標を示す
	.equ	COORDINATE_Y,		0x01			@ y座標を示す
	
	@------labyrinth_paramerers用-----
	.equ	LABY_COORDINATE_X,	0x00			@ ラビリンスのx方向のサイズ
	.equ	LABY_COORDINATE_Y,	0x01			@ ラビリンスのy方向のサイズ
	.equ	MAP_COORDINATE_X,	0x02			@ マップ表示位置のx座標
	.equ	MAP_COORDINATE_Y,	0x03			@ マップ表示位置のy座標
	.equ	PLAYER_COORDINATE_X,	0x04			@ プレイヤーのx座標
	.equ	PLAYER_COORDINATE_Y,	0x05			@ プレイヤーのy座標
	.equ	GOAL_COORDINATE_X,	0x06			@ ゴールのx座標
	.equ	GOAL_COORDINATE_Y,	0x07			@ ゴールのy座標
	.equ	TORCH_LEVEL,		0x08			@ トーチレベル
	.equ	TORCH_SECONDS,		0x09			@ 秒数を取り出す
	.equ	TORCH_POWER,		0x10			@ レベル内の松明の強さ(0~100)

