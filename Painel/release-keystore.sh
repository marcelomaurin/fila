export JAVA_HOME=/Program Files/Java/jdk1.8.0_60
cd /Lamw/Projects/teste7
keytool -genkey -v -keystore teste7-release.keystore -alias teste7.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /Lamw/Projects/teste7/keytool_input.txt
