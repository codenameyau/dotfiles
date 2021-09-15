# nginx

### Local Nginx Reverse Proxy Setup

#### Step 1: install nginx on your machine

```sh
# Mac OS
brew install nginx
```

```sh
# Linux / debian or ubuntu based
sudo apt-get install nginx
```

#### Step 2: map hostnames on etc hosts

```sh
sudo vim /etc/hosts
```

```sh
127.0.0.1 dashboard-local.ocrolus.com
127.0.0.1 cura-local.ocrolus.com
127.0.0.1 app-local.stash.com
```


#### Step 3: create or update the nginx config

```sh
sudo vim /etc/nginx/nginx.conf
```

```nginx
server {
  listen 80;

  server_name app-local.domain.com;

  location /sign-up {
    proxy_pass http://127.0.0.1:3000;
  }

  location / {
    proxy_pass http://127.0.0.1:8009;
  }
}
```

#### Step 4: restart nginx server

```sh
sudo nginx -s reload
```
