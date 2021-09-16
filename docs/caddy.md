# caddy

Caddy is a simple but powerful webserver and reverse-proxy.

https://caddyserver.com/docs/quick-starts/reverse-proxy

```
brew install caddy
```

### Caddyfile HTTPS

Create a directory with these files:
- Caddyfile
- _wildcard.ocrolus.com.crt
- _wildcard.ocrolus.com.key
- cacert.crt
- cakey.key

Then edit the Caddyfile 
```caddy
app-demo.ocrolus.com {
	tls _wildcard.ocrolus.com.crt _wildcard.ocrolus.com.key
	reverse_proxy localhost:9000 {
		header_up Host {host}
		header_up Origin {host}
		header_up X-Real-IP {remote}
		header_up X-Forwarded-Host {host}
		header_up X-Forwarded-Server {host}
		header_up X-Forwarded-Port {port}
		header_up X-Forwarded-For {remote}
	}
}

dashboard-demo.ocrolus.com {
	tls _wildcard.ocrolus.com.crt _wildcard.ocrolus.com.key
	reverse_proxy localhost:3001 {
		header_up Host {host}
		header_up Origin {host}
		header_up X-Real-IP {remote}
		header_up X-Forwarded-Host {host}
		header_up X-Forwarded-Server {host}
		header_up X-Forwarded-Port {port}
		header_up X-Forwarded-For {remote}
	}
}
```
Then run Caddy server
```
sudo caddy run
```
