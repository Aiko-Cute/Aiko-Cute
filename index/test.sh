#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi: ${plain} Bắt đầu lại với quyền root！\n" && exit 1

install() {
    echo -e "-------------------------"
    echo -e "1. Cài đặt ${green}XrayR${plain}"
    echo -e "2. Cài đặt ${green}Soga${plain}"
    echo -e "3. Cài đặt ${green}Soga-XrayR${plain}"
    echo -e "4. Cài đặt ${green}X-ui${plain}"
    read -p "Vui lòng chọn config cấu hình: " installv1

    if [ "$installv1" == "1" ]; then 
        bash <(curl -ls https://github.com/AikoCute/XrayR-release/raw/data/install.sh)

    elif [ "$installv1" == "2" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
    
    elif [ "$installv1" == "3" ]; then
        bash <(curl -ls https://github.com/AikoCute/XrayR-release/blob/data/install.sh)
        bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)

    else
    install

    fi
}

config_aikovpn_xrayr() {
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
    
    else
    
    read -p "Vui lòng nhập node ID :" aiko_node_id
    [ -z "${aiko_node_id}" ]
    echo -e "${green}Node ID của bạn đặt là: ${aiko_node_id}${plain}"
    echo -e "-------------------------"

    wget https://raw.githubusercontent.com/AikoCute/Aiko-Config/aiko/Config-V2ray.yml -O /etc/XrayR/config.yml
    sed -i "s/NodeID:.*/NodeID: ${aiko_node_id}/g" /etc/XrayR/config.yml
    
    fi
}

config_nhkvpn_xrayr() {
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
 
}

config_aqvpn_xrayr() {
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
    wget https://raw.githubusercontent.com/AQSaikato/key_pem/main/fullchain.pem -O /root/cert/server.pem
    wget https://raw.githubusercontent.com/AQSaikato/key_pem/main/privkey.pem -O /root/cert/privkey.pem
    wget https://raw.githubusercontent.com/AQSaikato/xrayr/main/config.yml -O /etc/XrayR/config.yml
    sed -i "s/NodeID:.*/NodeID: ${aq_node_id}/g" /etc/XrayR/config.yml
    sed -i "s/CertDomain:.*/CertDomain: ${aq_domain}/g" /etc/XrayR/config.yml
    echo ""

    nano /etc/XrayR/config.yml
}

config() {
    echo -e "-------------------------"
    echo -e "[1] Aiko : aikocute.com"
    echo -e "[2] nhkvpn : nhkvpn.net"
    echo -e "[3] aqvpn : aqvpn.me - Gạch Tên :D"
    echo -e "-------------------------"
    read -p "Vui lòng chọn Web lên sever: " choose_config
    echo -e "${green}Bạn đã chọn Web : ${choose}${plain}"

    if [ "$choose_config" == "1" ]; then 
        config_aikovpn_xrayr
    elif [ "$choose_config" == "2" ]; then 
        config_nhkvpn_xrayr
    elif [ "$choose_config" == "3" ]; then 
        config_aqvpn_xrayr
    else
        echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-3]${plain}"
        config
    fi
}

xrayr_old_config(){
    bash <(curl -ls https://raw.githubusercontent.com/Aiko-Cute/Aiko-Cute/aiko/aiko.sh)
}

install_bbr() {
    bash <(curl -L -s https://raw.githubusercontent.com/aikoCute/BBR/aiko/tcp.sh)
}

speedtest() {
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash
}


show_menu() {
    echo -e "
  ${green}Menu support Backend của Aiko${plain}
        --- https://github.com/AikoCute ---
  ${green}0.${plain} Thoát menu
————————————————
  ${green}1.${plain} Cài đặt Backend
  ${green}2.${plain} Cập nhật config
  ${green}3.${plain} XrayR 1 Lần chạy (Aiko-NHK-AQVPN)
————————————————
  ${green}4.${plain} Cài đặt BBR
  ${green}5.${plain} Speedtest VPS
 "
 #Các bản cập nhật tiếp theo có thể được thêm vào chuỗi trên
    show_status
    echo && read -p "Vui lòng nhập lựa chọn [0-4]: " num

    case "${num}" in
        0) exit 0
        ;;
        1) install
        ;;
        2) config
        ;;
        3) xrayr_old_config
        ;;
        4) install_bbr
        ;;
        5) speedtest
        ;;
        *) echo -e "${red}Vui lòng nhập số chính xác [0-4]${plain}"
        ;;
    esac
}

else
    show_menu
fi