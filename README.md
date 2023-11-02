# recisdb_mirakc_container
## 簡単な説明
Containerfile のあるディレクトリで
```
podman build -t mirakc .
```
その後、下記のように実行すれば、mirakc のサーバーが立つ。
```
podman run --name mirakc -p 40772:40772 -v /mnt/etc/mirakc:/etc/mirakc -v /mnt/lib/mirakc:/var/lib/mirakc -v /dev:/dev --tz=Asia/Tokyo --rm -detach localhost/mirakc
```

## 注意点
- mirakc の build に、結構メモリが必要なようで、8GB は割り当てた方が良い。(4GBじゃ足らない可能性がある)
- マウント関連は、podman machine 上のディレクトリに対してのマウントであることに注意。
- /etc/mirakc の下に config.yml と strings.yml を置くこと。(記載する内容は、mirakcを参照)
- tzが無い場合、どういう不具合が出るか分からないので注意

## マウント関連 
podman machine init で、--volume=[任意のディレクトリ]:/mnt みたいにしておいて、左記の[任意のディレクトリ]に etc/mirakc と lib/mirakc を作れば、上のコマンドで動くはず。

## B-CASカードリーダーに関して
未確認のため、特に対応はできません。  
/Users/[username]/.config/containers/podman/machine/qemu/podman-machine-default.json のQEMU実行時コマンドにカードリーダーUSBデバイスの追記をすれば、おそらく動くはず。

## BonCasProxyに関して
podman上のコンテナとして動かす場合は、下記を参照して、BonCasProxyを導入した方が良いと思う。  
http://mun2.s308.xrea.com/soft01m.html  
この場合、Containerfile を置いたディレクトリに、書き換えた b_cas_card.c を配置し、
https://github.com/sakuei-ld/recisdb_mirakc_container/blob/c959d29ccdd454abea84b8006afbe05db5a85056/Containerfile#L27-L29
の RUN と COPY のコメントアウトを外せば、導入できる。  
Macとかで動かしてるなら、下記を参照して、Mac上で perl版 BonCasServer を動かせば、いい感じに出来るハズ。  
https://github.com/walkure/bcs-perl/blob/master/README.ja  
https://web.chaperone.jp/w/index.php?pt2/BonCasLink  
(忘れちゃったので、過去のメモとか見つけられたら書き換えます)

## その他
b_cas_card.c の改造版は、ライセンス関係が怪しいので、今のところは置いておきません。  
(特に問題ない、というのが明確に分かれば、追加します)  
あと、mirakc の初回動作は、少し時間が掛かるかも。
