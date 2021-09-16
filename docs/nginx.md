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
127.0.0.1 app-local.stash.com
```


#### Step 3: create or update the nginx config

```sh
# Linux
sudo vim /etc/nginx/nginx.conf

# Mac
vim /usr/local/etc/nginx/nginx.conf
```

It is better to create a new config file inside `servers/anyname.conf`

```nginx
server {
  listen 80;

  server_name app-local.stash.com;

  location /sign-up {
    proxy_pass http://127.0.0.1:3000;
  }

  location / {
    proxy_pass http://127.0.0.1:57454;
  }
}
```

With certificates

```nginx
server {
  listen 443;

  server_name app-demo.ocrolus.com;
  ssl_certificate     /etc/ssl/_wildcard.ocrolus.com.chained.crt;
  ssl_certificate_key /etc/ssl/_wildcard.ocrolus.com.key;
  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;

  location / {
    proxy_pass http://0.0.0.0:9000;
  }
}

server {
  listen 443;

  server_name dashboard-demo.ocrolus.com;
  ssl_certificate     /etc/ssl/_wildcard.ocrolus.com.chained.crt;
  ssl_certificate_key /etc/ssl/_wildcard.ocrolus.com.key;
  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
  
  location / {
    proxy_pass http://0.0.0.0:3001;
  }
}
```

#### Step 4: restart nginx server

```sh
sudo nginx -s reload
```

### Disable HSTS
If you have a local https server and are on Mac High Sierra and above, Chrome will prevent you from visiting insecure websites with untrusted certificates.
You can disable this feature by trusting the certificate in your keychain access, clicking on the https lock on chrome and trusting the certificate, and removing the domain from Chrome's HSTS:
```
chrome://net-internals/#hsts
```

https://virtuallywired.io/2020/01/02/fix-error-you-cannot-visit-site-right-now-because-the-website-uses-hsts/

