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

## Данные для проверки подключения по vpn
bastion_IP = 35.204.245.239
someinternalhost_IP = 10.164.0.3

## Данные для проверки подключения к приложению monolith
testapp_IP = 35.204.33.235
testapp_port = 9292

## Команда создания виртуальной машины используя startup скрипт для первичной настройки
gcloud compute instances create reddit-app2\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --metadata-from-file startup-script=startup.sh \
  --restart-on-failure

## Команда создания правила firewall для приложения monolith
gcloud compute firewall-rules create default-puma-server \
    --network default \
    --action allow \
    --direction ingress \
    --rules tcp:9292 \
    --source-ranges 0.0.0.0/0 \
    --priority 1000 \
    --target-tags puma-server
