#!/bin/bash

rm -rf $0

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi：${plain} Tập lệnh này phải được chạy với tư cách người dùng root!\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}Phiên bản hệ thống không được phát hiện, vui lòng liên hệ với tác giả kịch bản!${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
  arch="64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
  arch="arm64-v8a"
else
  arch="64"
  echo -e "${red}Không phát hiện được giản đồ, hãy sử dụng lược đồ mặc định: ${arch}${plain}"
fi

echo "Hệ Phiên Bản: ${arch}"

if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ] ; then
    echo "Phần mềm này không hỗ trợ hệ thống 32-bit (x86), vui lòng sử dụng hệ thống 64-bit (x86_64), nếu phát hiện sai, vui lòng liên hệ với tác giả"
    exit 2
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Vui lòng sử dụng CentOS 7 trở lên!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng Ubuntu 16 hoặc cao hơn!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng Debian 8 trở lên!${plain}\n" && exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install epel-release -y
        yum install wget curl unzip tar crontabs socat -y
    else
        apt update -y
        apt install wget curl unzip tar cron socat -y
    fi
}

# 0: running, 1: not running, 2: not installed
check_status() {
    if [[ ! -f /etc/systemd/system/XrayR.service ]]; then
        return 2
    fi
    temp=$(systemctl status XrayR | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

install_acme() {
    curl https://get.acme.sh | sh
}

install_XrayR() {
    if [[ -e /usr/local/XrayR/ ]]; then
        rm /usr/local/XrayR/ -rf
    fi

    mkdir /usr/local/XrayR/ -p
	cd /usr/local/XrayR/

    if  [ $# == 0 ] ;then
        last_version=$(curl -Ls "https://api.github.com/repos/AikoCute/XrayR/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}Không thể phát hiện phiên bản XrayR, có thể đã vượt quá giới hạn API Github, vui lòng thử lại sau hoặc chỉ định phiên bản XrayR để cài đặt theo cách thủ công${plain}"
            exit 1
        fi
        echo -e "Đã phát hiện phiên bản mới nhất của XrayR:${last_version}，bắt đầu cài đặt"
        wget -N --no-check-certificate -O /usr/local/XrayR/XrayR-linux.zip https://github.com/AikoCute/XrayR/releases/download/${last_version}/XrayR-linux-${arch}.zip
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Không tải xuống được XrayR, hãy đảm bảo máy chủ của bạn có thể tải xuống tệp Github${plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/AikoCute/XrayR/releases/download/${last_version}/XrayR-linux-${arch}.zip"
        echo -e "bắt đầu cài đặt XrayR v$1"
        wget -N --no-check-certificate -O /usr/local/XrayR/XrayR-linux.zip ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Tải xuống XrayR v$1 không thành công, hãy đảm bảo rằng phiên bản này tồn tại${plain}"
            exit 1
        fi
    fi

    unzip XrayR-linux.zip
    rm XrayR-linux.zip -f
    chmod +x XrayR
    mkdir /etc/XrayR/ -p
    rm /etc/systemd/system/XrayR.service -f
    file="https://raw.githubusercontent.com/AikoCute/XrayR-release/data/XrayR.service"
    wget -N --no-check-certificate -O /etc/systemd/system/XrayR.service ${file}
    #cp -f XrayR.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl stop XrayR
    systemctl enable XrayR
    echo -e "${green}AikoCute XrayR ${last_version}${plain} Quá trình cài đặt hoàn tất, nó đã được thiết lập để bắt đầu tự động"
    cp geoip.dat /etc/XrayR/
    cp geosite.dat /etc/XrayR/ 

    if [[ ! -f /etc/XrayR/config.yml ]]; then
        cp config.yml /etc/XrayR/
        echo -e ""
        echo -e "Cài đặt mới, vui lòng tham khảo hướng dẫn trước：https://github.com/AikoCute/XrayR，Định cấu hình nội dung cần thiết"
    else
        systemctl start XrayR
        sleep 2
        check_status
        echo -e ""
        if [[ $? == 0 ]]; then
            echo -e "${green}XrayR khởi động lại thành công${plain}"
        else
            echo -e "${red}XrayR Có thể không khởi động được, vui lòng sử dụng sau XrayR log Kiểm tra thông tin nhật ký, nếu không khởi động được, định dạng cấu hình có thể đã bị thay đổi, vui lòng vào wiki để kiểm tra：https://github.com/AikoCute/XrayR/wiki${plain}"
        fi
    fi

    if [[ ! -f /etc/XrayR/dns.json ]]; then
        cp dns.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/route.json ]]; then
        cp route.json /etc/XrayR/
    fi
    if [[ ! -f /etc/XrayR/custom_outbound.json ]]; then
        cp custom_outbound.json /etc/XrayR/
    fi
    curl -o /usr/bin/XrayR -Ls https://raw.githubusercontent.com/AikoCute/XrayR-release/data/XrayR.sh
    chmod +x /usr/bin/XrayR
    ln -s /usr/bin/XrayR /usr/bin/xrayr # chữ thường tương thích
    chmod +x /usr/bin/xrayr
    

    echo -e "-------------------------"
    echo -e "[1] Aiko : aikocute.com"
    echo -e "[2] nhkvpn : nhkvpn.net"
    echo -e "[3] aqvpn : aqvpn.me - Gạch Tên :D"
    echo -e "-------------------------"
    read -p "Vui lòng chọn Web lên sever: " choose
    echo -e "${green}Bạn đã chọn Web : ${choose}${plain}"

    if [ "$choose" == "1" ]; then 
        echo -e "-------------------------"
        echo -e "[1] Node :01 - 01.hk.aikocute.com - HK"
        echo -e "[2] Node :02 - 01.sing.aikocute.com - SG"
        echo -e "[3] Node :03 - 01.vn.aikocute.com - VN1"
        echo -e "[4] Node :04 - 02.vn.aikocute.com - VN2"
        echo -e "[5] Node :05 - 01.jp.aikocute.com - JP"
        echo -e "[6] Node :06 - 01.us.aikocute.com - US"
        echo -e "[7] Node :07 - 03.vn.aikocute.com - VN3"
        echo -e "[8] Node :08 - 02.sing.aikocute.com - SG"
        echo -e "[9] Node :09 - 04.vn.aikocute.com - VN4"
        echo -e "[10] Node :10 - Trống - ID"
        echo -e "[11] Node :11 - garena.aikocute.com - VN"
        echo -e " Nhấn enter để chuyển sang chế độ nhập - Vmess"
        echo -e "-------------------------"
        read -p "Vui lòng chọn config cấu hình: " choose_node


        if [ "$choose_node" == "1" ]; then 
        # Đặt số nút
        node_id="1"
        domain="01.hk.aikocute.com"

        #Ghi file
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/HK-01/01.hk.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/HK-01/01.hk-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "2" ]; then 
        node_id="2"
        domain="01.sing.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-01/01.sing.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-01/01.sing-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "3" ]; then
        node_id="3"
        domain="01.vn.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-01/01.vn.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-01/01.vn-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "4" ]; then
        node_id="4"
        domain="02.vn.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-02/02.vn.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-02/02.vn-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "5" ]; then
        node_id="5"
        domain="01.jp.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/JP-01/01.jp.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/JP-01/01.jp-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "6" ]; then
        node_id="6"
        domain="01.us.aikocute.com"
    
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/US-01/01.us.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/US-01/01.us-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml

        elif [ "$choose_node" == "7" ]; then
        node_id="7"
        domain="03.vn.aikocute.com"
    
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-03/03.vn.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-03/03.vn-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "8" ]; then
        node_id="8"
        domain="02.sing.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-02/02.sing.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-02/02.sing-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "9" ]; then
        node_id="9"
        domain="04.vn.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-04/04.vn.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/VN-04/04.vn-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "10" ]; then
        node_id="10"
        domain="none"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-01/01.sing.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/SG-01/01.sing-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
        elif [ "$choose_node" == "11" ]; then
        node_id="11"
        domain="garena.aikocute.com"

        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/Garena-VN/garena-vn.pem -O /root/cert/server.pem
        wget https://raw.githubusercontent.com/AikoCute/aiko-pem/aiko/Pem/Garena-VN/garena-vn-privkey.pem -O /root/cert/privkey.pem
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${domain}/g" /etc/XrayR/config.yml
    
    else
    
    read -p "Vui lòng nhập node ID :" aiko_node_id
    [ -z "${aiko_node_id}" ]
    echo -e "${green}Node ID của bạn đặt là: ${aiko_node_id}${plain}"
    echo -e "-------------------------"

    wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-V2ray.yml -O /etc/XrayR/config.yml
    sed -i "s/NodeID:.*/NodeID: ${aiko_node_id}/g" /etc/XrayR/config.yml
    
    fi
    elif [ "$choose" == "2" ]; then 
        echo -e "-------------------------"
        echo -e "[1] Config Trojan [TLS]"
        echo -e "[2] Config V2Ray"
        echo -e "[3] Config V2Ray+Trojan [TLS]"
        echo -e "Enter - Mặc định - V2ray-AikoCute"
        echo -e "-------------------------"
        read -p "Vui lòng chọn config cấu hình: " nhk_choose
        if [ "$nhk_choose" == "1" ]; then 
    
        echo -e "${green}Đặt số nút Trên Web V2Board-Trojan${plain}"
        echo ""
        read -p "Vui lòng nhập node ID :" nhk_node_id
        [ -z "${nhk_node_id}" ]
        echo "---------------------------"
        echo -e "${green}Node ID của bạn đặt là: ${nhk_node_id}${plain}"
        echo "---------------------------"
        echo ""

    
        echo "Tên Miền của nút Trojan 'testcode.aikocute.com'"
        echo ""
        read -p "Vui lòng Nhập domain :" nhk_domain
        [ -z "${nhk_domain}" ]
        echo "---------------------------"
        echo -e "${green}Tên miền của bạn đặt là: ${nhk_domain}${plain}"
        echo "---------------------------"
    
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/nhk/Config-Trojan.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${nhk_node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${nhk_domain}/g" /etc/XrayR/config.yml
        elif [ "$nhk_choose" == "2" ]; then

    
        echo "---------------------------"
        echo -e "${green}Đặt số nút Trên Web V2Board-V2ray${plain}"
        echo ""
        read -p "Vui lòng nhập node ID :" nhk_node_id
        [ -z "${nhk_node_id}" ]
        echo "---------------------------"
        echo -e "${green}Node ID của bạn đặt là: ${nhk_node_id}${plain}"
        echo "---------------------------"
        echo ""

        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/nhk/Config-V2ray.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${nhk_node_id}/g" /etc/XrayR/config.yml
        elif [ "$nhk_choose" == "3" ]; then
        echo "---------------------------"
        echo -e "${green}Đặt số nút Trên Web V2Board-Trojan+V2ray${plain}"
        echo ""
        read -p "Vui lòng nhập node ID :" nhk_node_id
        [ -z "${nhk_node_id}" ]
        echo "---------------------------"
        echo -e "${green}Node ID của bạn đặt là: ${nhk_node_id}${plain}"
        echo "---------------------------"
        echo ""

    
        echo "Tên Miền của nút Trojan 'testcode.aikocute.com'"
        echo ""
        read -p "Vui lòng Nhập domain :" nhk_domain
        [ -z "${nhk_domain}" ]
        echo "---------------------------"
        echo -e "${green}Tên miền của bạn đặt là: ${nhk_domain}${plain}"
        echo "---------------------------"


    
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/nhk/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${nhk_node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${nhk_domain}/g" /etc/XrayR/config.yml
        else
        echo "---------------------------"
        echo -e "${green}Đặt số nút Trên Web V2Board-Trojan+V2ray${plain}"
        echo ""
        read -p "Vui lòng nhập node ID :" nhk_node_id
        [ -z "${nhk_node_id}" ]
        echo "---------------------------"
        echo -e "${green}Node ID của bạn đặt là: ${nhk_node_id}${plain}"
        echo "---------------------------"
        echo ""

    
        echo "Tên Miền của nút Trojan 'testcode.aikocute.com'"
        echo ""
        read -p "Vui lòng Nhập domain :" nhk_domain
        [ -z "${nhk_domain}" ]
        echo "---------------------------"
        echo -e "${green}Tên miền của bạn đặt là: ${nhk_domain}${plain}"
        echo "---------------------------"


    
        wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/nhk/Config-Trojan%2BVmess.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${nhk_node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${nhk_domain}/g" /etc/XrayR/config.yml
        fi
    nano /etc/XrayR/config.yml

    elif [ "$choose" == "3" ]; then
        echo "Đặt số nút Trên Web V2Board"
        echo ""
        read -p "Vui lòng nhập node ID :" aq_node_id
        [ -z "${aq_node_id}" ]
        echo "---------------------------"
        echo "Node ID của bạn đặt là: ${node_id}"
        echo "---------------------------"
        echo ""

        echo "Tên Miền của nút : 'testcode.aikocute.com'"
        echo ""
        read -p "Vui lòng Nhập domain :" aq_domain
        [ -z "${aq_domain}" ]
        echo "---------------------------"
        echo -e "${green}Tên miền của bạn đặt là: ${aq_domain}${plain}"
        echo "---------------------------"
        echo ""

        # Writing config.yml
        echo "Đang cố gắng ghi tệp cấu hình ..."
        wget https://raw.githubusercontent.com/AQSaikato/key_pem/main/config.yml -O /etc/XrayR/config.yml
        sed -i "s/NodeID:.*/NodeID: ${aq_node_id}/g" /etc/XrayR/config.yml
        sed -i "s/CertDomain:.*/CertDomain: ${aq_domain}/g" /etc/XrayR/config.yml
        echo ""

        nano /etc/XrayR/config.yml
    else
    install_XrayR $1

    fi
    
    echo "------------------------------------------"
    echo -e " $green Bạn Đã chọn là : ${choose} ${plain}"
    echo "------------------------------------------"

    echo -e ""
    echo "------------------------------------------"
    echo "  XrayR By Aiko : Project XrayR by Aiko"
    echo "  Project XrayR - https://github.com/AikoCute/XrayR "
    echo "  XrayR release - https://github.com/AikoCute/XrayR-release"
    echo "  XrayR docs    - https://xrayr.aikocute.com"
    echo -e "  ${green}AikoCute Hột Me${plain} - https://aikocute.com"
    echo "------------------------------------------"
    echo " "
    
}

XrayR uninstall
rm /root/cert/server.pem
rm /root/cert/privkey.pem
mkdir cert
cd cert

echo -e "${green}bắt đầu cài đặt${plain}"

install_base
install_acme
install_XrayR $1

echo -e "Đã lưu cấu hình thành công, đang bắt đầu khởi động ${green} AikoCute XrayR ${last_version}${plain}"

XrayR start
