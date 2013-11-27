timeout_default_value="30 seconds"
timeout_multiplier="1"

timeout_killer_thread() {
	while true; do
		sleep 1
		if test_frozen; then
			return
		fi
		local multiplier="1"
		if [[ -s $test_timeout_multiplier_file ]]; then
			multiplier=$(cat "$test_timeout_multiplier_file")
		fi
		local begin_ts=$(cat "$test_timeout_begin_ts_file")
		local value=$(cat "$test_timeout_value_file")
		local now_ts=$(date +%s)
		
		echo begin_ts $begin_ts >> /tmp/dupa
		echo value $value >> /tmp/dupa
		echo multi $multiplier >> /tmp/dupa

		if [[ -z $begin_ts || -z $value ]]; then
			# A race with timeout_set occured (it truncates the endTS file and then writes it)
			continue
		fi

		local end_ts=$(($begin_ts + $value * $multiplier))

		if (( now_ts >= end_ts )); then
			test_add_failure "Test timed out ($(cat "$test_timeout_value_file"))"
			test_freeze_result
			killall -9 -u $(whoami)
		fi
	done
}

timeout_init() {
	test_timeout_begin_ts_file="$TEMP_DIR/$(unique_file)_timeout_beginTS.txt"
	test_timeout_multiplier_file="$TEMP_DIR/$(unique_file)_timeout_"
	test_timeout_value_file="$TEMP_DIR/$(unique_file)_timeout_value.txt"
	timeout_set "$timeout_default_value"
	timeout_set_multiplier "$timeout_multiplier"
	# Parentheses below are needed to make 'wait' command work in tests.
	# They make the killer thread to be a job owned by a temporary subshell, not ours
	( timeout_killer_thread & )
}

timeout_set() {
	echo $(($(date +%s -d "$*") - $(date +%s))) > "$test_timeout_value_file"
	date +%s > "$test_timeout_begin_ts_file"
}

timeout_set_multiplier() {
	echo "$1" > "$test_timeout_multiplier_file"
}

