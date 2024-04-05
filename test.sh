#!/bin/bash

if [ ! "$AHEUI" ]; then
    echo "\$AHEUI must be set to run test"
    echo "try: AHEUI=<binary> bash test.sh"
    exit 1
fi

if [ ${1} ]; then
    if [ $1 == --disable ]; then
        ds=*/
        mode='optout'
    else
        ds=${*}
        mode='optin'
    fi
else
    ds=*/
    mode='optout'
fi

echo "mode: $mode / targets: $ds"

success=0
fail=0
for d in $ds; do
    check=''
    if [ $mode == optout ]; then
        for dx in ${*}; do
            if [ $d == $dx ]; then
                check=1
                break
            fi
            if [ $d == $dx'/' ]; then
                check=1
                break
            fi
        done
    fi
    if [ $check ]; then
        continue
    fi

    echo 'testset:' $d
    for f in $d/*.aheui; do
        fbase=`basename "$f" .aheui`
        echo -n "  test $fbase"...
        if [ -e "$d/$fbase".out ]; then
            if [ -e "$d/$fbase".in ]; then
                $AHEUI $AHEUIFLAGS "$f" < "$d/$fbase.in" > .test.tmp
            else
                $AHEUI $AHEUIFLAGS "$f" > .test.tmp
            fi
            exitcode=$?
            out=`cat .test.tmp`
            if [ -e "$d/$fbase".exitcode ]; then
                exitcodetest=1
                exitcodedata=`cat "$d/$fbase".exitcode`
            else
                exitcodetest=0
            fi
            outdata=`cat "$d/$fbase".out`
            if [ "$out" == "$outdata" ]; then
                if [ "$exitcodetest" == 1 ]; then
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
                    success=$(($success + 1))
                    echo -e "\x1B[92msuccess!\x1B[0m"
                fi
            else
                fail=$(($fail + 1))
                echo -e "\x1B[91mfail!\x1B[0m"
                echo -e "    \x1B[92mexpected\x1B[0m $outdata"
                echo -e "    \x1B[91mactual\x1B[0m   $out"
                echo -e "diff from actual to expected"
                diff -u .test.tmp "$d/$fbase.out"
            fi
            rm .test.tmp
        else
            echo -e '\x1B[93moutput not found\x1B[0m'
        fi
    done
done

echo -e "test status: $success/\x1B[92m$(($success + $fail))\x1B[0m"
exit $fail
