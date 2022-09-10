#!/bin/bash
if [ ! -f "./.XX/cloud-shell/fuckb1s.py" ]; then
echo '第一次执行初始化...'
/usr/bin/python3 -m pip install --upgrade pip
pip install azure-cli
         mkdir ./.XX/cloud-shell
         git clone https://github.com/sunianOvO/fuckaz/ ./.XX/cloud-shell/ 2>/dev/null
         echo '初始化完成!'
     fi
    
if [[ $1 == 'update' ]]
  then
  echo '升级覆盖中...'
  rm -rf ./.XX/cloud-shell
  bash <(curl -Ls https://raw.githubusercontent.com/sunianOvO/fuckaz/main/cloud-shell/fuckaz.sh)
elif [[ $1 == 'check' ]]
  then
  bash <(curl -Ls https://raw.githubusercontent.com/sunianOvO/fuckaz/main/check.sh)
  exit 0
elif [[ $1 == 'screen' ]]
  then
  bash <(curl -Ls https://raw.githubusercontent.com/sunianOvO/fuckaz/main/screen.sh)
  exit 0
fi
if [[ $1 ]]
then
  if [[ $1 == 'rm' ]]
  then
      az group delete --name ResourceGroup --no-wait --yes
  elif [[ $1 == 'read' ]]
  then
    echo '请输入自定义开机脚本:'
    read shell
    echo "#cloud-config
runcmd:
  - sudo -s
  - ${shell}
  - "> ./.XX/cloud-shell/cloud-init.txt
  elif [[ $1 == 'null' ]]
  then
     echo '将以已存在的 cloud-init.txt 为开机脚本，请确认脚本内容是否需要修改？(5秒后自动执行)'
     echo "#####################"
     echo "$(cat ./.XX/cloud-shell/cloud-init.txt)"
     echo "#####################" 
     echo '请确认开机代码无误！！！'
     sleep 5
   else
echo '你输入的钱包地址为:'
echo "#####################"
echo "$1"
echo "#####################" 
echo '请确认钱包地址无误！！！'
echo "#cloud-config
runcmd:
  - sudo -s
  - export HOME=/root && curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s $1
  - "> ./.XX/cloud-shell/cloud-init.txt
  fi
else
echo ':) 重要参数丢失!'
echo "#####################"
echo '示例命令:'
echo '自定义钱包门罗币地址:  fuckaz 钱包地址'
echo '只开机不挖矿:  fuckaz null'
echo "#####################"
exit 250
fi
     
rm -f ./.XX/cloud-shell/ip.txt
rm -f ./.XX/cloud-shell/ip1.txt
rm -f ./.XX/cloud-shell/ip2.txt
rm -f /root/.ssh/known_hosts
python3 ./.XX/cloud-shell/fuckb1s.py
python3 ./.XX/cloud-shell/fuckd2as.py
python3 ./.XX/cloud-shell/fucke2bds.py
rm -f ./.XX/cloud-shell/fuck.txt
az vm list -d > ./.XX/cloud-shell/fuck.txt
az vm open-port --ids $(az vm list -g ResourceGroup --query "[].id" -o tsv) --port '*'
cat ./.XX/cloud-shell/fuck.txt | sed 's/,/\n/g' | grep "publicIps" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sort -u > ./.XX/cloud-shell/ip.txt
sed -r 's/["]{1,10}$//' ./.XX/cloud-shell/ip.txt > ./.XX/cloud-shell/ip1.txt
cat ./.XX/cloud-shell/ip1.txt | sed s/[[:space:]]//g  | sort -u > ./.XX/cloud-shell/ip2.txt
rm -f ./.XX/cloud-shell/ip1.txt 
rm -f ./.XX/cloud-shell/ip.txt
mv ./.XX/cloud-shell/ip2.txt ./.XX/cloud-shell/ip.txt
sed -i '$d' ./.XX/cloud-shell/ip.txt
sed -i 's/.//' ./.XX/cloud-shell/ip.txt
cat ./.XX/cloud-shell/ip.txt
echo "#####################"
echo "共计开机 $(cat ./.XX/cloud-shell/ip.txt|wc -l) 台"
echo "用时  $SECONDS 秒"
echo "#####################"
