# recisdb_mirakc_container
## 注意
動作確認中。  
mirakc からストリームが来ないので、何か設定を見落としてそう。  
また、B-CASカードリーダーに関しては試していないので注意。  
(多分、podman machine の設定ファイルに、USBデバイスを追加した上で、色々やる必要がある)  
下記を参照して、b_cas_proxy とか使った方が楽だと思う。  
http://mun2.s308.xrea.com/soft01m.html  
(これ、b_cas_card.c を共有して良いのか分からない……)
## 簡単な説明
Containerfile のあるディレクトリで
```
podman build -t mirakc .
```
その後、下記のように実行すれば、mirakc のサーバーが立つ。
```
podman run --name mirakc -p 40772:40772 -v /mnt/etc/mirakc:/etc/mirakc -v /mnt/lib/mirakc:/var/lib/mirakc -v /dev:/dev --rm -detach localhost/mirakc
```
-v /mnt/etc〜 とか、-v /mnt/lib〜 のところは、各々、よしなにしてください。
## 注意点
- mirakc の build に、結構メモリが必要なようで、8GB は割り当てた方が良い。(4GBじゃ足らない可能性がある)
- podman machine init で、--volume=[任意のディレクトリ]:/mnt みたいにしておいて、任意のディレクトリに etc/mirakc と lib/mirakc を作れば、上のコマンドで動くはず。
- etc/mirakc の下に config.yml と strings.yml を置く。記載する内容は、mirakcを参照のこと。
- podman machine の timezone に注意。
