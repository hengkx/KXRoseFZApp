```bash
# build_runner是dart团队提供的一个生成dart代码文件的外部包。
flutter packages pub run build_runner build
# 运行一次在后台持续监听
flutter packages pub run build_runner watch
# 清除缓存
flutter packages pub run build_runner clean
# (flutter build 默认会包含 --release选项)
flutter build apk
# lock
rm ./flutter/bin/cache/lockfile
```
