@REM "设置文字编码UTF8(不然这里中文是UFT8,在命令行中会默认不是UTF8会出现斤拷棍,但是还是可能有问题建议不要写中文)"
@echo off
chcp 65001>nul
@REM "下面是要自己指定的部分(=左右不要空格)，后面都是set来设定临时环境变量，如果希望直接设置好，改成setx就行，写了检测，不会重复"

set picosdkpath_temp=D:\MyProgramData\MCU_SDK\pico-sdk
@REM mingw32-make.exe
set "make_bin_path=D:\MyProgramData\Toolchain\mingw-w64\mingw64\bin"
set make_exe_name=mingw32-make.exe
@REM 初始化一下环境变量,获取系统的环境变量
set "env_path=%PATH%"

@REM "起手就问工程名称，免得还要写一次,不要写空格"

set /p projectname=your projectname: 
echo your projectname is %projectname%

@REM 检测PICO_SDK，如果不存在就添加
@echo off
if not defined PICO_SDK_PATH (
    echo Environment variable PICO_SDK_PATH is not set
    echo now, set it to %picosdkpath_temp%
    set PICO_SDK_PATH=%picosdkpath_temp%
) else (
    echo Environment variable PICO_SDK_PATH is set to %PICO_SDK_PATH%
)


@REM "检测PICO_SDK，如果不存在就添加（用if not exist mingw32-make.exe会一直显示不存在，只能查找字符串。或者findstr /C:%make_bin_path%"

echo "%path%" | find /i "%make_bin_path%" >nul  
if %errorlevel% equ 0 (
    @REM "存在就显示一下好了"
    echo mingw toolchain has been set to %make_bin_path%
) else (
    @REM "不存在就添加一下"
    echo mingw toolchain is not set

    @REM "追加变量"

    @set "path=%env_path%;%make_bin_path%"
    echo mingw toolchain is set to %make_bin_path%
)


@REM "调用tsv文件，虽然默认也是这个，设置名称，默认打开vscode"
python pico_project.py  %projectname%  -t pico_configs.tsv -p vscode --gui

@REM "完事打开code"
code ../%projectname%
