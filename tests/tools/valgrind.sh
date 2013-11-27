# Valgrind error messages will be written here.
valgrind_log=${TEMP_DIR}/valgrind_log
valgrind_command="valgrind -q --leak-check=full --log-file=${valgrind_log}_%p"

# Not enabled yet.
valgrind_enabled=

# Enables valgrind, can be called at the beginning of a test case.
enable_valgrind () {
	if ! is_program_installed valgrind; then
		test_fail "valgrind not installed"
	fi
	if [[ -z ${valgrind_enabled} ]]; then
		valgrind_enabled=1
		echo Enabling valgrind in this test case.
		command_prefix="${valgrind_command} ${command_prefix}"
	fi
}

# Check valgrind log for error messages.
valgrind_check_log () {
	for file in "${valgrind_log}"*; do
		if [[ -s $file ]]; then	# if nonempty
			test_add_failure "Valgrind reported errors:" $'\n' "$(head -n 30 "$file")"
		fi
	done
}
test_register_pre_end valgrind_check_log

