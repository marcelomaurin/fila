export PATH=/Lamw/android-sdk-windows/platform-tools:$PATH
export GRADLE_HOME=/Lamw/gradle-6.8.3/
export PATH=$PATH:$GRADLE_HOME/bin
source ~/.bashrc
gradle clean bundle --info
