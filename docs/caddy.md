# caddy

Caddy is a simple but powerful webserver and reverse-proxy.

https://caddyserver.com/docs/quick-starts/reverse-proxy

## Caddy Reverse Proxy 
```
brew install caddy
```

### Caddyfile HTTPS
You can use Caddy to run a HTTPS reverse proxy that forwards your requests to your separate applications. 
Very important: Make sure you are NOT running your applications on https. 
Only caddy should be binding to the host machine's 443 SSL port.

#### Step 1: Update your `etc/hosts`
```
127.0.0.1 dashboard-demo.ocrolus.com
127.0.0.1 app-demo.ocrolus.com
```

#### Step 2: Generate your certificate files

```sh
# For nginx. It requires the filename to contain chained.
cat app-demo.ocrolus.com.crt cacert.crt > _wildcard.ocrolus.com.chained.crt

# For Caddy.
cat app-demo.ocrolus.com.crt cacert.crt > _wildcard.ocrolus.com.crt

# Copy over key to this new wildcard domain key.
cp app-demo.ocrolus.com.key _wildcard.ocrolus.com.key
```

#### Step 3: Then create a directory with these files:
- Caddyfile
- _wildcard.ocrolus.com.crt
- _wildcard.ocrolus.com.key
- cacert.crt (install on keychain, not used otherwise)
- cakey.key (install on keychain, not used otherwise)

#### Step 4: Then edit the Caddyfile 
```caddy
app-demo.ocrolus.com {
	log
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
	log
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

Note: in the reverse-proxy, it will use the incorrect origin. 
```
12:11:39 WARNI [resourceserver.tweens][waitress] dashboard: https://dashboard-demo.ocrolus.com
12:11:39 WARNI [resourceserver.tweens][waitress] origin: app-demo.ocrolus.com
```

Remove the `Host` and `Origin` to not forward these headers to application since it can 
interfere with the expected origin of the applications.
```
header_up Host {host}
header_up Origin {host}
```

If that's the case, then use the following Caddyfile.

```
app-demo.ocrolus.com {
  log
  tls _wildcard.ocrolus.com.crt _wildcard.ocrolus.com.key
  reverse_proxy localhost:9000 {
    header_up X-Real-IP {remote}
    header_up X-Forwarded-Host {host}
    header_up X-Forwarded-Server {host}
    header_up X-Forwarded-Port {port}
    header_up X-Forwarded-For {remote}
  }
}

dashboard-demo.ocrolus.com {
  log
  tls _wildcard.ocrolus.com.crt _wildcard.ocrolus.com.key
  reverse_proxy localhost:3001 {
    header_up X-Real-IP {remote}
    header_up X-Forwarded-Host {host}
    header_up X-Forwarded-Server {host}
    header_up X-Forwarded-Port {port}
    header_up X-Forwarded-For {remote}
  }
}

```


#### Step 5: Then run Caddy server
```sh
# Use default Caddyfile
sudo caddy run 

# Use specified Caddyfile
sudo caddy run --config Caddyfile
```

## Testing Reverse Proxy
In two separate terminal windows, spin up these two simple python http servers.
```
python -m http.server 9000
python -m http.server 3001
```

Then with HTTPie, try to hit the two python servers.

```sh
http -v --verify=no https://app-demo.ocrolus.com
http -v --verify=no https://dashboard-demo.ocrolus.com
```

Once you verify that it works, you can stop the simple python http servers. 
Then run your own application servers on http (**do not run on https**). 

```sh
http -p Hh --verify cacert.crt https://dashboard-demo.ocrolus.com
http -p Hh --verify cacert.crt https://app-demo.ocrolus.com
```

### Screenshots

Testing Caddy reverse proxy with python HTTP servers and HTTPie.

![Caddy Reverse Proxy](https://user-images.githubusercontent.com/3826772/133660001-66bc6acd-18b4-468f-81bb-3084b71ac8ca.jpg)
