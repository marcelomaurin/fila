set Path=%PATH%;C:\Lamw\apache-ant-1.9.6
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_60
cd C:\Lamw\Projects\teste7
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
