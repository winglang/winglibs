#!/bin/sh
echo "Compiling..."
wing compile .
echo "Generating docs..."

( DEBUG="*" wing gen-docs ) & pid=$!
( sleep 2 && kill -HUP $pid ) 2>/dev/null & watcher=$!
if wait $pid 2>/dev/null; then
    echo "your_command finished"
    pkill -HUP -P $watcher
    wait $watcher
else
    echo "your_command interrupted"
fi

echo "Done"
echo "Removing lib/blah.txt"

rm lib/blah.txt

( DEBUG="*" wing gen-docs ) & pid=$!
( sleep 2 && kill -HUP $pid ) 2>/dev/null & watcher=$!
if wait $pid 2>/dev/null; then
    echo "your_command finished"
    pkill -HUP -P $watcher
    wait $watcher
else
    echo "your_command interrupted"
fi
