#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi: ${plain} Bắt đầu lại với quyền root！\n" && exit 1

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
    echo -e "${red}Phiên bản hệ thống không được phát hiện, vui lòng liên hệ với tác giả tập lệnh!${plain}\n" && exit 1
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
        echo -e "${red}Vui lòng sử dụng CentOS 7 trở lên！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng Ubuntu 16 trở lên！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng Debian 8 trở lên！${plain}\n" && exit 1
    fi
fi

confirm() {
    if [[ $# > 1 ]]; then
        echo && read -p "$1 [Mặc định$2]: " temp
        if [[ x"${temp}" == x"" ]]; then
            temp=$2
        fi
    else
        read -p "$1 [y/n]: " temp
    fi
    if [[ x"${temp}" == x"y" || x"${temp}" == x"Y" ]]; then
        return 0
    else
        return 1
    fi
}

confirm_restart() {
    confirm "Có khởi động lại aiko hay không" "y"
    if [[ $? == 0 ]]; then
        restart
    else
        show_menu
    fi
}

before_show_menu() {
    echo && echo -n -e "${yellow}Nhấn trở lại để trở về menu chính: ${plain}" && read temp
    show_menu
}

install_XrayR_soga() {
    bash -c <(curl -Ls https://github.com/AikoCute/XrayR-release/raw/data/install.sh) @ install
    bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/Aiko-install/master/install.sh)
    if [[ $? == 0 ]]; then
        if [[ $# == 0 ]]; then
            start
        else
            start 0
        fi
    fi
}

update() {
    if [[ $# == 0 ]]; then
        echo && echo -n -e "Nhập phiên bản được chỉ định (phiên bản mới nhất mặc định): " && read version
    else
        version=$2
    fi
#    confirm "Tính năng này sẽ buộc phải cài đặt lại phiên bản mới nhất hiện tại, dữ liệu sẽ không bị mất, bạn có tiếp tục không?" "n"
#    if [[ $? != 0 ]]; then
#        echo -e "${red}Đã hủy bỏ${plain}"
#        if [[ $1 != 0 ]]; then
#            before_show_menu
#        fi
#        return 0
#    fi
    bash <(curl -Ls https://raw.githubusercontent.com/AikoCute/Aiko-release/master/install.sh) $version
    if [[ $? == 0 ]]; then
        echo -e "${green}Bản cập nhật hoàn tất và aiko đã được tự động khởi động lại, sử dụng aiko log để xem nhật ký chạy${plain}"
        exit
    fi

    if [[ $# == 0 ]]; then
        before_show_menub
    fi
}

config() {
    echo "aiko tự động cố gắng khởi động lại sau khi sửa đổi cấu hình"
    nano /etc/aiko/config.yml
    sleep 2
    check_status
    case $? in
        0)
            echo -e "Trạng thái aiko: ${green}Đang chạy${plain}"
            ;;
        1)
            echo -e "Phát hiện bạn không khởi động aiko hoặc aiko tự động khởi động lại thất bại, xem nhật ký？[Y/n]" && echo
            read -e -p "(Mặc định: y):" yn
            [[ -z ${yn} ]] && yn="y"
            if [[ ${yn} == [Yy] ]]; then
               show_log
            fi
            ;;
        2)
            echo -e "Trạng thái aiko: ${red}Không được cài đặt${plain}"
    esac
}

uninstall() {
    confirm "Bạn có chắc bạn muốn gỡ cài đặt aiko không?" "n"
    if [[ $? != 0 ]]; then
        if [[ $# == 0 ]]; then
            show_menu
        fi
        return 0
    fi
    systemctl stop aiko
    systemctl disable aiko
    rm /etc/systemd/system/aiko.service -f
    systemctl daemon-reload
    systemctl reset-failed
    rm /etc/aiko/ -rf
    rm /usr/local/aiko/ -rf

    echo ""
    echo -e "Gỡ cài đặt thành công và nếu bạn muốn xóa tập lệnh này, hãy chạy sau khi thoát khỏi tập lệnh ${green}rm /usr/bin/aiko -f${plain} Để xóa"
    echo ""

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

start() {
    check_status
    if [[ $? == 0 ]]; then
        echo ""
        echo -e "${green}aiko đang chạy và không cần khởi động lại, vui lòng chọn Khởi động lại nếu bạn muốn khởi động lại${plain}"
    else
        systemctl start aiko
        sleep 2
        check_status
        if [[ $? == 0 ]]; then
            echo -e "${green}aiko khởi động thành công, sử dụng aiko log để xem nhật ký chạy${plain}"
        else
            echo -e "${red}aiko có thể khởi động không thành công, vui lòng xem thông tin nhật ký sau bằng cách sử dụng aiko log${plain}"
        fi
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

stop() {
    systemctl stop aiko
    sleep 2
    check_status
    if [[ $? == 1 ]]; then
        echo -e "${green}aiko dừng lại thành công${plain}"
    else
        echo -e "${red}aiko dừng thất bại, có thể là do thời gian dừng vượt quá hai giây, vui lòng kiểm tra thông tin nhật ký sau${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

restart() {
    systemctl restart aiko
    sleep 2
    check_status
    if [[ $? == 0 ]]; then
        echo -e "${green}Khởi động lại aiko thành công, sử dụng aiko log để xem nhật ký chạy${plain}"
    else
        echo -e "${red}aiko có thể khởi động không thành công, vui lòng xem thông tin nhật ký sau bằng cách sử dụng aiko log${plain}"
    fi
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

status() {
    systemctl status aiko --no-pager -l
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

enable() {
    systemctl enable aiko
    if [[ $? == 0 ]]; then
        echo -e "${green}Thiết lập aiko bật nguồn thành công${plain}"
    else
        echo -e "${red}Thiết lập aiko tự khởi động thất bại${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

disable() {
    systemctl disable aiko
    if [[ $? == 0 ]]; then
        echo -e "${green}aiko hủy bỏ khởi động thành công${plain}"
    else
        echo -e "${red}aiko hủy bỏ khởi động tự khởi động thất bại${plain}"
    fi

    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

show_log() {
    journalctl -u aiko.service -e --no-pager -f
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

install_bbr() {
    bash <(curl -L -s https://raw.githubusercontent.com/aikoCute/BBR/aiko/tcp.sh)
    #if [[ $? == 0 ]]; then
    #    echo ""
    #    echo -e "${green}Cài đặt bbr thành công, khởi động lại máy chủ${plain}"
    #else
    #    echo ""
    #    echo -e "${red}Tải xuống tập lệnh cài đặt bbr không thành công, vui lòng kiểm tra xem máy có thể kết nối Github hay không${plain}"
    #fi

    #before_show_menu
}

update_shell() {
    wget -O /usr/bin/aiko -N --no-check-certificate https://raw.githubusercontent.com/AikoCute/Aiko-release/data/aiko.sh
    if [[ $? != 0 ]]; then
        echo ""
        echo -e "${red}Tập lệnh tải xuống không thành công, vui lòng kiểm tra xem máy có thể kết nối Github hay không${plain}"
        before_show_menu
    else
        chmod +x /usr/bin/aiko
        echo -e "${green}Nâng cấp kịch bản thành công, chạy lại tập lệnh${plain}" && exit 0
    fi
}

# 0: running, 1: not running, 2: not installed
check_status() {
    if [[ ! -f /etc/systemd/system/aiko.service ]]; then
        return 2
    fi
    temp=$(systemctl status aiko | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
    if [[ x"${temp}" == x"running" ]]; then
        return 0
    else
        return 1
    fi
}

check_enabled() {
    temp=$(systemctl is-enabled aiko)
    if [[ x"${temp}" == x"enabled" ]]; then
        return 0
    else
        return 1;
    fi
}

check_uninstall() {
    check_status
    if [[ $? != 2 ]]; then
        echo ""
        echo -e "${red}aiko đã được cài đặt và không lặp lại cài đặt${plain}"
        if [[ $# == 0 ]]; then
            before_show_menu
        fi
        return 1
    else
        return 0
    fi
}

check_install() {
    check_status
    if [[ $? == 2 ]]; then
        echo ""
        echo -e "${red}Vui lòng cài đặt aiko trước${plain}"
        if [[ $# == 0 ]]; then
            before_show_menu
        fi
        return 1
    else
        return 0
    fi
}

show_status() {
    check_status
    case $? in
        0)
            echo -e "Trạng thái aiko: ${green}Đang chạy${plain}"
            show_enable_status
            ;;
        1)
            echo -e "Trạng thái aiko: ${yellow}Không chạy${plain}"
            show_enable_status
            ;;
        2)
            echo -e "Trạng thái aiko: ${red}Không được cài đặt${plain}"
    esac
}

speedtest() {
    wget -qO- --no-check-certificate https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash
}



show_enable_status() {
    check_enabled
    if [[ $? == 0 ]]; then
        echo -e "Có bật nguồn hay không: ${green}Có${plain}"
    else
        echo -e "Có bật nguồn hay không: ${red}Không${plain}"
    fi
}

show_aiko_version() {
    echo -n "Phiên bản aiko："
    /usr/local/aiko/aiko -version
    echo ""
    if [[ $# == 0 ]]; then
        before_show_menu
    fi
}

show_usage() {
     echo -n "AikoCute Hotme"
}

show_menu() {
    echo -e "
  ${green}aiko Kịch bản quản lý back-end，${plain}${red}Không dùng cho docker${plain}
--- https://github.com/aiko-project/aiko ---
  ${green}0.${plain} Sửa đổi cấu hình
————————————————
  ${green}1.${plain} Cài đặt install_XrayR_soga
  ${green}2.${plain} Cập nhật aiko
  ${green}3.${plain} Gỡ cài đặt aiko
————————————————
  ${green}4.${plain} Khởi động aiko
  ${green}5.${plain} Dừng aiko
  ${green}6.${plain} Khởi động lại aiko
  ${green}7.${plain} Xem trạng thái aiko
  ${green}8.${plain} Xem nhật ký aiko
————————————————
  ${green}9.${plain} Thiết lập aiko để bật nguồn tự khởi động
  ${green}10.${plain} Hủy bỏ aiko khởi động tự khởi động
————————————————
  ${green}11.${plain} Cài đặt một cú nhấp chuột bbr (mới nhất)
  ${green}12.${plain} Xem phiên bản aiko 
  ${green}13.${plain} Nâng cấp kịch bản bảo trì
  ${green}14.${plain} Speedtest VPS
 "
 #Các bản cập nhật tiếp theo có thể được thêm vào chuỗi trên
    show_status
    echo && read -p "Vui lòng nhập lựa chọn [0-13]: " num

    case "${num}" in
        0) config
        ;;
        1) check_uninstall && install_XrayR_soga
        ;;
        2) check_install && update
        ;;
        3) check_install && uninstall
        ;;
        4) check_install && start
        ;;
        5) check_install && stop
        ;;
        6) check_install && restart
        ;;
        7) check_install && status
        ;;
        8) check_install && show_log
        ;;
        9) check_install && enable
        ;;
        10) check_install && disable
        ;;
        11) install_bbr
        ;;
        12) check_install && show_aiko_version
        ;;
        13) update_shell
        ;;
        14) speedtest
        ;;
        *) echo -e "${red}Vui lòng nhập số chính xác [0-12]${plain}"
        ;;
    esac
}


if [[ $# > 0 ]]; then
    case $1 in
        "start") check_install 0 && start 0
        ;;
        "stop") check_install 0 && stop 0
        ;;
        "restart") check_install 0 && restart 0
        ;;
        "status") check_install 0 && status 0
        ;;
        "enable") check_install 0 && enable 0
        ;;
        "disable") check_install 0 && disable 0
        ;;
        "log") check_install 0 && show_log 0
        ;;
        "update") check_install 0 && update 0 $2
        ;;
        "config") config $*
        ;;
        "install") check_uninstall 0 && install 0
        ;;
        "uninstall") check_install 0 && uninstall 0
        ;;
        "version") check_install 0 && show_aiko_version 0
        ;;
        "update_shell") update_shell
        ;;
        "speedtest") speedtest
        ;;
        "bbr") install_bbr
        ;;
        *) show_usage
    esac
else
    show_menu
fi