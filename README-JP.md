

ShumachTurnip は、[Turnip](https://github.com/jnicklas/turnip)を使用して
iOSデバイスの実機テストを可能にしたライブラリです。


## 準備

ruby環境を整備して、turnipを使用可能として下さい。

## 使い方

XCodeプロジェクトに ShumahcTurnipを追加して、クラスを登録します。


```
  self.turnip = ShumachTurnip(port: 8000)
  self.turnip!.currentObject = self;
```


JSON形式で、指定したクラスの操作をします。
メソッド呼び出し、インスタンスセット/ゲット、プロパティのセットゲットを行う事が
可能です。

```
{"target":"targetClass","action":{"type":"method","methodName":"method","args":[]}}
```


ターゲットのクラスは、ShumachTurnipを登録したクラスをルートとし、インスタンス名を"."
で接続した文字列で指定します。

```
  object1.object2
```


exampleに、上記の処理の行っているプログラムを用意しています。
