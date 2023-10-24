:: Created By ElBueno21

@echo off
setlocal enabledelayedexpansion

:Menu
cls
echo Menu:
echo 1) Encode base64
echo 2) Decode base64
echo q) Quit

set /p choice=Enter your choice: 

if "%choice%"=="1" (
    call :selectFile
    if not "!selectedFile!"=="" (
        call :Encode
    ) else (
        echo File selection canceled.
    )
	set "selectedPath=%~dp1"
	if exist "!selectedPath!tmp.b64" (
		del "!selectedPath!tmp.b64"
	)
    pause
    goto Menu
) else if "%choice%"=="2" (
    call :selectFile
    if not "!selectedFile!"=="" (
        call :Decode
    ) else (
        echo File selection canceled.
    )
    pause
    goto Menu
) else if "%choice%"=="q" (
    echo Exiting...
    exit /b 0
) else (
    echo Invalid choice. Please try again.
    pause
    goto Menu
)

:Encode
echo Encoding: !selectedFile!
set "selectedPath=%~dp1"
if not exist "!selectedPath!encoded.txt" (
    echo Creating decoded.txt in the same directory as the selected file.
	del "!selectedPath!tmp.b64"
	certutil -encode "!selectedFile!" tmp.b64 && findstr /v /c:- tmp.b64 > encoded.txt
) else (
    echo A decoded.txt file already exists in the same directory.
    choice /C YN /M "Would you like to overwrite that file? (Y/N)"
    if errorlevel 2 (
        echo File not overwritten.
        goto :EOF
     ) else if errorlevel 1 (
	 certutil -f -encode "!selectedFile!" tmp.b64 && findstr /v /c:- tmp.b64 > encoded.txt
	 goto :EOF
	 )
)
goto :EOF

:Decode
echo Decoding: !selectedFile!
set "selectedPath=%~dp1"
if not exist "!selectedPath!decoded.txt" (
    echo Creating decoded.txt in the same directory as the selected file.
) else (
    echo A decoded.txt file already exists in the same directory.
	choice /C YN /M "Would you like to overwrite that file? (Y/N)"
    if errorlevel 2 (
        echo File not overwritten.
        goto :EOF
    ) else if errorlevel 1 (
	certutil -f -decode "!selectedFile!" "!selectedPath!decoded.txt"
	goto :EOF
	)
)
certutil -decode "!selectedFile!" "!selectedPath!decoded.txt"
goto :EOF


:selectFile
:: Use PowerShell to show a file dialog and capture the selected file path
for /f "usebackq delims=" %%I in (`powershell -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName System.Windows.Forms; $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog; $openFileDialog.ShowDialog() | Out-Null; $openFileDialog.FileName"`) do set "selectedFile=%%I"
goto :EOF
