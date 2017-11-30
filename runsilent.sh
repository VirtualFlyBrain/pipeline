#!/bin/bash
# Abort on Error
set -e

export JOBCMD=$1

touch $BUILD_OUTPUT

dump_output() {
   echo Tailing the last 500 lines of output:
   tail -500 $BUILD_OUTPUT  
}
error_handler() {
  echo ERROR: An error was encountered with the job.
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.

bash -c "while true; do echo \$(date '+%H:%M.%S') - \$(awk '/./{line=$0} END{print line}' ${BUILD_OUTPUT}) >>${WORKSPACE}/tick.out ; sleep $PING_SLEEP; done" &
PING_LOOP_PID=$!

$JOBCMD >> $BUILD_OUTPUT 2>&1

# The build finished without returning an error so dump a tail of the output
dump_output

# nicely terminate the ping output loop
kill $PING_LOOP_PID
