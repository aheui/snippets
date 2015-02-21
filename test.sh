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
        echo -n "  test $fbase"...
        if [ -e "$d/$fbase".out ]; then
            if [ -e "$d/$fbase".in ]; then
                out=`$AHEUI $f < $d/$fbase.in`
            else
                out=`$AHEUI $f`
            fi
            exitcode=$?
            if [ -e "$d/$fbase".exitcode ]; then
              exitcodedata=`cat "$d/$fbase".exitcode`
            else
              exitcodedata=0
            fi
            outdata=`cat "$d/$fbase".out`
            if [ "$out" == "$outdata" ]; then
                if [ "$exitcode" == "$exitcodedata" ]; then
                    success=$(($success + 1))
                    echo -e "\x1B[92msuccess!\x1B[0m"
                else
                    fail=$(($fail + 1))
                    echo -e "\x1B[91mfail!\x1B[0m"
                    echo -e "    \x1B[92mexpected exitcode\x1B[0m $exitcodedata"
                    echo -e "    \x1B[91mactual exitcode\x1B[0m   $exitcode"
                fi
            else
                fail=$(($fail + 1))
                echo -e "\x1B[91mfail!\x1B[0m"
                echo -e "    \x1B[92mexpected\x1B[0m $outdata"
                echo -e "    \x1B[91mactual\x1B[0m   $out"
            fi
        else
            echo -e '\x1B[93moutput not found\x1B[0m'
        fi
    done
done

echo test status: $success/$(($success + $fail))
exit $fail
