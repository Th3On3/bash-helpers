# ---------------------------------------
# gcc helpers
# ---------------------------------------

if type gdb &>/dev/null; then
  function bh_gdb_run_bt() {
    : ${1?"Usage: ${FUNCNAME[0]} <program>"}
    gdb -ex="set confirm off" -ex="set pagination off" -ex=r -ex=bt --args "$@"
  }

  function bh_gdb_run_bt_all_threads() {
    : ${1?"Usage: ${FUNCNAME[0]} <program>"}
    gdb -ex="set confirm off" -ex="set pagination off" -ex=r -ex=bt -ex="thread apply all bt" --args "$@"
  }
fi
