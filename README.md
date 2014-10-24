# Docker Reverse Proxy

A Nginx based reverse proxy or one or more sites on one ip address as a docker image.

## Buid

```bash
sudo docker build -t=andreaskoch/reverse-proxy .
```

## Run

To run the reverse proxy you must link a directory with Nginx virtual host configuration files into the `/etc/nginx/conf.d` folder of container:

```bash
docker run -d -p 80:80 -p 443:443 -v "$(pwd)/sample-nginx-conf:/etc/nginx/conf.d" andreaskoch/reverse-proxy
```

## Configuration

You can add nginx configuration files to the mapped folder - they will be reloaded every 60 seconds.

A simple virtual host configuration could for example look something like this:

```
server {
    listen                      80 default;

    location / {
        proxy_buffering         off;
        proxy_pass              http://example.com;
    }
}
```