set Path=%PATH%;C:\Lamw\android-sdk-windows\platform-tools;C:\Lamw\android-sdk-windows\build-tools\29.0.2
set GRADLE_HOME=C:\Lamw\gradle-6.8.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Lamw\Projects\teste7\build\outputs\apk\release\teste7-universal-release-unsigned.apk C:\Lamw\Projects\teste7\build\outputs\apk\release\teste7-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\Lamw\Projects\teste7\teste7-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\Lamw\Projects\teste7\build\outputs\apk\release\teste7-release.apk C:\Lamw\Projects\teste7\build\outputs\apk\release\teste7-universal-release-unsigned-aligned.apk
