RED='\033[1;31m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NONE='\033[0m'
shopt -s nullglob
# set -e
# trap "echo -e '${RED}FAIL${NONE}'" ERR
test_cnt=$(find test/tc/ -name "*.in" -printf '.' | wc -m)
succ=0
fail=0
for i in test/tc/*.in;
do
	echo "Running "${i%.*}" ("$(( ($succ+$fail)*100/$test_cnt ))"%)"
	if diff <($1<$i) ${i%.*}.ans -BZ > /dev/null 2>&1; then
		succ=$((succ+1))
	else
		fail=$(($fail+1))
		fail_list+=$i", ";
	fi
done
echo -e "${GREEN}Ok: $succ tests${NONE}"
if (( $fail )); then
	echo -e "${RED}Fail: $fail tests. [$fail_list] ${NONE}"
	exit 1;
fi