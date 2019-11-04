## 项目简介

该项目包含EMAS演示App的iOS壳工程代码，可供参考使用。


## 跨平台研发

本demo工程仅供参考

工程目录中会根据您在平台上选定的首页结构自动生成WeexContainer-Info.json文件，例如：

```json
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>ScaffoldType</key>
	<integer>6</integer>
	<key>TabSize</key>
	<integer>1</integer>
	<key>JSSource</key>
	<dict>
		<key>0</key>
		<string>http://cdn.emas-poc.com/app/emas-showcase-weex-showcase/pages/index/entry.js</string>
	</dict>
</dict>
</plist>
```

* ScaffoldType = 0 脚手架为Native类型，里面是一些诸如mtop、高可用等相关SDK的使用demo

* ScaffoldType = 2 脚手架为weex类型

* ScaffoldType = 4 脚手架为H5类型

* ScaffoldType = 6 脚手架为Weex和H5混合类型


其中，当ScaffoldType为2或6时，tabsize会影响首页类型

* TabSize = 0 将进入原生首页
*  TabSize = 1 将进入单页面跨平台首页（weex），所渲染的页面是JsSource下面的一个路径所指向的js bundle
* TabSize > 1 将进入多tab的跨平台首页（weex），每个tab所渲染的页面是JsSource下面的多个路径所指向的js bundle



## 开发

SDK接入请参考https://help.aliyun.com/document_detail/88331.html



weex接入参考 https://help.aliyun.com/document_detail/91444.html



H5接入参考https://help.aliyun.com/document_detail/96529.html

