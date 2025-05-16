@echo off
echo ===== INICIANDO DEPLOY AUTOMATICO PARA HOSTINGER =====
echo.

echo 1. Gerando build do projeto Flutter...
cd /d %~dp0
call flutter clean
call flutter build web --release --web-renderer html
if %ERRORLEVEL% NEQ 0 (
  echo Erro ao gerar o build do projeto!
  pause
  exit /b 1
)
echo Build gerado com sucesso!
echo.

echo 2. Carregando variáveis de ambiente...
for /f "tokens=1,2 delims==" %%a in (.env) do (
  if "%%a"=="FTP_HOST" set FTP_HOST=%%b
  if "%%a"=="FTP_PORT" set FTP_PORT=%%b
  if "%%a"=="FTP_USER" set FTP_USER=%%b
  if "%%a"=="FTP_PASS" set FTP_PASS=%%b
)

echo 3. Preparando arquivo de configuracao para o FileZilla...
(
echo <?xml version="1.0" encoding="UTF-8"?>
echo ^<FileZilla3 version="3.60.1" platform="windows"^>
echo   ^<Queue^>
echo     ^<Server^>
echo       ^<Host^>%FTP_HOST%^</Host^>
echo       ^<Port^>%FTP_PORT%^</Port^>
echo       ^<Protocol^>0^</Protocol^>
echo       ^<Type^>0^</Type^>
echo       ^<User^>%FTP_USER%^</User^>
echo       ^<Pass encoding="base64"^>%FTP_PASS%^</Pass^>
echo       ^<Logontype^>1^</Logontype^>
echo       ^<EncodingType^>Auto^</EncodingType^>
echo       ^<BypassProxy^>0^</BypassProxy^>
echo     ^</Server^>
echo     ^<LocalDir^>%~dp0build\web^</LocalDir^>
echo     ^<RemoteDir^>1 0 8 public_html^</RemoteDir^>
echo     ^<SyncBrowsing^>0^</SyncBrowsing^>
echo     ^<TransferMode^>0^</TransferMode^>
echo   ^</Queue^>
echo ^</FileZilla3^>
) > "%TEMP%\filezilla_deploy.xml"
echo Arquivo de configuracao criado!
echo.

echo 4. Criando arquivo .htaccess para rotas do Flutter...
(
echo ^<IfModule mod_rewrite.c^>
echo   RewriteEngine On
echo   RewriteBase /
echo   RewriteRule ^index\.html$ - [L]
echo   RewriteCond %%{REQUEST_FILENAME} !-f
echo   RewriteCond %%{REQUEST_FILENAME} !-d
echo   RewriteRule . /index.html [L]
echo ^</IfModule^>
) > "%~dp0build\web\.htaccess"
echo Arquivo .htaccess criado!
echo.

echo 5. Iniciando upload para o Hostinger via FileZilla...
start "" "C:\Program Files\FileZilla FTP Client\filezilla.exe" -a "%TEMP%\filezilla_deploy.xml"
echo FileZilla iniciado! Por favor, confirme o upload na interface do FileZilla.
echo.

echo ===== PROCESSO DE DEPLOY INICIADO =====
echo IMPORTANTE: Verifique o FileZilla para completar o upload.
echo.
pause