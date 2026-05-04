# Docker

Xandikos is available as a Docker image on `ghcr.io/jelmer/xandikos`.

## Quick start

```shell
docker run -p 8000:8000 -v $HOME/dav:/data \
  ghcr.io/jelmer/xandikos:latest --defaults
```

This starts an unauthenticated Xandikos instance on port 8000, storing data in
`$HOME/dav` on the host. The `--defaults` flag creates a default calendar and
address book on first run.

!!! warning
    The container runs without authentication by default. For anything beyond
    local testing, place it behind a reverse proxy that handles authentication.
    See [Authentication](authentication.md).

## With Docker Compose

A minimal Compose setup behind an Nginx reverse proxy:

```yaml
services:
  xandikos:
    image: ghcr.io/jelmer/xandikos:latest
    command: --defaults
    volumes:
      - xandikos-data:/data
    expose:
      - "8000"

  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - ./htpasswd:/etc/nginx/htpasswd:ro
      - ./certs:/etc/letsencrypt:ro
    depends_on:
      - xandikos

volumes:
  xandikos-data:
```

`nginx.conf`:

```nginx
upstream xandikos {
    server xandikos:8000;
}

server {
    server_name dav.example.com;

    location = /.well-known/caldav {
        return 307 $scheme://$host/user/calendars;
    }
    location = /.well-known/carddav {
        return 307 $scheme://$host/user/contacts;
    }

    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;
        proxy_buffering off;
        proxy_pass http://xandikos;
        auth_basic "Login required";
        auth_basic_user_file /etc/nginx/htpasswd;
    }

    listen 443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/dav.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dav.example.com/privkey.pem;
}

server {
    listen 80;
    server_name dav.example.com;
    return 301 https://$host$request_uri;
}
```

Create the htpasswd file:

```shell
htpasswd -c htpasswd myusername
```

## Image details

| Detail | Value |
|--------|-------|
| Image | `ghcr.io/jelmer/xandikos` |
| Exposed port | `8000` |
| Data volume | `/data` |
| Entrypoint | `python3 -m xandikos.web --port=8000 --listen-address=0.0.0.0 -d /data` |

All [command-line options](deployment.md#command-line-reference) can be passed
as arguments to `docker run` after the image name.
