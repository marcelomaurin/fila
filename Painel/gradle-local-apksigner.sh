export PATH=/Lamw/android-sdk-windows/platform-tools:$PATH
export PATH=/Lamw/android-sdk-windows/build-tools/29.0.2:$PATH
export GRADLE_HOME=/Lamw/gradle-6.8.3
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Lamw/Projects/teste7/build/outputs/apk/release/teste7-armeabi-v7a-release-unsigned.apk /Lamw/Projects/teste7/build/outputs/apk/release/teste7-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /Lamw/Projects/teste7/teste7-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /Lamw/Projects/teste7/build/outputs/apk/release/teste7-release.apk /Lamw/Projects/teste7/build/outputs/apk/release/teste7-armeabi-v7a-release-unsigned-aligned.apk
