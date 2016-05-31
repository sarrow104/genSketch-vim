# gensketch.vim

一个专门为 https://github.com/sarrow104/genSketch 工具定制的vim脚本

帮助其快速的应用模板，以及编辑模板；

----------------------------------------------------------------------

## 使用范例：

`:GenSketch qt/qrc 123 -Dpath=images`
 - 目的，在当前路径下创建 123.qrc 的资源文件。
 - 调用 $GenSketch-template/qc/qrc.tpl 下的脚本，并将“Taget=123”和“path=images”，作为变量，传递给该文件夹下的脚本。

`:GenSketch qt/cmake_local`
 - 目的，在当前路径下创建 CMakeLists.txt 和 Makefile 两个文件。
 - 调用 $GenSketch-template/qc/cmake_local.tpl 下的脚本，并将“Taget=当前文件夹名”，作为变量，传递给该文件夹下的脚本。

`:GenSketch qt/QObject MyQtUnit`
 - 目的，在当前路径下创建 MyQtUnit.cpp 和 MyQtUnit.h 两个文件。
 - 调用 $GenSketch-template/qc/QObject.tpl 下的脚本，并将“Taget=MyQtUnit”，作为变量，传递给该文件夹下的脚本。
