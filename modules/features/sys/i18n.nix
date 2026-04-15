{
  flake.aor.modules.feature.sys.i18n = {
    nixos =
      { ... }:
      {
        time.timeZone = "Asia/Shanghai";
        i18n.defaultLocale = "en_US.UTF-8";

        networking.timeServers = [
          "ntp.aliyun.com" # Aliyun NTP Server
          "ntp.tencent.com" # Tencent NTP Server
        ];
      };
  };
}
