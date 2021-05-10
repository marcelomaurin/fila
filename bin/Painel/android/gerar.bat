set jdkbindir=C:\Program Files\Java\jdk-11.0.9\bin
set APP_NAME=Painel
set Yourpassword=PASSWORD
set YourApp=Painel
set YourHavefunsoft=Maurinsoft
set Yourcompany=maurinsoft
set YourSigla=BR
set Versao=armeabi-v7a-release-15

del Painel.keystore
REM "%jdkbindir%"\keytool -genkey -v -keystore Painel.keystore -alias Painel -keyalg RSA -keysize 2048 -validity 10000

REM Generating on the fly a debug key
"%jdkbindir%\keytool" -genkeypair -v -keystore Painel.keystore -alias %YourApp% -keyalg RSA -validity 10000 -dname "cn=%YourHavefunsoft%, o=%Yourcompany%, c=%YourSigla%" -storepass "%Yourpassword%" -keypass "%Yourpassword%" -keysize 2048
REM Assinando APK
REM #del %APP_NAME%-%Versao%.apk
"%jdkbindir%\jarsigner" -verbose  -sigalg SHA1withRSA  -digestalg SHA1  -keystore Painel.keystore -keypass %Yourpassword% -storepass %Yourpassword%  -signedjar %APP_NAME%-desalinhado.apk %APP_NAME%-%Versao%.apk Painel

REM Verificando assinatura
set jdkbindir=C:\Program Files\Java\jdk-11.0.9\bin
rem set APP_NAME=%APP_NAME%-desalinhado.apk

REM Signing the APK with a debug key
"%jdkbindir%\jarsigner" -verify -verbose -certs .\%APP_NAME%-desalinhado.apk

REM Alinhando APKset APP_NAME=testapp
set buildtoolsdir=C:\android\build-tools\28.0.2
REM Align the final APK package
%buildtoolsdir%\zipalign -p -f -v 4 .\%APP_NAME%-desalinhado.apk .\%APP_NAME%.apk