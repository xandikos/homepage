# Deployment

## Testing / development

To run a standalone instance with no authentication (useful for testing),
storing data in `$HOME/dav`:

```shell
xandikos --defaults -d $HOME/dav
```

This starts a server on [localhost:8080](http://localhost:8080/). The
`--defaults` flag creates a default calendar and address book on first run.

---

## Production with uWSGI + Nginx

For production use, the recommended setup is uWSGI behind Nginx. Nginx handles
TLS and authentication; uWSGI runs Xandikos as a WSGI application.

### uWSGI configuration

Save the following as `/etc/uwsgi/apps-enabled/xandikos.ini`, adjusting paths
as needed:

```ini
[uwsgi]
socket = 127.0.0.1:8001
uid = xandikos
gid = xandikos
master = true
cheaper = 0
processes = 1
plugin = python3
module = xandikos.wsgi:app
umask = 022
env = XANDIKOSPATH=/var/lib/xandikos/collections
env = CURRENT_USER_PRINCIPAL=/user/
# Create default calendar and contacts collections on first run
env = AUTOCREATE=defaults
```

### Nginx configuration

The following configuration proxies requests to uWSGI, enables HTTPS via
Let's Encrypt, and handles CalDAV/CardDAV service discovery ([RFC 6764](https://www.rfc-editor.org/rfc/rfc6764)):

```nginx
upstream xandikos {
    server 127.0.0.1:8080;
    # server unix:/run/xandikos.socket;
}

server {
    server_name dav.example.com;

    # Service discovery (RFC 6764)
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
        auth_basic_user_file /etc/xandikos/htpasswd;
    }

    listen 443 ssl http2;
    listen [::]:443 ssl ipv6only=on http2;

    ssl_certificate /etc/letsencrypt/live/dav.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dav.example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
    if ($host = dav.example.com) {
        return 301 https://$host$request_uri;
    }
    listen 80;
    listen [::]:80;
    server_name dav.example.com;
    return 404;
}
```

Create an htpasswd file for authentication:

```shell
sudo htpasswd -c /etc/xandikos/htpasswd myusername
```

See [Authentication](authentication.md) for more detail on how Xandikos
handles the authenticated user identity.

---

## systemd socket activation

Xandikos supports systemd socket activation. Two unit files are needed.

`/etc/systemd/system/xandikos.socket`:

```ini
[Unit]
Description=Xandikos socket

[Socket]
ListenStream=/run/xandikos.sock

[Install]
WantedBy=sockets.target
```

`/etc/systemd/system/xandikos.service`:

```ini
[Unit]
Description=Xandikos CalDAV/CardDAV server
After=network.target

[Service]
ExecStart=/usr/local/bin/xandikos \
  -d /var/lib/xandikos \
  --route-prefix=/dav \
  --current-user-principal=/jelmer \
  -l /run/xandikos.sock
User=xandikos
Group=www-data
Restart=on-failure
KillSignal=SIGQUIT
Type=simple
NotifyAccess=all
```

Enable and start:

```shell
sudo systemctl enable --now xandikos.socket
```

---

## uWSGI standalone (with built-in HTTP and auth)

For simpler setups, uWSGI can handle HTTP and basic authentication directly
without a separate web server:

```ini
[uwsgi]
http-socket = 127.0.0.1:8080
umask = 022
master = true
cheaper = 0
processes = 1
plugin = router_basicauth,python3
route = ^/ basicauth:myrealm,user1:password1
module = xandikos.wsgi:app
env = XANDIKOSPATH=$HOME/dav
env = CURRENT_USER_PRINCIPAL=/dav/user1/
env = AUTOCREATE=defaults
```

```shell
mkdir -p $HOME/dav
uwsgi uwsgi-standalone.ini
```

---

## Command-line reference

| Option | Default | Description |
|--------|---------|-------------|
| `-d`, `--directory` | *(required)* | Directory to store data in |
| `-l`, `--listen-address` | `localhost` | Address to bind to; pass a path for a Unix socket |
| `-p`, `--port` | `8080` | Port to listen on |
| `--route-prefix` | `/` | Path prefix when behind a reverse proxy |
| `--current-user-principal` | `/user/` | Path to the current user principal |
| `--autocreate` | off | Create necessary directories automatically |
| `--defaults` | off | Create default calendar and address book (implies `--autocreate`) |
| `--no-strict` | off | Enable workarounds for buggy client implementations |
| `--dump-dav-xml` | off | Log DAV XML requests/responses (for debugging) |
| `--avahi` | off | Announce services via Avahi/mDNS |
