set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_60
path %JAVA_HOME%\bin;%path%
cd C:\Lamw\Projects\teste7
jarsigner -verify -verbose -certs C:\Lamw\Projects\teste7\build\outputs\apk\release\teste7-release.apk
