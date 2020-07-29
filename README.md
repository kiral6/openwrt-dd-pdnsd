# openwrt pdnsd package
with enable-ipv6

The cloned Makefile of pdnsd from https://dev.openwrt.org/export/HEAD/packages/net/pdnsd/

You can use "src-git pdnsd git://github.com/kiral6/openwrt-dd-pdnsd.git" to add pdnsd for compilatioin in openwrt.

```
cp feeds.conf.default feeds.conf
echo 'src-git pdnsd git://github.com/kiral6/openwrt-dd-pdnsd.git' >> feeds.conf

./scripts/feeds update -a
./scripts/feeds install pdnsd
```
