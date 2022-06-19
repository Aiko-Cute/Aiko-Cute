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
    bash <(curl -ls https://raw.githubusercontent.com/AikoXrayR-Project/AikoXrayR-install/data/install-beta.sh)
    show_menu
}

update(){
    bash <(curl -ls https://raw.githubusercontent.com/AikoXrayR-Project/AikoXrayR-install/data/install-beta.sh)
    show_menu
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
}

install_certficate(){
    cat <<EOF >/etc/XrayR/server.pem
    -----BEGIN CERTIFICATE-----
MIIEpDCCA4ygAwIBAgIUflub/zFZbRyEdJ6CJbSC7ZfoKeMwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIyMDQyMDE2MTUwMFoXDTM3MDQxNjE2MTUwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkXeNMQZkw8KPmI+AovS46xYrHswQ7YjqcLeJ
/B/aznLInUS+F2vw/8qIm2WW8QG1tJCSH9+nvrdD8nAsQO5wwCLmKst111LEwNNh
Sm9AqyxSnIQXKPWIWl6b9PunpvxauGL31+gw0IezLY4nsSsLeoE8W98Z+52Y6WUD
JpC21HDmmfjq3K0dt1536NClohHt4ice5zDGkyl2L6z8xeHzT54PZiva+W6eqYUx
5TuW4PKaSHDBVL7clfNiGDAeFKL77BosvYKV2FGj3/Ekvp8AUozu831YhFMpCdHU
8VpWtHw/1qiO9KI8rb3h1umWYWKAZanw+YW/9ZXsTHu2GJG/nQIDAQABo4IBJjCC
ASIwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBSDInnPpA02YcC3JlEQs+qrywHu3jAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAnBgNVHREEIDAegg4qLmFpa29jdXRlLmNvbYIMYWlrb2N1dGUuY29tMDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2xvdWRmbGFyZS5jb20vb3JpZ2luX2Nh
LmNybDANBgkqhkiG9w0BAQsFAAOCAQEAlzPonIMfzfHf94Dv05kORGKCcrjuTR9D
AQpNT4dJ3AGAy5oGVFoCj+ak6X5kope4PC8uYlAr45QZg6qEiZgDFAkyfWxr1hyA
4AjD6LqFyKlv3Y2fnonZcbXOY3CCEoxqD+Ca3O65Q8sLyIsC8LqX8mhnTWt3Y1Ww
fs0s/cz3VNE2iwltsjRQx3IyB/CiPV6dd1Xa24WRglzkGdo0HDBXby3oitgybtFL
YYUlHZ8NYqYVTKdo+BWPR5+U7CQ6yfd+T0xyOo4IjggW2J3bv8/u6uHZuslvpeKx
ZKuxYNAN/bd+6qdxwZB6W+SoqELy2QFN8b9X+gaJDCFDdCkNT4qVlA==
-----END CERTIFICATE-----
EOF
    cat <<EOF >/etc/XrayR/privkey.pem
    -----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCRd40xBmTDwo+Y
j4Ci9LjrFisezBDtiOpwt4n8H9rOcsidRL4Xa/D/yoibZZbxAbW0kJIf36e+t0Py
cCxA7nDAIuYqy3XXUsTA02FKb0CrLFKchBco9YhaXpv0+6em/Fq4YvfX6DDQh7Mt
jiexKwt6gTxb3xn7nZjpZQMmkLbUcOaZ+OrcrR23Xnfo0KWiEe3iJx7nMMaTKXYv
rPzF4fNPng9mK9r5bp6phTHlO5bg8ppIcMFUvtyV82IYMB4UovvsGiy9gpXYUaPf
8SS+nwBSjO7zfViEUykJ0dTxWla0fD/WqI70ojytveHW6ZZhYoBlqfD5hb/1lexM
e7YYkb+dAgMBAAECggEACH4Oog/cIyDBMzqM7e1ml73Fyx1GD3AJxz1FkuwTKlTB
m2aUEZgf3kA5hQT6Xm5VMbfPQ4k/6N6qkaC93Ke4HvnBeBX7LXArzSLzNMLDQtHh
QIKvqOHbCKng5f2W2tvq3oWcnY3imfaTS48y0U7+YQ9QTW2g4lgEZftAEHsaNxyc
SS5BkZKCvHzT/1YPIqfb+w6ErKZb8m8x0K958ZeMzIe9t9W9GyH+wVN8gIbY3myl
JSEcHgesBykbUoaL+VbRbUN8epnT6seQbWZwgxps1pqi7VNpuRElXrF2bTy8EkA9
EuYQz47KNJhz6Kjv1gGu9yfi1WMtl6vjNqQhk3ESmwKBgQDG+XLJ4OuEO/k67A+l
ja05fNzPhKPSDMXDPNVHU4RmL4JpT95cjtuKBoAEXMCjeRqadsRX19e5Y3Ut+0Su
tg6RW0I7SdIy01EHow8LSFQOHrWea/tbZdF0SgaB2dEDcN/T2KwrdEFLi7OQu5uP
Oo521ZtydJxaAvJQD1ba5l48GwKBgQC7KFGGs7CGzNHhhBkkFh+ymXmQ68ZRlfcP
S9w//goFsNNTuKzt/JjyjINRe1BiYqSbtr1gTqO8nMxUuPEi/sn89Ac0BCA0meVl
1o8b6m63xQHlQJNPa0Ug7bIZ7ax/ufGCQkzyp8Wh6Q+o45RiJvX2V4EWNozuS5Y9
rMTMUD4+pwKBgFn97m3iHYM0QNfmdnkxJ9ytXY0594IEJtnTxL66xlIVQM1ywyZn
smGt6O6QKMyG9IJSHyF/zODbW99NGtZOHy6c8Mqx67DzJF3o4OAAeYvdVdVuD0Ra
O6514JWQN1lwDrvY7p3Eudd6Ot/GCmhwWojiuai9lw2a8Y9GMMlWkd5rAoGAOZSe
+IViIybyz6I3pe2UlPs49ohDfKhZ2X/qZFnBNZ0Ad3qS4alcWQs3/6KjyZE1uZ6Q
RwgKwiWvi8VWkwC2njdp2+wFCInslNddMiZ/J9TZz3F9oOqM2yOmLun7r1RC5GOH
jwRk/npY0goqhcQc2kxzr6Ta2RmyQIleBsoNTHMCgYAjtlo2Fnevoblk8CSo/IhR
h/xoLFia0CKllgbl4eSY7XhPQuaQCE65pm2WHcq7P3FBwvkWu5QpfG8czlGNbnVB
2056NjsRByIC5IzXafWZK4qBtxHh3NY9oENtScF5Dgw1SDNaHz7VeEgfAZVMGwTm
QxjKgNZCmTBbCcq1rZrYfg==
-----END PRIVATE KEY-----
EOF
}


setting_config() {
    echo -e "-------------------------"
    echo -e "[1] Setup Config File"
    echo -e "[2] Cài đặt chứng chỉ TLS"
    echo -e "[3] Show config"
    echo -e "-------------------------"
    read -p "Vui lòng chọn Web lên sever: " choose_config
    echo -e "${green}Bạn đã chọn Web : ${choose_config} ${plain}"

    if [ "$choose_config" == "1" ]; then
        config_aikovpn_xrayr
        show_menu
    elif [ "$choose_config" == "2" ]; then
        install_certficate
        show_menu
    elif [ "$choose_config" == "3" ]; then
        config_xrayr
    else
        echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-3]${plain}"
        setting_config
    fi
    show_menu
}

status() {
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
        show_menu
}   

config_xrayr() {
    echo "XrayR sẽ tự động khởi động lại sau khi sửa đổi cấu hình"
    nano /etc/XrayR/aiko.yml
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
  ${green}1.${plain} Cài đặt XrayR
  ${green}2.${plain} Cập nhật config
  ${green}3.${plain} Trạng thái Backend
————————————————
  ${green}4.${plain} docker_run < aikocute >
  ${green}5.${plain} Cài đặt BBR
  ${green}6.${plain} Speedtest VPS
  ${green}7.${plain} Update XrayR
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
    7) 
        update
        ;;
    *)
        echo -e "${red}Vui lòng nhập số chính xác [0-6]${plain}"
        ;;
    esac
}

clear
show_menu
