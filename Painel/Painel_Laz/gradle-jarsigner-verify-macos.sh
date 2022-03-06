export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Lamw/Projects/teste7
jarsigner -verify -verbose -certs /Lamw/Projects/teste7/build/outputs/apk/release/teste7-release.apk
