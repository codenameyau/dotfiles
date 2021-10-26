# httpie

Fetch request.
```sh
http -v https://api.spacexdata.com/v4/launches/latest
```

Automatically converts to POST and Application/JSON if arguments are passed.
```sh
http -v https://api.spacexdata.com/v4/launches/latest name=elon
```

Convert httpie to curl.
```sh
xh --curl -v https://api.spacexdata.com/v4/launches/latest
```
