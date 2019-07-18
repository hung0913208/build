
#!/bin/bash
# File: Fetch.sh
# Description: this file should be run by LibBase's  Reproduce.sh and it is used
# to prepare scripts for reproducing only

ISSUE=$(basename $1)
PIPELINE=$(dirname $0)

if ! "$(git rev-parse --show-toplevel)"/Tests/Pipeline/Prepare.sh; then
	exit $?
fi

cat > $1/Tests/Pipeline/Install.sh << EOF
#!/bin/bash
ROOT="\$(git rev-parse --show-toplevel)"

source "$ROOT/Base/Tests/Pipeline/Libraries/Logcat.sh"
source "$ROOT/Base/Tests/Pipeline/Libraries/Package.sh"

SCRIPT=\$(basename \$0)
CURRENT=\$(pwd)
CODE=0

install_package gdb
if [ \$? != 0 ]; then
	exit -1
fi

if [ \$? != 0 ]; then
	CODE=\$?
fi

cd \$CURRENT
exit \$CODE
EOF

cat > $1/Tests/Pipeline/Test.sh << EOF
#!/bin/bash -x
ROOT=\$(git rev-parse --show-toplevel)

source $ROOT/Base/Tests/Pipeline/Libraries/Logcat.sh
SCRIPT=\$(basename \$0)

LLVM_SYMBOLIZER=\$(find /usr -name llvm-symbolizer)

gdb	-ex="set confirm on"				\
	-ex=run -ex="thread apply all bt" -ex=quit	\
	--args \$ROOT/build/Debug/Tests/\$(python -c "print(\"$SUITE\".lower())")
exit 1
EOF

cat > $1/Tests/Pipeline/Verify.sh << EOF
#!/bin/bash
ROOT=\$(git rev-parse --show-toplevel)

source $ROOT/Base/Tests/Pipeline/Libraries/Logcat.sh
SCRIPT=\$(basename \$0)

cat "\$1" | grep "exited normally" >& /dev/null

if [ \$? != 0 ]; then
	error "check log bellow:\n\$(cat \$1)"
fi
EOF

chmod +x $1/Tests/Pipeline/Install.sh
chmod +x $1/Tests/Pipeline/Test.sh
chmod +x $1/Tests/Pipeline/Verify.sh
