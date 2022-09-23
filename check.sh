#!/bin/bash

#设置时区
timedatectl set-timezone Asia/Shanghai
if [ ! -f "/bin/check" ]; then
echo '第一次执行初始化...'
REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'" "alpine" )
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Alpine")
PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "apk update -f")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "apk add -f")
CMD=("$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)" "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)" "$(lsb_release -sd 2>/dev/null)" "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)" "$(grep . /etc/redhat-release 2>/dev/null)" "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')")
[[ $(id -u) != 0 ]] && echo "请使用“sudo -i”登录root用户后执行脚本！！！" && exit 1
for i in "${CMD[@]}"; do
	SYS="$i" && [[ -n $SYS ]] && break
done
for ((int = 0; int < ${#REGEX[@]}; int++)); do
	[[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && [[ -n $SYSTEM ]] && break
done
[[ -z $SYSTEM ]] && echo "不支持VPS的当前系统，请使用主流操作系统" && exit 1
${PACKAGE_UPDATE[int]}
${PACKAGE_INSTALL[int]} jq bc
         curl -sk "https://raw.githubusercontent.com/sunianOvO/fuckaz/main/check.sh">/bin/check
         chmod -R 777 /bin/check
         echo '初始化完成!'
     fi
# 颜色函数
function color_schema() {
    #  色彩    黑  红  绿  黄  蓝  洋红  青  白
    # 前景色   30  31  32  33  34   35   36  37
    # 背景色   40  41  42  43  44   45   46  47
    #
    # 规则 \033[前景色;背景色m

    high_color="\033[1;31m"
    low_color="\033[1;34m"
    medium_color="\033[1;35m"
    default_color="\033[0m"
}

# 服务器基础信息检查函数
function server_basics_message() {
    echo -e -n "--------------------------------基础信息--------------------------------\n"

    local os_name=`grep "PRETTY_NAME" /etc/os-release | cut -d= -f2 | cut -d\" -f2`
    local kernel_release=`uname -r`
    local os_hostname=`hostname`
    local now_time=`date +%Y-%m-%d\ %H:%M:%S`
    local sys_lang=`echo $LANG`

    echo -e "  系    统：\t${os_name}"
    echo -e "  内    核：\t${kernel_release}"
    echo -e "  主 机 名：\t${os_hostname}"
    echo -e "  系统语系: \t${sys_lang}"
    echo -e "  当前时间：\t${now_time}"
    cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("运行时长：\t%d天%d时%d分%d秒\n",run_days,run_hour,run_minute,run_second)}'
}

# CPU基础信息检查函数
function cpu_message() {
    color_schema

    echo -e -n "--------------------------------CPU 信息--------------------------------\n"

    local physical_id=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
    local cpu_cores=`grep "cpu cores" /proc/cpuinfo | uniq | awk '{print $4}'`
    local siblings=`grep "siblings" /proc/cpuinfo | uniq | awk '{print $3}'`
    local processor=`grep "processor" /proc/cpuinfo | wc -l`

    local cpu_availing=`top -n1 -b | grep "%Cpu(s)" | cut -d, -f4 | cut -c 1-5 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g'`
    local cpu_using=`awk 'BEGIN{printf "%0.2f%%",100-'${cpu_availing}'}'`

    local cpu_using_tmp=`awk 'BEGIN{printf "%0.2f",100-'${cpu_availing}'}'`

    if [ ${cpu_cores} -eq ${siblings} ]; then
        local is_use_hyper_threading="否"
    else
        local is_use_hyper_threading="是"
    fi

    echo -e "  物理CPU总数：        \t${physical_id}"
    echo -e "  逻辑CPU总数：        \t${processor}"
    echo -e "  每颗物理CPU的核心数：\t${cpu_cores}"
    echo -e "  是否使用超线程技术： \t${is_use_hyper_threading}"

    if [ $(echo "${cpu_using_tmp} < "33.33" " | bc) = "1" ]; then
        echo -e "  CPU使用率：          \t${low_color}${cpu_using}${default_color}"
    elif [ $(echo "${cpu_using_tmp} > "66.66" " | bc) = "1" ]; then
        echo -e "  CPU使用率：          \t${high_color}${cpu_using}${default_color}"
    else
        echo -e "  CPU使用率：          \t${medium_color}${cpu_using}${default_color}"
    fi
}

# 内存基本信息检查函数
function mem_message() {
    color_schema

    echo -e -n "--------------------------------内存信息--------------------------------\n"

    local mem_total_tmp=`free | grep "Mem" | awk '{print $2}'`
    local mem_used_tmp=`free | grep "Mem" | awk '{print $3}'`
    local mem_free_tmp=`free | grep "Mem" | awk '{print $4}'`

    local mem_total=`awk 'BEGIN{printf "%0.2f",'${mem_total_tmp}'/1024/1024}'`
    local mem_used=`awk 'BEGIN{printf "%0.2f",'${mem_used_tmp}'/1024/1024}'`
    local mem_avail=`awk 'BEGIN{printf "%0.2f",'${mem_total}'-'${mem_used}'}'`
    local mem_free=`awk 'BEGIN{printf "%0.2f",'${mem_free_tmp}'/1024/1024}'`

    local mem_using=`awk 'BEGIN{printf "%0.2f%%",'${mem_used}'/'${mem_total}'*100}'`

    local mem_using_tmp=`awk 'BEGIN{printf "%0.2f",'${mem_used}'/'${mem_total}'*100}'`

    local swap_total_tmp=`free | grep "Swap" | awk '{print $2}'`
    local swap_total=`awk 'BEGIN{printf "%0.2f",'${swap_total_tmp}'/1024/1024}'`

    local is_exist_swap="Unknow"

    if [ ${swap_total} = "0.00" ]; then
        local is_exist_swap="No"
    else
        local swap_used_tmp=`free | grep "Swap" | awk '{print $3}'`
        local swap_free_tmp=`free | grep "Swap" | awk '{print $4}'`

        local swap_used=`awk 'BEGIN{printf "%0.2f",'${swap_used_tmp}'/1024/1024}'`
        local swap_avail=`awk 'BEGIN{printf "%0.2f",'${swap_total}'-'${swap_used}'}'`
        local swap_free=`awk 'BEGIN{printf "%0.2f",'${swap_free_tmp}'/1024/1024}'`

        local swap_using=`awk 'BEGIN{printf "%0.2f%%",'${swap_used}'/'${swap_total}'*100}'`

        local swap_using_tmp=`awk 'BEGIN{printf "%0.2f",'${swap_used}'/'${swap_total}'*100}'`
    fi

    echo -e "  物理内存："
    echo -e "\t总量：\t${mem_total}G"
    echo -e "\t使用：\t${mem_used}G"
    echo -e "\t剩余：\t${mem_avail}G"
    echo -e "\tFree态：${mem_free}G"

    if [ $(echo "${mem_using_tmp} < "33.33" " | bc ) = "1" ]; then
        echo -e "\t使用率：${low_color}${mem_using}${default_color}"
    elif [ $(echo "${mem_using_tmp} > "66.66" " | bc ) = "1" ]; then
        echo -e "\t使用率：${high_color}${mem_using}${default_color}"
    else
        echo -e "\t使用率：${medium_color}${mem_using}${default_color}"
    fi

    if [ ${is_exist_swap} = "No" ]; then
        echo -e "  该服务器无交换分区！"
    else
        echo -e "  交换分区："
        echo -e "\t总量：\t${swap_total}G"
        echo -e "\t使用：\t${swap_used}G"
        echo -e "\t剩余：\t${swap_avail}G"
        echo -e "\tFree态：${swap_free}G"

        if [ $(echo "${swap_using_tmp} < "33.33" " | bc) = "1" ]; then
            echo -e "\t使用率：${low_color}${swap_using}${default_color}"
        elif [ $(echo "${swap_using_tmp} > "66.66" " | bc ) = "1" ]; then
            echo -e "\t使用率：${high_color}${swap_using}${default_color}"
        else
            echo -e "\t使用率：${medium_color}${swap_using}${default_color}"
        fi
    fi
}

# 磁盘基本信息检查函数
function disk_message() {
    color_schema

    echo -e -n "--------------------------------磁盘信息--------------------------------\n"

    local disk_dev_list=`fdisk -l | grep " /dev" | awk '{print $2}' | sed 's/：/ /g' | sed 's/:/ /g' | awk '{print $1}'`

    for disk_dev in ${disk_dev_list}; do
        local partition_list=`df | grep "${disk_dev}" | awk '{print $1}'`
        local partition_sum=`df | grep "${disk_dev}" | awk '{print $1}' | wc -l`

        local disk_dev_size=`fdisk -l | grep " ${disk_dev}" | sed 's/：/ /g' | sed 's/:/ /g' | sed 's/，/ /g' | sed 's/,/ /g' | awk '{print $3,$4}'`

        echo -e "  磁盘名称：\t${disk_dev}\t\t磁盘大小：${disk_dev_size}"

        if [ ${partition_sum} = "0" ]; then
            echo -e "    未找到磁盘设备${disk_dev}的挂载点！"
        else
            for partition in ${partition_list}; do
                local mount_point=`df | grep "${partition}" | awk '{print $6}'`
                local mount_size_sum=`df | grep "${partition}" | awk '{printf "%0.2f", $2/1024/1024}'`
                local mount_size_used=`df | grep "${partition}" | awk '{printf "%0.2f", $3/1024/1024}'`
                local mount_size_avail=`df | grep "${partition}" | awk '{printf "%0.2f", $4/1024/1024}'`
                local mount_size_using=`awk 'BEGIN{printf "%0.2f%%",'${mount_size_used}'/'${mount_size_sum}'*100}'`

                local mount_size_using_tmp=`awk 'BEGIN{printf "%0.2f",'${mount_size_used}'/'${mount_size_sum}'*100}'`

                echo -e "    挂载点：\t${mount_point}"
                echo -e "\t总量：\t${mount_size_sum}G"
                echo -e "\t使用：\t${mount_size_used}G"
                echo -e "\t剩余：\t${mount_size_avail}G"

                if [ $(echo "${mount_size_using_tmp} < "33.33" " | bc) = "1" ]; then
                    echo -e "\t使用率：${low_color}${mount_size_using}${default_color}"
                elif [ $(echo "${mount_size_using_tmp} > "66.66" " | bc) = "1" ]; then
                    echo -e "\t使用率：${high_color}${mount_size_using}${default_color}"
                else
                    echo -e "\t使用率：${medium_color}${mount_size_using}${default_color}"
                fi
            done
        fi
    done
}

# 网络基本信息检查函数
function network_message() {
    echo -e -n "------------------------------物理网卡信息------------------------------\n"

    local physical_network_card_list=`ls /sys/class/net/ | grep -v "\`ls /sys/devices/virtual/net/\`"`

    for physical_network_card in ${physical_network_card_list}; do
        local ipaddress_and_prefix=`ip addr | grep -A10 "${physical_network_card}" | awk '/inet/' | awk 'NR==1{print}' | awk '{print $2}'`
        local gateway=`ip addr | grep -A10 "${physical_network_card}" | awk '/inet/' | awk 'NR==1{print}' | awk '{print $4}'`

        if [ -z ${ipaddress_and_prefix} ]; then
            local ipaddress_and_prefix="未查询到${physical_network_card}网卡的IP地址！"
        fi
        if [ -z ${gateway} ]; then
            local gateway="未查询到${physical_network_card}网卡的网关地址！"
        fi

        echo -e "  网卡名称：\t${physical_network_card}"
        echo -e "    I P 地址：\t${ipaddress_and_prefix}"
        echo -e "    网关地址：\t${gateway}"
    done
    echo -e -n "\n"
}

clear

# 主函数
function main() {
    server_basics_message
    cpu_message
    mem_message
    disk_message
    network_message
}

# 运行
main
curl -s cip.cc|egrep -v URL| sed '/^[  ]*$/d'
curl -sk "https://www.ip125.com/api/$ip?lang=zh-CN"|jq
echo -e "\n相对ip属地:\n\033[1;32m$(curl -sk https://api.myip.la/cn)\033[0m"
