#!/bin/bash

if [ ! "$AHEUI" ]; then
    echo "\$AHEUI must be set to run test"
    echo "try: AHEUI=<binary> bash test.sh"
    exit 1
fi

if [ ${1} ]; then
    ds=${*}
else
    ds=*/
fi

for d in $ds; do
    echo 'testset:' $d
    for f in $d/*.aheui; do
        fbase=`basename "$f" .aheui`
        if [ -e "$d/$fbase".out ]; then
            echo -n "  test $fbase"...
            if [ -e "$d/$fbase".in ]; then
                out=`$AHEUI $f < $d/$fbase.in`
            else
                out=`$AHEUI $f`
            fi
            outdata=`cat "$d/$fbase".out`
            if [ "$out" == "$outdata" ]; then
                echo "success!"
            else
                echo "fail!"
            fi
        else
            echo '  test output not found'
        fi
    done
done