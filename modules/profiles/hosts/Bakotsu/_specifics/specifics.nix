{ pkgs, ... }:
{
  networking.proxy = {
    default = "http://l00809570:lyf19940126!@proxyhk.huawei.com:8080";
    noProxy = "127.0.0.1,.huawei.com,.inhuawei.com,10.,100.";
  };

  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    ./certs/huawei_web_secure_internet_gateway.cer
  ];
}
