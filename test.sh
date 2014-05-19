#!/bin/bash

if [ ! "$AHEUI" ]; then
    echo "\$AHEUI must be set to run test"
    echo "try: AHEUI=<binary> bash test.sh"
    exit 1
fi

AHEUI_PATH=`which "${AHEUI}"`
if [ "$AHEUI_PATH" ]; then
    AHEUI="$AHEUI_PATH"
elif [ ${AHEUI:0:1} != '/' ]; then
    echo "sjfiod"
    AHEUI=`pwd`/"$AHEUI"
fi

for d in */; do
    pushd $d
    for f in *.aheui; do
        fbase=`basename "$f" .aheui`
        if [ -e "$fbase".out ]; then
            if [ -e "$fbase".in ]; then
                out=`$AHEUI $f < $fbase.in`
            else
                out=`$AHEUI $f`
            fi
            outdata=`cat "$fbase".out`
            if [ "$out" == "$outdata" ]; then
                echo "success!"
            else
                echo "fali!"
            fi
        fi
    done
    popd
done