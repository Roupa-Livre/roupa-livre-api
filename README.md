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
sudo rm home/deploy-roupalivre/roupa-livre-api/shared/log/production.log -f
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