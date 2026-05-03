#!/bin/bash

# Function to start the processes
start_processes() {
    echo "Starting xi_search..."
    ./xi_search > /dev/null 2>&1 &

    echo "Starting xi_connect..."
    ./xi_connect > /dev/null 2>&1 &

    echo "Starting xi_world..."
    ./xi_world > /dev/null 2>&1 &

    echo "Starting xi_map..."
    ./xi_map > /dev/null 2>&1 &

    echo "All processes started."
}

# Function to stop the processes
stop_processes() {
    echo "Stopping xi_search..."
    kill -9 `ps -ef | grep [x]i_search | awk '{print $2}'` >  /dev/null 2>&1

    echo "Stopping xi_connect..."
    kill -9 `ps -ef | grep [x]i_connect | awk '{print $2}'` >  /dev/null 2>&1

    echo "Stopping xi_world..."
    kill -9 `ps -ef | grep [x]i_world | awk '{print $2}'` >  /dev/null 2>&1

    echo "Stopping xi_map..."
    kill -9 `ps -ef | grep [x]i_map | awk '{print $2}'` > /dev/null 2>&1

    echo "All processes stopped."
}

restart_process() {
   stop_processes
   start_processes
}


# Check for start or stop argument
if [ "$1" == "start" ]; then
    start_processes
elif [ "$1" == "stop" ]; then
    stop_processes
elif [ "$1" == "restart" ]; then
    restart_process
else
    echo "Usage: $0 {start|stop|restart}"
    exit 1
fi

