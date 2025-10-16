{ ... }:
let
  name = "feature/sys/network/mihomo";
in
{
  flake.modules = {
    nixos.${name} =
      { pkgs, ... }:
      {
        # add mihomo to the system packages
        environment.systemPackages = with pkgs; [
          mihomo
        ];
      };
    homeManager.${name} =
      { config, pkgs, ... }:
      let
        mihomoDir = "${config.home.homeDirectory}/.config/mihomo";

        # 代理脚本 - 开启全局代理
        # 使用方法: proxy-on
        proxyOn = pkgs.writeShellScriptBin "proxy-on" ''
          export http_proxy="http://127.0.0.1:7890"
          export https_proxy="http://127.0.0.1:7890"
          export all_proxy="socks5://127.0.0.1:7891"
          export no_proxy="localhost,127.0.0.1,::1"
          echo "✓ 全局代理已开启"
          echo "  HTTP/HTTPS: 127.0.0.1:7890"
          echo "  SOCKS5: 127.0.0.1:7891"
        '';

        # 代理脚本 - 关闭代理
        # 使用方法: proxy-off
        proxyOff = pkgs.writeShellScriptBin "proxy-off" ''
          unset http_proxy
          unset https_proxy
          unset all_proxy
          unset no_proxy
          echo "✓ 代理已关闭"
        '';

        # 代理脚本 - 为单个命令设置代理
        # 使用方法: px curl https://google.com
        proxyExec = pkgs.writeShellScriptBin "px" ''
          export http_proxy="http://127.0.0.1:7890"
          export https_proxy="http://127.0.0.1:7890"
          export all_proxy="socks5://127.0.0.1:7891"
          export no_proxy="localhost,127.0.0.1,::1"
          exec "$@"
        '';

        # mihomo 配置文件模板
        mihomoConfig = ''
          # Mihomo (Clash Meta) 配置文件
          # 
          # 使用说明:
          # 1. 替换下面的 JUSTMYSOCKS_SUBSCRIPTION_URL 为你的实际订阅地址
          # 2. 运行: mihomo -d ~/.config/mihomo 启动服务
          # 3. 使用 proxy-on 开启全局代理
          # 4. 使用 proxy-off 关闭代理
          # 5. 使用 px <命令> 为单个命令设置代理,如: px curl https://google.com
          # 6. 浏览器设置代理: HTTP 127.0.0.1:7890 或 SOCKS5 127.0.0.1:7891

          mixed-port: 7890
          socks-port: 7891
          allow-lan: false
          bind-address: '*'
          mode: rule
          log-level: info
          ipv6: true

          external-controller: 127.0.0.1:9090
          external-ui: ui
          secret: ""

          dns:
            enable: true
            ipv6: true
            listen: 0.0.0.0:53
            enhanced-mode: fake-ip
            fake-ip-range: 198.18.0.1/16
            fake-ip-filter:
              - '*.lan'
              - 'localhost.ptlogin2.qq.com'
            nameserver:
              - 223.5.5.5
              - 119.29.29.29
            fallback:
              - 8.8.8.8
              - 1.1.1.1
              - tls://dns.google
            fallback-filter:
              geoip: true
              geoip-code: CN
              ipcidr:
                - 240.0.0.0/4

          # 订阅配置
          proxy-providers:
            justmysocks:
              type: http
              # 请替换为你的 JustMySocks 订阅地址
              url: "JUSTMYSOCKS_SUBSCRIPTION_URL"
              interval: 3600
              path: ./providers/justmysocks.yaml
              health-check:
                enable: true
                interval: 600
                url: http://www.gstatic.com/generate_204

          # 代理组配置
          proxy-groups:
            - name: "🚀 节点选择"
              type: select
              use:
                - justmysocks
              proxies:
                - "♻️ 自动选择"
                - "DIRECT"
            
            - name: "♻️ 自动选择"
              type: url-test
              use:
                - justmysocks
              url: 'http://www.gstatic.com/generate_204'
              interval: 300
            
            - name: "🌍 国外网站"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
                - "DIRECT"
            
            - name: "📲 Telegram"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
            
            - name: "🎬 流媒体"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
            
            - name: "🍎 Apple"
              type: select
              proxies:
                - "DIRECT"
                - "🚀 节点选择"
            
            - name: "🎯 全球直连"
              type: select
              proxies:
                - "DIRECT"
                - "🚀 节点选择"
            
            - name: "🐟 漏网之鱼"
              type: select
              proxies:
                - "🚀 节点选择"
                - "DIRECT"

          # 规则配置 - 自动将中国以外的流量通过代理
          rules:
            # Telegram
            - DOMAIN-SUFFIX,t.me,📲 Telegram
            - DOMAIN-SUFFIX,tdesktop.com,📲 Telegram
            - DOMAIN-SUFFIX,telegra.ph,📲 Telegram
            - DOMAIN-SUFFIX,telegram.me,📲 Telegram
            - DOMAIN-SUFFIX,telegram.org,📲 Telegram
            - IP-CIDR,91.108.4.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.8.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.16.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.56.0/22,📲 Telegram,no-resolve
            - IP-CIDR,149.154.160.0/20,📲 Telegram,no-resolve
            
            # 流媒体
            - DOMAIN-SUFFIX,youtube.com,🎬 流媒体
            - DOMAIN-SUFFIX,googlevideo.com,🎬 流媒体
            - DOMAIN-SUFFIX,netflix.com,🎬 流媒体
            - DOMAIN-SUFFIX,nflxvideo.net,🎬 流媒体
            - DOMAIN-SUFFIX,spotify.com,🎬 流媒体
            - DOMAIN-SUFFIX,twitch.tv,🎬 流媒体
            
            # Apple
            - DOMAIN-SUFFIX,apple.com,🍎 Apple
            - DOMAIN-SUFFIX,icloud.com,🍎 Apple
            - DOMAIN-SUFFIX,mzstatic.com,🍎 Apple
            
            # 国内直连
            - DOMAIN-SUFFIX,cn,🎯 全球直连
            - DOMAIN-KEYWORD,-cn,🎯 全球直连
            - GEOIP,CN,🎯 全球直连
            
            # 国外网站
            - DOMAIN-SUFFIX,google.com,🌍 国外网站
            - DOMAIN-SUFFIX,github.com,🌍 国外网站
            - DOMAIN-SUFFIX,githubusercontent.com,🌍 国外网站
            - DOMAIN-SUFFIX,cloudflare.com,🌍 国外网站
            - DOMAIN-SUFFIX,openai.com,🌍 国外网站
            
            # 局域网直连
            - DOMAIN-SUFFIX,local,DIRECT
            - IP-CIDR,192.168.0.0/16,DIRECT
            - IP-CIDR,10.0.0.0/8,DIRECT
            - IP-CIDR,172.16.0.0/12,DIRECT
            - IP-CIDR,127.0.0.0/8,DIRECT
            - IP-CIDR,100.64.0.0/10,DIRECT
            
            # 最终规则
            - MATCH,🐟 漏网之鱼
        '';
      in
      {
        # 配置 sops 密钥
        sops.secrets."justmysocks/subscription_url" = {
          path = "${mihomoDir}/.subscription_url";
        };

        # 安装代理脚本
        home.packages = [
          proxyOn
          proxyOff
          proxyExec
        ];

        # 创建 mihomo 配置目录和文件
        # 使用模板,在激活时替换订阅地址
        home.file."${mihomoDir}/config.yaml.template".text = ''
          # Mihomo (Clash Meta) 配置文件
          # 
          # 使用说明:
          # 1. 订阅地址已通过 sops 加密管理,无需手动配置
          # 2. 运行: mihomo-start 启动服务
          # 3. 使用 proxy-on 开启全局代理
          # 4. 使用 proxy-off 关闭代理
          # 5. 使用 px <命令> 为单个命令设置代理,如: px curl https://google.com
          # 6. 浏览器设置代理: HTTP 127.0.0.1:7890 或 SOCKS5 127.0.0.1:7891

          mixed-port: 7890
          socks-port: 7891
          allow-lan: false
          bind-address: '*'
          mode: rule
          log-level: info
          ipv6: true

          external-controller: 127.0.0.1:9090
          external-ui: ui
          secret: ""

          dns:
            enable: true
            ipv6: true
            listen: 0.0.0.0:53
            enhanced-mode: fake-ip
            fake-ip-range: 198.18.0.1/16
            fake-ip-filter:
              - '*.lan'
              - 'localhost.ptlogin2.qq.com'
            nameserver:
              - 223.5.5.5
              - 119.29.29.29
            fallback:
              - 8.8.8.8
              - 1.1.1.1
              - tls://dns.google
            fallback-filter:
              geoip: true
              geoip-code: CN
              ipcidr:
                - 240.0.0.0/4

          # 订阅配置
          proxy-providers:
            justmysocks:
              type: http
              # 订阅地址通过 sops 管理,会在启动时自动替换
              url: "JUSTMYSOCKS_SUBSCRIPTION_URL"
              interval: 3600
              path: ./providers/justmysocks.yaml
              health-check:
                enable: true
                interval: 600
                url: http://www.gstatic.com/generate_204

          # 代理组配置
          proxy-groups:
            - name: "🚀 节点选择"
              type: select
              use:
                - justmysocks
              proxies:
                - "♻️ 自动选择"
                - "DIRECT"
            
            - name: "♻️ 自动选择"
              type: url-test
              use:
                - justmysocks
              url: 'http://www.gstatic.com/generate_204'
              interval: 300
            
            - name: "🌍 国外网站"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
                - "DIRECT"
            
            - name: "📲 Telegram"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
            
            - name: "🎬 流媒体"
              type: select
              proxies:
                - "🚀 节点选择"
                - "♻️ 自动选择"
            
            - name: "🍎 Apple"
              type: select
              proxies:
                - "DIRECT"
                - "🚀 节点选择"
            
            - name: "🎯 全球直连"
              type: select
              proxies:
                - "DIRECT"
                - "🚀 节点选择"
            
            - name: "🐟 漏网之鱼"
              type: select
              proxies:
                - "🚀 节点选择"
                - "DIRECT"

          # 规则配置 - 自动将中国以外的流量通过代理
          rules:
            # Telegram
            - DOMAIN-SUFFIX,t.me,📲 Telegram
            - DOMAIN-SUFFIX,tdesktop.com,📲 Telegram
            - DOMAIN-SUFFIX,telegra.ph,📲 Telegram
            - DOMAIN-SUFFIX,telegram.me,📲 Telegram
            - DOMAIN-SUFFIX,telegram.org,📲 Telegram
            - IP-CIDR,91.108.4.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.8.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.16.0/22,📲 Telegram,no-resolve
            - IP-CIDR,91.108.56.0/22,📲 Telegram,no-resolve
            - IP-CIDR,149.154.160.0/20,📲 Telegram,no-resolve
            
            # 流媒体
            - DOMAIN-SUFFIX,youtube.com,🎬 流媒体
            - DOMAIN-SUFFIX,googlevideo.com,🎬 流媒体
            - DOMAIN-SUFFIX,netflix.com,🎬 流媒体
            - DOMAIN-SUFFIX,nflxvideo.net,🎬 流媒体
            - DOMAIN-SUFFIX,spotify.com,🎬 流媒体
            - DOMAIN-SUFFIX,twitch.tv,🎬 流媒体
            
            # Apple
            - DOMAIN-SUFFIX,apple.com,🍎 Apple
            - DOMAIN-SUFFIX,icloud.com,🍎 Apple
            - DOMAIN-SUFFIX,mzstatic.com,🍎 Apple
            
            # 国内直连
            - DOMAIN-SUFFIX,cn,🎯 全球直连
            - DOMAIN-KEYWORD,-cn,🎯 全球直连
            - GEOIP,CN,🎯 全球直连
            
            # 国外网站
            - DOMAIN-SUFFIX,google.com,🌍 国外网站
            - DOMAIN-SUFFIX,github.com,🌍 国外网站
            - DOMAIN-SUFFIX,githubusercontent.com,🌍 国外网站
            - DOMAIN-SUFFIX,cloudflare.com,🌍 国外网站
            - DOMAIN-SUFFIX,openai.com,🌍 国外网站
            
            # 局域网直连
            - DOMAIN-SUFFIX,local,DIRECT
            - IP-CIDR,192.168.0.0/16,DIRECT
            - IP-CIDR,10.0.0.0/8,DIRECT
            - IP-CIDR,172.16.0.0/12,DIRECT
            - IP-CIDR,127.0.0.0/8,DIRECT
            - IP-CIDR,100.64.0.0/10,DIRECT
            
            # 最终规则
            - MATCH,🐟 漏网之鱼
        '';

        # 创建订阅提供者目录
        home.file."${mihomoDir}/providers/.keep".text = "";

        # Shell 别名 - 自动替换订阅地址并启动
        programs.bash.shellAliases = {
          mihomo-start = ''
            sed "s|JUSTMYSOCKS_SUBSCRIPTION_URL|$(cat ${mihomoDir}/.subscription_url)|g" \
              ${mihomoDir}/config.yaml.template > ${mihomoDir}/config.yaml && \
            mihomo -d ${mihomoDir}
          '';
          mihomo-test = "curl -x http://127.0.0.1:7890 https://www.google.com -I";
        };

        programs.fish.shellAliases = {
          mihomo-start = ''
            sed "s|JUSTMYSOCKS_SUBSCRIPTION_URL|$(cat ${mihomoDir}/.subscription_url)|g" \
              ${mihomoDir}/config.yaml.template > ${mihomoDir}/config.yaml && \
            mihomo -d ${mihomoDir}
          '';
          mihomo-test = "curl -x http://127.0.0.1:7890 https://www.google.com -I";
        };

        # 添加到 shell 配置的说明注释
        home.file."${mihomoDir}/README.md".text = ''
          # Mihomo 配置说明

          ## 初次使用

          1. 订阅地址已通过 sops 加密管理,无需手动配置
          2. 直接启动 mihomo: `mihomo-start`

          ## 常用命令

          - `mihomo-start` - 启动 mihomo 服务(自动加载订阅地址)
          - `proxy-on` - 在当前终端开启全局代理
          - `proxy-off` - 在当前终端关闭代理
          - `px <命令>` - 为单个命令使用代理,例如: `px curl https://google.com`
          - `mihomo-test` - 测试代理是否工作

          ## 代理端口

          - HTTP/HTTPS: 127.0.0.1:7890
          - SOCKS5: 127.0.0.1:7891
          - 控制面板: http://127.0.0.1:9090

          ## 代理规则

          - 中国大陆网站和 IP: 直连
          - 其他国外网站: 自动通过代理
          - 可在 config.yaml.template 中自定义规则

          ## 订阅管理

          - 订阅地址存储在: secrets/secrets.yaml
          - 密钥: justmysocks.subscription_url
          - 使用 sops 编辑: `sops secrets/secrets.yaml`
        '';
      };
  };
}
