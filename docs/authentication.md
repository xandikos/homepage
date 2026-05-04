# Authentication

Xandikos delegates authentication entirely to the surrounding infrastructure —
it does not manage passwords or user credentials itself. Instead, it expects
the WSGI environment to contain a `REMOTE_USER` variable set by an
authenticating proxy or WSGI middleware.

## How it works

When a request arrives, Xandikos checks `REMOTE_USER`:

- If present, the value is used as the authenticated username, which is then
  mapped to a principal path (see `--current-user-principal`).
- If absent for a resource that requires authentication, Xandikos returns
  `401 Unauthorized`.
- If a user is authenticated but lacks access to a resource, Xandikos returns
  `403 Forbidden`.

This means **authentication is always handled outside Xandikos**, typically by:

- A reverse proxy such as Nginx or Apache (recommended for production)
- uWSGI's built-in `router_basicauth` plugin (simpler setups)
- Any WSGI middleware that sets `REMOTE_USER`

## Nginx with HTTP basic auth

Nginx authenticates the user via an htpasswd file and proxies the request to
Xandikos. Because Nginx sets `REMOTE_USER` via the proxy headers, Xandikos
knows who is logged in.

Create a password file:

```shell
sudo htpasswd -c /etc/xandikos/htpasswd myusername
```

In your Nginx `location` block:

```nginx
location / {
    proxy_pass http://xandikos;
    auth_basic "Login required";
    auth_basic_user_file /etc/xandikos/htpasswd;
}
```

See the full Nginx example in [Deployment](deployment.md).

## uWSGI built-in basic auth

For simpler setups without a separate web server, uWSGI can handle
authentication directly:

```ini
plugin = router_basicauth,python3
route = ^/ basicauth:myrealm,username:password
```

Replace `username:password` with real credentials. See the full example in
[Deployment](deployment.md).

## Apache with mod_auth

Apache can authenticate users via `mod_auth_basic` and pass `REMOTE_USER` to
Xandikos via uWSGI:

```apache
<Location />
    AuthType Basic
    AuthName "Xandikos"
    AuthUserFile /etc/xandikos/htpasswd
    Require valid-user
</Location>
```

## Principal mapping

Once authenticated, the username from `REMOTE_USER` is mapped to a principal
path. By default this is `/user/`, controlled by the `--current-user-principal`
flag (or the `CURRENT_USER_PRINCIPAL` environment variable when running under
uWSGI).

For single-user setups a fixed path is fine. For multi-user setups the
principal path should include the username so each user gets their own
collection tree, for example `/%(username)s/`.
