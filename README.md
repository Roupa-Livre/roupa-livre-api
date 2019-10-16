# Para Setup DEV #

```
docker-compose build
docker-compose up
docker-compose exec website rake db:reset db:migrate db:seed
```

# Para Conectar #

```
ssh -i ../keys/amazon-roupa-livre-main.pem ubuntu@54.233.232.60
```


```
su - deploy-roupalivre
```

Peça credenciais para Mari no email ou verifique se já não estão no seu email.

# Para verificar espaço livre #

```
# Para listar o disco principal
df -h | grep /dev/xvda1

# Para listar todos os discos
df -h
```

# Para apagar o arquivo temporario #

No server (para apagar o log do Ruby - que fica grande)
```
sudo rm /home/deploy-roupalivre/roupa-livre-api/shared/log/production.log -f
sudo lsof | grep deleted

# PID que tiver associado ao log acima
sudo kill -9 [PID]
```

No Client (para reinicar o server)
```
cap production deploy
```

Caso ainda tenham arquivos para listar, no Server
```
# diretorios
sudo du -a / | sort -n -r | head -n 5

# arquivos
sudo find / -type f -exec du -Sh {} + | sort -rh | head -n 5

```

# Para salvar o log #

1 - On Server
```
mkdir "logs-$(date +"%Y-%m-%d")"
cd "logs-$(date +"%Y-%m-%d")"

cp /home/deploy-roupalivre/roupa-livre-api/shared/log/* ./ -R
cd ..
tar -czvf "logs-$(date +"%Y-%m-%d").tar.gz" ./"logs-$(date +"%Y-%m-%d")"
```

2 - Locally
```
scp -i ../keys/amazon-roupa-livre-main.pem ubuntu@54.233.232.60:/home/ubuntu/"logs-$(date +"%Y-%m-%d").tar.gz" ./log/"logs-$(date +"%Y-%m-%d").tar.gz"
```

3 - Back on Server
```
sudo rm /home/deploy-roupalivre/roupa-livre-api/shared/log/*.log -f
rm -rf "logs-$(date +"%Y-%m-%d")"
rm "logs-$(date +"%Y-%m-%d").tar.gz"

sudo kill -9 $(sudo lsof | grep deleted | grep shared/log | sed -r 's/[^ ]* ([0-9]*).*/\1/g' | sed '/^$/d' | uniq)
```

4 - Locally (to restart server)
```
cap production deploy
```