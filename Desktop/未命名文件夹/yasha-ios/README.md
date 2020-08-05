
# 亚厦项目iOS版

---

- 运行步骤

1.本项目使用Cocoapods进行依赖管理，打开前请执行 ```pod install```

2.依赖安装完毕后，点击`.xcworkspace`打开项目

---

- 开发注意事项

> 统一在dev分支下进行开发，打版本时合并至master分支

> 本项目使用MVC架构进行开发，每个页面文件夹下统一建立Model、View、Controller三个子文件，所有类文件加入YS前缀
 
> log日志打印请使用DLog

> Resource/PrefixHeader.pch 文件中统一存放全局宏以及第三方依赖文件的头文件作预编译

---

### dive in & have fun !!!

---

### 附：代码托管

---

- 基本命令

```git branch``` 查看当前分支

```git checkout [branchName]``` 切换分支

- 代码提交

```git add .``` 把文件修改添加到暂存区

```git commit -am 'log'```  把暂存区的所有修改提交到分支，须输入描述信息（一天多次）

```git push origin dev``` 提交本地dev分支到远程的dev分支（每天下班前提交）

- 代码合并

```git fetch origin dev```   更新远程dev分支到本地 

```git merge origin/dev```   合并dev分支，查看冲突，手动解决冲突

- 若有冲突，解决完冲突后执行（push前需沟通）

```git add .```

```git commit -am 'log'```

`git push origin dev`
