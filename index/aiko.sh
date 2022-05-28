#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi: ${plain} Bắt đầu lại với quyền root！\n" && exit 1

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

install() {
    echo -e "-------------------------"
    echo -e "0. Thoát Menu"
    echo -e "1. Cài đặt ${green}XrayR${plain}"
    echo -e "2. Cài đặt ${green}Soga${plain}"
    echo -e "3. Cài đặt ${green}Soga-XrayR${plain}"
    echo -e "4. Cài đặt ${green}X-ui${plain}"
    read -p "Vui lòng chọn config cấu hình: " installv1

    if ["${installv1}" == "0" ]; then
        exit 0
    elif [ "$installv1" == "1" ]; then
        bash <(curl -ls https://raw.githubusercontent.com/AikoXrayR-Project/AikoXrayR-install/data/install-beta.sh)
        show_menu
    elif [ "$installv1" == "2" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/Aiko-Soga/aiko/install.sh)
        show_menu
    elif [ "$installv1" == "3" ]; then
        bash <(curl -ls https://raw.githubusercontent.com/AikoXrayR-Project/AikoXrayR-install/data/install-beta.sh) &&
            bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/Aiko-Soga/aiko/install.sh)
        show_menu
    elif [ "$installv1" == "4" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/herotbty/X-ui/master/install.sh)
    else
        install
        show_menu
    fi
}

check_status_xrayr() {
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

show_log_xrayr() {
    journalctl -u XrayR.service -e --no-pager -f
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

# 0: running, 1: not running, 2: not installed
check_status_soga() {
    if [[ ! -f /etc/systemd/system/soga.service ]]; then
        return 2
    fi
    temp=$(systemctl status soga | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

show_log_soga() {
    journalctl -u soga.service -e --no-pager
    if [[ $# == 0 ]]; then
        show_menu
    fi
}

config_aikovpn_xrayr() {
    echo -e "[0] Thoát"
    echo -e "[1] Config Trojan"
    echo -e "[2] Config V2ray"
    echo -e "[3] Config V2ray + Trojan"
    echo -e "[4] Config Nhập tay"
    read -p "Vui lòng chọn config cấu hình: " config_aikovpn_xrayr_v1
    if [ "$config_aikovpn_xrayr_v1" == "0" ]; then
        show_menu
    elif [ "$config_aikovpn_xrayr_v1" == "1" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/xrayr/config_trojan.sh)
        show_menu
    elif [ "$config_aikovpn_xrayr_v1" == "2" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/xrayr/config_v2ray.sh)
        show_menu
    elif [ "$config_aikovpn_xrayr_v1" == "3" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/xrayr/config_trojan-v2ray.sh)
        show_menu
    elif [ "$config_aikovpn_xrayr_v1" == "4" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/xrayr/config_aiko.sh)
        show_menu
    else
        config_aikovpn_xrayr
    fi
    show_menu
}

config_nhkvpn_xrayr() {
    bash <(curl -ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/xrayr_nhk/config_nhk.sh)
    XrayR start
    show_menu
}

config_aqvpn_xrayr() {
    bash <(curl -ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/aqvpn/config_aqvpn_xrayr.sh)
    XrayR start
    show_menu
}

config_soga_aiko() {
    bash <(curl -ls https://raw.githubusercontent.com/AikoCute/FileAiko/master/soga/config_soga_aiko.sh)
    show_menu
}

setting_config() {
    echo -e "-------------------------"
    echo -e "[1] Aiko : aikocute.com"
    echo -e "[2] nhkvpn : nhkvpn.net"
    echo -e "[3] aqvpn : aqvpn.me (AQVPN)"
    echo -e "[4] Show config"
    echo -e "-------------------------"
    read -p "Vui lòng chọn Web lên sever: " choose_config
    echo -e "${green}Bạn đã chọn Web : ${choose_config}${plain}"

    if [ "$choose_config" == "1" ]; then
        echo -e "[1] config XrayR"
        echo -e "[2] config Soga"
        echo -e "[3] config soga:80 + XrayR:443"
        read -p "Vui lòng chọn cấu hình: " choose_config_aiko

        if [ "$choose_config_aiko" == "1" ]; then
            config_aikovpn_xrayr
        elif [ "$choose_config_aiko" == "2" ]; then
            config_soga_aiko
        elif [ "$choose_config_aiko" == "3" ]; then
            config_soga_aiko
            config_aikovpn_xrayr
        else
            echo -e "${red}Bạn đã chọn sai cấu hình${plain}"
            config
        fi
    elif [ "$choose_config" == "2" ]; then
        config_nhkvpn_xrayr
    elif [ "$choose_config" == "3" ]; then
        config_aqvpn_xrayr
    elif [ "$choose_config" == "4" ]; then
        echo -e "-------------------------"
        echo -e "[1] config XrayR "
        echo -e "[2] config soga "
        read -p "Vui lòng chọn config phù hợp: " choose_config_v1

        if [ "$choose_config_v1" == "1" ]; then
            config_xrayr
        elif [ "$choose_config_v1" == "2" ]; then
            config_soga
        else
            echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-2]${plain}"
            config
        fi
    else
        echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-4]${plain}"
        config
    fi
    show_menu
}

status() {
    echo "[1] XrayR"
    echo "[2] Soga"
    read -p "Vui lòng chọn cấu hình: " choose_status

    if [ "$choose_status" == "1" ]; then
        echo -e "[1] Khởi động XrayR"
        echo -e "[2] Khởi động lại XrayR"
        echo -e "[3] XrayR log"
        echo -e "[4] Gỡ cài đặt XrayR"
        read -p "Vui lòng chọn cấu hình: " choose_status_v1

        if [ "$choose_status_v1" == "1" ]; then
            XrayR start
        elif [ "$choose_status_v1" == "2" ]; then
            XrayR restart
        elif [ "$choose_status_v1" == "3" ]; then
            XrayR log
        elif [ "$choose_status_v1" == "4" ]; then
            XrayR uninstall
        else
            echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-4]${plain}"
            status
        fi

    elif [ "$choose_status" == "2" ]; then
        echo -e "[1] Khởi động Soga"
        echo -e "[2] Khởi động lại Soga"
        echo -e "[3] Soga log"
        echo -e "[4] Gỡ cài đặt Soga"
        read -p "Vui lòng chọn cấu hình: " choose_status_v2

        if [ "$choose_status_v2" == "1" ]; then
            soga start
        elif [ "$choose_status_v2" == "2" ]; then
            soga restart
        elif [ "$choose_status_v2" == "3" ]; then
            soga log
        elif [ "$choose_status_v2" == "4" ]; then
            soga uninstall
        else
            echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-4]${plain}"
            status
        fi
    else
        echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-2]${plain}"
        status
    fi
}

config_xrayr() {
    echo "XrayR sẽ tự động khởi động lại sau khi sửa đổi cấu hình"
    nano /etc/XrayR/config.yml
    sleep 2
    check_status_xrayr
    case $? in
    0)
        echo -e "Trạng thái XrayR: ${green}đã được chạy${plain}"
        ;;
    1)
        echo -e "Nó được phát hiện rằng bạn không khởi động XrayR hoặc XrayR không tự khởi động lại, hãy kiểm tra nhật ký？[Y/n]" && echo
        read -e -p "(yes or no):" yn
        [[ -z ${yn} ]] && yn="y"
        if [[ ${yn} == [Yy] ]]; then
            show_log_xrayr
        fi
        ;;
    2)
        echo -e "Trạng thái XrayR: ${red}Chưa cài đặt${plain}"
        ;;
    esac
}

config_soga() {
    echo "Soga sẽ tự khởi động lại sau khi sửa đổi cấu hình"
    nano /etc/soga/soga.conf
    sleep 2
    check_status_soga
    case $? in
    0)
        echo -e "Trạng thái soga: ${green}đã được chạy${plain}"
        ;;
    1)
        echo -e "Nó được phát hiện rằng bạn không khởi động soga hoặc soga không tự khởi động lại, hãy kiểm tra nhật ký？[Y/n]" && echo
        read -e -p "(yes or no):" yn
        [[ -z ${yn} ]] && yn="y"
        if [[ ${yn} == [Yy] ]]; then
            show_log_soga
        fi
        ;;
    2)
        echo -e "Trạng thái XrayR: ${red}Chưa cài đặt${plain}"
        ;;
    esac
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
  ${green}3.${plain} Trạng thái Backend
————————————————
  ${green}4.${plain} docker_run < aikocute >
  ${green}5.${plain} Cài đặt BBR
  ${green}6.${plain} Speedtest VPS
 "
    #Các bản cập nhật tiếp theo có thể được thêm vào chuỗi trên
    echo && read -p "Vui lòng nhập lựa chọn [0-7]: " num

    case "${num}" in
    0)
        exit 0
        ;;
    1)
        install
        ;;
    2)
        setting_config
        ;;
    3)
        status
        ;;
    4)
        unlock_port_menu
        ;;
    5)
        install_bbr
        ;;
    6)
        speedtest
        ;;
    *)
        echo -e "${red}Vui lòng nhập số chính xác [0-6]${plain}"
        ;;
    esac
}

clear
show_menu
