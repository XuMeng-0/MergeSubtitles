@echo off

rem �����߼���(���Լ��ֶ��ϲ���ͬ)
rem ��һ���ļ��и���ǰ������Ϊ����ļ���ǰ���У�
rem ����һ���ļ��и��Ƶ�������Ϊ����ļ������У���һ������
rem ��ǰһ���ļ����Ƶ��ĵ�������Ϊ����ļ��ĵ��������У�
rem �Ӻ�һ���ļ��и��Ƶ�������Ϊ����ļ��ھ��У���һ������
rem  ����

if not exist %1 (
	echo ��ǰ�ļ�����δ�ҵ�ָ���ļ�: %1�����򼴽��쳣�˳�
	pause
	goto :end
)

if not exist %2 (
	echo ��ǰ�ļ�����δ�ҵ�ָ���ļ�: %2�����򼴽��쳣�˳�
	pause
	goto :end
)

set outputFileName="result.srt"
if "%3" == "" (
	echo ����ļ���δָ������ʹ�� result.srt ��Ϊ����ļ���
	pause ) else (
	set outputFileName=%3
)


setlocal enabledelayedexpansion

rem ���forѭ��������ļ����к�
set /a lineNumber1=1
rem �ڲ�forѭ��������ļ���ǰ�����λ��
set /a currentPosition=0
rem ����ڲ�forѭ��������ļ��Ƿ����ڴ���1���ڴ���0���ڵȴ�
set /a flag=1
rem ���forѭ��������ļ��������������ڼ������
set /a numberOfRows=0
set /a progress=0
rem ���ڸ���������ʾ�������ȼ���ֵ����һ����ͬʱ��������
set /a progressTemp=0

for /f %%a in (%2) do (
	set /a numberOfRows=!numberOfRows! + 1
)

rem ��ȡ�س��ַ�������ԭ����ʾ�ϲ�����
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
		set /p"=.!carriageReturn!���ȣ�!progress!%%" <nul 
	)
	set /a progressTemp=!progress!
)

echo.
echo �ϲ���ɣ����������˳�

endlocal

:end

set outputFileName=