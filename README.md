# Labyrinth(ラビリンス)
ARMアセンブリでRaspberry Piに繋がる8×8ディスプレイやスピーカ等を制御し作成した迷路ゲームです。
LEDの秒間点滅速度を調整しプレイヤーと壁の位置を判別させ、音楽も特定の周波数を何秒流すという形式で手打ちで書いています。
コード行数は全体で17500程です。
オマケでBad Appleの影絵 https://www.nicovideo.jp/watch/sm8628149 を再現

- メインルーチン main.s
- Bad Apple動画コード bad_pv.s
- Bad Apple音楽コード bad_music.s

## ゲーム動画
- ゲーム動画: https://drive.google.com/open?id=1-369oTPhzCQRJ7Wn3x1RsQAax8_ZLriN
- Bad Apple動画: https://drive.google.com/open?id=1nqjd6CQDK0EmLISxau3qRxo3gOp1v5db
 
# 以下取扱説明書

## ゲーム概要
「嵐の中で迷い込んでしまった闇に包まれるラビリンス、あなたが持っているのは松明1本のみ」  
「闇に飲み込まれる前にラビリンスを出ることはできるか！」 
このゲームは迷路を探索し、制限時間以内にゴールを目指すゲームです。  
難易度は3段階、全6ステージの様々な迷路に挑戦出来ます。  
オープニングムービーでは、何かボタンを押すことでMap選択画面に移動できます。  
 
## 1. マップ選択画面

### 操作説明  
* スイッチ1(←ボタン)  
  -決定  
* スイッチ2(→ボタン)  
  -難易度調整  
  <ディスプレイ右上の赤色の点灯した数が現難易度を表します>  
  <レベル1~レベル3まで>  
* スイッチ3(↑ボタン)  
  -マップ選択  
  <ディスプレイ右の数字が現ステージを表します>  
* スイッチ4(↓ボタン)  
  -マップ選択  
  <ディスプレイ右の数字が現ステージを表します>


### イージーモード
スイッチ2を3秒間長押しすることで、LEDが明るく光りイージーモードに移行します。   
制限時間が3倍になります。


### Musicモード  
「スイッチ3」と 「スイッチ4」を3秒間同時押しすることで「Musicモード」に移行します。  
ゲーム中で使用されている音楽を鑑賞出来ます。

鑑賞できる音楽(順番は実際のMusicモードでの並びとなっています)
* 「艦これ」よりMAP選択BGM「海原越えて」
* 「東方project」より「稲田姫様に叱られるから」
* 「星のカービィー」より「グリーングリーンズ」
* 「FFV」より「ビックブリッジの死闘」
* 「アイドルマスター」より「キラメキラリ」
* 「東方project」より「平安のエイリアン」
* 「ガールズ＆パンツァー」より「カチューシャ」
* 「東方project」より「ナイト・オブ・ナイツ」
* 「スーパーマリオブラザーズ」より「Flagpole Fanfare」
* 「ドラゴンクエスト」より「全滅時のBGM」
* 「東方project」より「Bad Apple!!」

## 2. ゲーム画面

### 操作説明   
* スイッチ1(←ボタン)  
  -左へ移動  
* スイッチ2(→ボタン)  
  -右へ移動  
* スイッチ3(↑ボタン)  
  -上へ移動  
* スイッチ4(↓ボタン)  
  -下へ移動   
* スイッチ1,2,3,4同時押し(↑ + ↓ + → + ←)  
  -マップ選択画面へ戻る


### LED(松明)
LED(松明)は残り時間を表します。時間経過と共に徐々に暗くなって、完全に消えるとGAME OVERとなります。


![RASPPI](./Ras_pi.png?raw=true)

## 3. PV機能
マップ選択画面の際に0ステージを選択すると「Bad Apple!!」のPVが流れる機能があります。  
ラビリンスの世界に潜り込み過ぎて疲れた時などにどうぞ！  
PVが約3分なので、カップラーメン作るときにもどうぞ！
