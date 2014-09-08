echo "Hello!!"

echo "Get touch screen handler"
adb shell cat /proc/bus/input/devices > handlerList
eventnum=`grep touchscreen -A 5 handlerList | grep 'event[0-9]\+' -o | grep '[0-9]\+' -o`
rm handlerList

adb shell getevent -lp /dev/input/event$eventnum > tmp
x=`grep ABS_MT_POSITION_X tmp | grep 'max [0-9]\+' -o | grep '[0-9]\+' -o`
y=`grep ABS_MT_POSITION_Y tmp | grep 'max [0-9]\+' -o | grep '[0-9]\+' -o`
rm tmp

./generateTrace $eventnum step trace.sh $x $y

for (( i = 0; i < $1; i++ )); do

	sleep 0.4

	adb shell screencap -p /sdcard/$i.png
	adb pull /sdcard/$i.png
	adb shell rm /sdcard/$i.png
	mv $i.png ./1/
	adb shell rm /sdcard/test.sh

	adb push ./trace.sh  /sdcard/test.sh
	adb shell sh /sdcard/test.sh

done


