set -e
set -u

# Enable alias expansion and clear inherited aliases.
unalias -a
shopt -s expand_aliases

command_prefix=
for i in mfsmaster mfschunkserver mfsmount; do
	alias $i="\${command_prefix} $i"
done

. tools/config.sh
. tools/random.sh
. tools/system.sh
. tools/network.sh
. tools/test.sh
. tools/valgrind.sh
. tools/lizardfs.sh
. tools/timeout.sh

test_begin
