#!/bin/sh
sum_cpu=0
prev_idle=0
prev_working=0
while true;do

#ps aux |tail -n +2 |awk '{print  $3}' |while read cpu; do
 #  let sum_cpu+=$cpu
#done
    #sum_cpu=$(top -bn1| grep "%Cpu(s)"|awk '{print ($1+$2+$3+$6+$7+$8)/($1+$2+$3+$4+$5+$6+$7+$8)}')
#    sum_cpu=$(awk 'NR==1{print 100*($2+$3+$4+$7+$8+$9)/($2+$3+$4+$7+$8+$9+$5+$6)}' /proc/stat)
#sum_cpu=$(awk 'NR==1{used=($2+$3+$4+$7+$8+$9); total=(used+$5+$6); print 100*used/total}' /proc/stat)
    now_idle=$(awk 'NR==1{print $5+$6}' /proc/stat)
    now_working=$(awk 'NR==1{print $2+$3+$4+$7+$8}' /proc/stat)

    working=$((now_working - prev_working))
    all_time=$((now_working + now_idle - prev_working - prev_idle))

    CPU_LOAD=$((working * 100 / all_time))
    prev_idle=$now_idle
    prev_working=$now_working
    sed -i "21s/.*/<h1> CPU LOAD: ${CPU_LOAD}%<\/h1>/" /var/www/html/cpu.html
    sleep 1
done

