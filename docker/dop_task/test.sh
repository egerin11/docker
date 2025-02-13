#!/bin/sh
while true;do
echo "$(curl -I https://www.youtube.com/ 2>/dev/null | head -n 1 | cut -d$' ' -f2)" >>test.log
echo "$(curl -I https://www.youtube.com/ 2>/dev/null | tail -n +7  |head -n 1)" >>test.log
sleep 1
done


