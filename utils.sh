#!/bin/bash

LOGFILE="build/build_$(date +%Y-%m-%d_.%H-%M-%S).log"
RETAIN_NUM_LINES=10

# https://www.franzoni.eu/quick-log-for-bash-scripts-with-line-limit/
function utils::log::setup {
    TMP=$(tail -n "$RETAIN_NUM_LINES" "$LOGFILE" 2>/dev/null) && echo "${TMP}" > "$LOGFILE"
    exec > >(tee -a "$LOGFILE")
    exec 2>&1
}

function utils::log {
    echo "[$(date --rfc-3339=seconds)]: $*"
}
