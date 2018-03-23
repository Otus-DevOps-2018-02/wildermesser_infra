# wildermesser_infra

## Подключение через bastion хост одной строкой (ключ должен быть добавлен в ssh-agent)
    ssh -i appuser -J appuser@35.204.245.239 -A appuser@10.164.0.3

## Подключение через bastion командой ssh someinternalhost требует следующего содержания файла ~/.ssh/ssh_config
    Host someinternalhost
      HostName 10.164.0.3
      IdentityFile ~/.ssh/appuser
      ProxyJump bastion
      User appuser
    Host bastion
      HostName 35.204.245.239
      IdentityFile ~/.ssh/appuser
      User appuser

## Данные для проверки подклчения по vpn
bastion_IP = 35.204.245.239
someinternalhost_IP = 10.164.0.3
