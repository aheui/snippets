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

success=0
fail=0
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
                success=$(($success + 1))
                echo "success!"
            else
                fail=$(($fail + 1))
                echo "fail!"
            fi
        else
            echo '  test output not found'
        fi
    done
done

echo test status: $success/$(($success + $fail))
exit $fail
