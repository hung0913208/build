#!/bin/bash
# File: Prepare.sh
# Description: this file should be run first and it will fetch the latest
# LibBase before use this library to build a new Pipeline

BASE="$(git rev-parse --show-toplevel)/Base"
if ! git clone --branch Tests https://review.gerrithub.io/hung0913208/LibBase $BASE; then
	exit -1
fi

cat > $0 << EOF
#!/bin/bash
# File: Prepare.sh
# Description: this file should be called by Base/Tests/Pipeline/Prepare.sh
# to help to build a Pipeline

ROOT="$(git rev-parse --show-toplevel)"
PIPELINE="$(dirname "$0")"

source "$ROOT/Tests/Pipeline/Libraries/Logcat.sh"
source "$ROOT/Tests/Pipeline/Libraries/Package.sh"

SCRIPT="$(basename "$0")"
CURRENT="$(pwd)"

if [ -f $ROOT/Packages/RSyslog.rpm ]; then
else
	git clone https://github.com/rsyslog/rsyslog RSyslog
	cd RSyslog

	if [[ ${#COMMIT} -gt 0 ]]; then
		git checkout $COMMIT
	fi
fi
EOF

$BASE/Tests/Pipeline/Prepare.sh
exit $?
