# alert4jcluster
Compare J-cluster spot info and my wanted list and notify.

[J-クラスタ](http://qrv.jp/)のXMLファイルと
ハムログから出力した未交信リストを編集した魚リスト:want.txtを読み込んで、
未交信な都市からのQRVがspotされたら
デスクトップ通知を表示してアラーム音を鳴らすrubyスクリプトです。

 ![Linuxデスクトップ通知](notify.png "sample")

検索条件はJCC/JCG/AJA番号のみで、
町村番号/周波数/モードはチェックしません。

XMLのパースにはRubyのNokogiriを使いました。

J-クラスタへの定期的アクセスはcrontabでスケジュールします。

```
*/20 6-20 * * 6,7  /home/jh4xsy/bin/alert4jcluster.rb
```
