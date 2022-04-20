#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

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
        bash <(curl -ls https://raw.githubusercontent.com/AikoCute/XrayR-release/data/install.sh)
        show_menu
    elif [ "$installv1" == "2" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
        show_menu
    elif [ "$installv1" == "3" ]; then
        bash <(curl -ls https://raw.githubusercontent.com/AikoCute/XrayR-release/data/install.sh) &&
        bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
        show_menu
    elif [ "$installv1" == "4" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/herotbty/X-ui/master/install.sh)
    else
    install
    show_menu
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
    XrayR start
    show_menu
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
	read -p "Số node ID Trojan :" idtrojan
	echo "---------------"
    read -p "Số node ID Vmess :" idvmess
	echo "---------------"
	read -p "CertDomain của bạn là :" CertDomain
	echo "---------------"

	rm -f /etc/XrayR/config.yml
	if [[ -z $(~/.acme.sh/acme.sh -v 2>/dev/null) ]]; then
		curl https://get.acme.sh | sh -s email=script@github.com
		source ~/.bashrc
		bash ~/.acme.sh/acme.sh --upgrade --auto-upgrade
	fi
         cat <<EOF >/etc/XrayR/config.yml

Log:
  Level: none # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnetionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 10 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://nhkvpn.net"
      ApiKey: "nhkservervpnnhkservervpn"
      NodeID: $idtrojan
      NodeType: Trojan # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 2 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # ./rulelist Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      DisableSniffing: true # Disable domain sniffing 
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/fallback/ for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: dns # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$CertDomain" # Domain to cert
        CertFile: ./cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: ./cert/node1.test.com.key
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: nhkservervpn@gmail.com
          CLOUDFLARE_API_KEY: 20ddd8957fa907c2c3ac6f49497fb05ab40e7
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://nhkvpn.net"
      ApiKey: "nhkservervpnnhkservervpn"
      NodeID: $idvmess
      NodeType: V2ray # Node type: V2ray, Trojan, Shadowsocks, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 2 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # ./rulelist Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      DisableUploadTraffic: false # Disable Upload Traffic to the panel
      DisableGetRule: false # Disable Get Rule from the panel
      DisableIVCheck: false # Disable the anti-reply protection for Shadowsocks
      DisableSniffing: true # Disable domain sniffing 
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback, check https://xtls.github.io/config/fallback/ for details.
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: none # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "$CertDomain" # Domain to cert
        CertFile: ./cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: ./cert/node1.test.com.key
        Provider: cloudflare # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          CLOUDFLARE_EMAIL: nhkservervpn@gmail.com
          CLOUDFLARE_API_KEY: 20ddd8957fa907c2c3ac6f49497fb05ab40e7
EOF


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
    XrayR start
    show_menu
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
    XrayR start
    show_menu
}

config_soga_aiko(){
  read -p "Node ID :" id_aiko_soga
	echo "---------------"
	read -p "Ip or Domain :" Domain_aiko_soga
	echo "---------------"

	rm -f /etc/soga/soga.conf
	if [[ -z $(~/.acme.sh/acme.sh -v 2>/dev/null) ]]; then
		curl https://get.acme.sh | sh -s email=script@github.com
		source ~/.bashrc
		bash ~/.acme.sh/acme.sh --upgrade --auto-upgrade
	fi
         cat <<EOF >/etc/soga/soga.conf
#config Aiko
type=v2board
server_type=v2ray
node_id=$id_aiko_soga
soga_key=50FuF2DfleD1qDBQfAeH7aFK6g51JBMB

api=webapi

webapi_url=https://aikocute.com
webapi_key=adminadminadminadminadmin

db_host=db.domain.com
db_port=3306
db_name=
db_user=root
db_password=

cert_file=
key_file=

cert_mode=http
cert_domain=$Domain_aiko_soga
cert_key_length=ec-256
dns_provider=dns_cf

default_dns=8.8.8.8,1.1.1.1
dns_cache_time=10
dns_strategy=ipv4_first

v2ray_reduce_memory=true
vless=
vless_flow=

proxy_protocol=false

redis_enable=false
redis_addr=
redis_password=
redis_db=0
conn_limit_expiry=60

user_conn_limit=3
user_speed_limit=0
node_speed_limit=0
check_interval=100
force_close_ssl=true
forbidden_bit_torrent=true
log_level=info

EOF
soga start
}

config() {
    echo -e "-------------------------"
    echo -e "[1] Aiko : aikocute.com"
    echo -e "[2] nhkvpn : nhkvpn.net"
    echo -e "[3] aqvpn : aqvpn.me (AQVPN)"
    echo -e "[4] Show config"
    echo -e "-------------------------"
    read -p "Vui lòng chọn Web lên sever: " choose_config
    echo -e "${green}Bạn đã chọn Web : ${choose}${plain}"

    if [ "$choose_config" == "1" ]; then 
        echo -e "[1] config XrayR"
        echo -e "[2] config Soga"
        read -p "Vui lòng chọn cấu hình: " choose_config_aiko

        if [ "$choose_config_aiko" == "1" ]; then
            config_xrayr_aiko
        elif [ "$choose_config_aiko" == "2" ]; then
            config_soga_aiko
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
            nano /etc/XrayR/config.yml
        elif [ "$choose_config_v1" == "2" ]; then 
            nano /etc/soga/soga.conf
        else
            echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-2]${plain}"
            config
        fi
    else
        echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-4]${plain}"
        config
    fi
}

config_xrayr(){
  nano etc/XrayR/config.yml
}

config_soga(){
  nano etc/soga/soga.conf
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

show_menu