# docker-wg

# Особенности
- Максимально лёгкий, ничего лишнего
- Работает на модуле ядра
- Сгенерирует пустой конфиг, если его нет

# Как пользоваться

```bash
sudo cp systemd/docker-wg@.service /etc/systemd/system/
# Порт по умолчанию — стандартный 51820, его можно поменять в файле сервиса
sudo mkdir /opt/docker-wg_data && sudo chmod 600 /opt/docker-wg_data
sudo systemctl daemon-reload
sudo systemctl enable --now docker-wg@wg0
# добавьте пиров в /opt/docker-wg_data/wg0.conf 
sudo systemctl reload docker-wg_data@wg0
```

Также в репозитории есть образец compose-файла. 

# Получение трафика

`docker exec docker-wg wg-traffic.sh`
