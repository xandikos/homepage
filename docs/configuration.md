# Configuration

## Data directory layout

Xandikos stores all data in the directory specified by `-d` / `--directory`
(or `XANDIKOSPATH` under uWSGI). The directory contains one subdirectory per
principal (user). Within a principal directory, each calendar or address book
is a Git repository.

```
/var/lib/xandikos/
└── user/               ← principal (--current-user-principal=/user/)
    ├── calendars/
    │   └── personal/   ← a calendar (Git repo)
    └── contacts/
        └── default/    ← an address book (Git repo)
```

When `--defaults` (or `AUTOCREATE=defaults`) is set, Xandikos creates the
principal directory and default `calendars/personal` and `contacts/default`
collections automatically on the first request.

Collections can also be created by your CalDAV/CardDAV client, or manually by
initialising a Git repository in the right place:

```shell
git init /var/lib/xandikos/user/calendars/work
```

## Per-collection configuration

Each collection directory can contain a `.xandikos` file with collection-level
settings. This is a simple INI-style file:

```ini
# Color shown in compatible clients (hex RGB, no #)
color = FF0000

# URL of the scheduling inbox for this collection
inbox-url = inbox/
```

## Environment variables (uWSGI / WSGI)

When running under uWSGI or any WSGI server, Xandikos is configured via
environment variables instead of command-line flags:

| Variable | Equivalent flag | Description |
|----------|----------------|-------------|
| `XANDIKOSPATH` | `-d` | Path to the data directory |
| `CURRENT_USER_PRINCIPAL` | `--current-user-principal` | Principal path, e.g. `/user/` |
| `AUTOCREATE` | `--autocreate` / `--defaults` | Set to `principal` or `defaults` |

Example uWSGI snippet:

```ini
env = XANDIKOSPATH=/var/lib/xandikos/collections
env = CURRENT_USER_PRINCIPAL=/user/
env = AUTOCREATE=defaults
```

## Route prefix

If Xandikos is not served from the root of your domain (e.g. it lives at
`https://example.com/dav/`), set `--route-prefix`:

```shell
xandikos -d /var/lib/xandikos --route-prefix=/dav
```

Or in uWSGI, pass it as a command-line argument or set it via the
`env` mechanism if you wrap the entrypoint.

## Strict mode

By default, Xandikos runs in strict mode and rejects requests that do not
conform to the CalDAV/CardDAV standards. Pass `--no-strict` to enable
workarounds for known buggy client implementations.

## Service discovery

Clients that support automatic service discovery ([RFC 6764](https://www.rfc-editor.org/rfc/rfc6764))
look for `/.well-known/caldav` and `/.well-known/carddav`. Your reverse proxy
should redirect these to the correct collection paths. Example Nginx
configuration is in [Deployment](deployment.md).
