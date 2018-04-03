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

## Terraform
### Управление ключами
Управление ssh ключами в метаданных проекта осуществляется через ресурсы
`google_compute_project_metadata` и `google_compute_project_metadata_item`.
Однако Terraform переписыват ключ `ssh-keys` целиком. Поэтому внесённые вручную
изменения через web или gcloud будут перезаписаны при `terraform apply`.
### Управление инстансами
При необходимости создания нескольких идентичных инстансов простое копирование
кода с изменением имени даёт нужный результат. Однако такой подход чреват ошибками
при копировании, сложно вносить изменения (необходимо внести изменения в каждый блок).

Для избежания избыточного копирования испльзуется переменная `count`, значение которой задаётся через параметр `instances_count`. Этот парамерт определяет количество инстансов, трафик на которые распределятеся через HTTP балансировщик. Конфигурация описана в файле `lb.tf`.
### Хранение state файла на удалённом бекенде
При командной работе важна синхронизация state файла terraform, чтобы каждый участник владел актуальной информацией о существующей инфраструктуре. Для этого удобно использовать возможность хранения state файла на удалённом бекенде. Это предоставляет следующие преимущества:
- Актуализацию состояния
- Блокировка одновременных изменений
- Опционально: версионирование state файла