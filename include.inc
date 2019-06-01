	@-----�����ƥ��Ƿ����Ƥ������-----
	.equ	GPIO_BASE,		0x3f200000		@ GPIO�١������ɥ쥹
	.equ	GPFSEL0,		0x00			@ GPIO�ݡ��Ȥε�ǽ�����򤹤����ϤΥ��ե��å�
	.equ	GPFSEL_VEC0,		0x01201000		@ GPFSEL0 �����ꤹ���� (GPIO #4, #7, #8 ������Ѥ�����)
	.equ	GPFSEL_VEC1,		0x11249041		@ GPFSEL1 �����ꤹ���� (GPIO #10, #12, #14, #15, #16, #17, #18 ������Ѥ�����)
	.equ	GPFSEL_VEC2,		0x00209249		@ GPFSEL2 �����ꤹ���� (GPIO #20, #21, #22,#23, #24, #25, #27 ������Ѥ�����)
	.equ	GPSET0,			0x1C			@ GPIO�ݡ��Ȥν����ͤ�1�ˤ��뤿������ϤΥ��ե��å�
	.equ	GPCLR0,			0x28			@ GPIO�ܡ��Ȥν����ͤ�0�ˤ��뤿������ϤΥ��ե��å�
	.equ	COL1_PORT,		27			@ �ɥåȥޥȥ�å���LED1���ܤΥݡ����ֹ�
	.equ	COL2_PORT,		8			@ �ɥåȥޥȥ�å���LED2���ܤΥݡ����ֹ�
	.equ	COL3_PORT,		25			@ �ɥåȥޥȥ�å���LED3���ܤΥݡ����ֹ�
	.equ	COL4_PORT,		23			@ �ɥåȥޥȥ�å���LED4���ܤΥݡ����ֹ�
	.equ	COL5_PORT,		24			@ �ɥåȥޥȥ�å���LED5���ܤΥݡ����ֹ�
	.equ	COL6_PORT,		22			@ �ɥåȥޥȥ�å���LED6���ܤΥݡ����ֹ�
	.equ	COL7_PORT,		17			@ �ɥåȥޥȥ�å���LED7���ܤΥݡ����ֹ�
	.equ	COL8_PORT,		4			@ �ɥåȥޥȥ�å���LED8���ܤΥݡ����ֹ�
	.equ	ROW1_PORT,		14			@ �ɥåȥޥȥ�å���LED1���ܤΥݡ����ֹ�
	.equ	ROW2_PORT,		15			@ �ɥåȥޥȥ�å���LED2���ܤΥݡ����ֹ�
	.equ	ROW3_PORT,		21			@ �ɥåȥޥȥ�å���LED3���ܤΥݡ����ֹ�
	.equ	ROW4_PORT,		18			@ �ɥåȥޥȥ�å���LED4���ܤΥݡ����ֹ�
	.equ	ROW5_PORT,		12			@ �ɥåȥޥȥ�å���LED5���ܤΥݡ����ֹ�
	.equ	ROW6_PORT,		20			@ �ɥåȥޥȥ�å���LED6���ܤΥݡ����ֹ�
	.equ	ROW7_PORT,		7			@ �ɥåȥޥȥ�å���LED7���ܤΥݡ����ֹ�
	.equ	ROW8_PORT,		16			@ �ɥåȥޥȥ�å���LED8���ܤΥݡ����ֹ�
	.equ 	GPLEV0,			0x34			@ GPIO�ݡ��Ȥ������ͤ���Ǽ����Ƥ������ϤΥ��ե��å�
	.equ	SWITCH1_PORT,		13			@ �����å�1����³���줿GPIO�Υݡ����ֹ�
	.equ	SWITCH2_PORT,		26			@ �����å�2����³���줿GPIO�Υݡ����ֹ�
	.equ	SWITCH3_PORT,		5			@ �����å�3����³���줿GPIO�Υݡ����ֹ�
	.equ	SWITCH4_PORT,		6			@ �����å�4����³���줿GPIO�Υݡ����ֹ�
	.equ	TIMER_BASE,		0x3f003000		@ �����ƥॿ���ޤ�����쥸�����Υ١������ɥ쥹
	.equ	CLO,			0x4			@ �����ƥॿ���ޤβ���32bit�򼨤����ե��å�
	.equ	LED_PORT,	10			@ LED����³���줿GPIO�Υݡ����ֹ�

	.equ    PWM_HZ, 9600 * 1000
	.equ	CM_BASE, 	0x3f101000	@�����å��������Υ١������ɥ쥹
	.equ	PWM_BASE, 	0x3f20c000	@PWM �����椹�뤿��Υ쥸�����Υ١������ɥ쥹
	.equ	CM_PWMCTL, 	0xa0
	.equ	CM_PWMDIV, 	0xa4
	.equ	PWM_CLT, 	0x0
	.equ	PWM_PWEN2, 	8
	.equ	PWM_MSEN2, 	15
	.equ	PWM_RNG2, 	0x20
	.equ	PWM_DAT2, 	0x24
	@-----�ץ�����������ꤷ�����-----
	.equ	STACK, 			0x8000			@ �����å��ݥ���
	.equ	LABYRINTH_SIZE_X,	20			@ ��ӥ�󥹤�x�����Υ�����
	.equ	LABYRINTH_SIZE_Y,	19			@ ��ӥ�󥹤�y�����Υ�����
	.equ	PLAYER_START_X,		5			@ �ץ쥤�䡼�������Ȼ�x��ɸ
	.equ	PLAYER_START_Y,		6			@ �ץ쥤�䡼�������Ȼ�y��ɸ
	.equ	MAP_START_X,		12			@ �ޥåפΥ������Ȼ�x��ɸ
	.equ	MAP_START_Y,		11			@ �ޥåפΥ������Ȼ�y��ɸ
	.equ	GOAL_X,			2			@ �ޥåפΥ������Ȼ�x��ɸ
	.equ	GOAL_Y,			0			@ �ޥåפΥ������Ȼ�y��ɸ
	.equ	TORCH_START,		4			@ �����Υ������Ȼ����̥�٥�
	.equ	TORCH_SECONDS,		10			@ ������٥뤬����ޤǤ��ÿ�
	.equ	TORCH_POWER,		0			@ ����LEDĴ����
	.equ	BYTE,			8			@ 8bit=1Byte
	.equ	COORDINATE_X,		0x00			@ x��ɸ�򼨤�
	.equ	COORDINATE_Y,		0x01			@ y��ɸ�򼨤�
	.equ	MAP_MIN,		0			@ map���β���
	.equ	MAP_MAX,		6			@ map���ξ��
	.equ	MUSIC_MIN,		0			@ ����
	.equ	MUSIC_MAX,		11			@ ���ڤκ����
	.equ	DIFFICULTY_MAX,		2			@ ����٤κ�����
	.equ	SW1,			0
	.equ	SW2,			1
	.equ	SW3,			2
	.equ	SW4,			3
	@------labyrinth_paramerers��-----
	.equ	LABY_COORDINATE_X,	0			@ ��ӥ�󥹤�x�����Υ�����
	.equ	LABY_COORDINATE_Y,	1			@ ��ӥ�󥹤�x�����Υ�������ӥ�󥹤�y�����Υ�����
	.equ	MAP_COORDINATE_X,	2			@ �ޥå�ɽ�����֤�x��ɸ
	.equ	MAP_COORDINATE_Y,	3			@ �ޥå�ɽ�����֤�y��ɸ
	.equ	PLAYER_COORDINATE_X,	4			@ �ץ쥤�䡼��x��ɸ
	.equ	PLAYER_COORDINATE_Y,	5			@ �ץ쥤�䡼��y��ɸ
	.equ	GOAL_COORDINATE_X,	6			@ �������x��ɸ
	.equ	GOAL_COORDINATE_Y,	7			@ �������y��ɸ
	.equ	TORCH_LEVEL,		8			@ �ȡ�����٥�
	.equ	TORCH_SECONDS,		9			@ �ÿ�����Ф�
	.equ	TORCH_POWER,		10			@ ��٥���ξ����ζ���(0~100)
	.equ	TASK_FIRST_SW,		11			@ first_task��ư���뤫��Ƚ��

	@------mapSelect_paramerers��-----
	.equ	SELECT_MAP_NUMBER,	0			@ ����������Υޥåפ���Ф���
	.equ	DIFFICULTY_POINT,	1			@ �����
	.equ	CHEAT_SW,		2			@ �����ȥ⡼�ɤ���Ф�

	@------musicSelect_paramerers��------
	.equ	MUSIC_SELECT,		0			@ ����������β��ڤ���Ф���
