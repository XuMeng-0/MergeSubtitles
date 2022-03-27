@echo off

rem 程序逻辑：(和自己手动合并相同)
rem 从一个文件中复制前三行作为输出文件的前三行，
rem 从另一个文件中复制第三行作为输出文件第四行，加一个空行
rem 从前一个文件复制第四到六行作为输出文件的第六到八行，
rem 从后一个文件中复制第六行作为输出文件第九行，加一个空行
rem  ……

if not exist %1 (
	echo 当前文件夹下未找到指定文件: %1，程序即将异常退出
	pause
	goto :end
)

if not exist %2 (
	echo 当前文件夹下未找到指定文件: %2，程序即将异常退出
	pause
	goto :end
)

set outputFileName="result.srt"
if "%3" == "" (
	echo 输出文件名未指定，将使用 result.srt 作为输出文件名
	pause ) else (
	set outputFileName=%3
)


setlocal enabledelayedexpansion

rem 外层for循环处理的文件的行号
set /a lineNumber1=1
rem 内层for循环处理的文件当前处理的位置
set /a currentPosition=0
rem 标记内层for循环处理的文件是否正在处理，1正在处理，0正在等待
set /a flag=1
rem 外层for循环处理的文件的总行数，用于计算进度
set /a numberOfRows=0
set /a progress=0
rem 用于辅助进度显示，当进度计算值和上一次相同时，不更新
set /a progressTemp=0

for /f %%a in (%2) do (
	set /a numberOfRows=!numberOfRows! + 1
)

rem 获取回车字符，用于原地显示合并进度
for /f %%a in ('copy /Z "%~dpf0" nul') do (
	set "carriageReturn=%%a"
) 

for /f "tokens=*" %%i in (%2) do (
	set /a temp1=!lineNumber1! %% 3
	if !temp1! == 0 (
		set /a flag=1
		set /a lineNumber2=0
		for /f "tokens=*" %%j in (%1) do (
			set /a lineNumber2=!lineNumber2! + 1
			if !flag! == 1 (if !lineNumber2! gtr !currentPosition! (
				set /a currentPosition=!currentPosition! + 1
				echo %%j >>%outputFileName%
				set /a temp2=!currentPosition! %% 3
				if !temp2! == 0 (set /a flag=0)
			) )			
		)
		echo %%i >>%outputFileName%
		echo. >>%outputFileName%
	)
	set /a lineNumber1=!lineNumber1! + 1
	
	set /a progress=!lineNumber1! * 100 / !numberOfRows!
	if !progress! neq !progressTemp! (
		set /p"=.!carriageReturn!进度：!progress!%%" <nul 
	)
	set /a progressTemp=!progress!
)

echo.
echo 合并完成，程序正常退出

endlocal

:end

set outputFileName=