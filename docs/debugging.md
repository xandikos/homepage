# Debugging

## Filing a bug report

When filing a bug, please include:

- The Xandikos version (`xandikos --version`)
- The CalDAV/CardDAV client you are using and its version
- Your deployment method (standalone, uWSGI, Docker, etc.)
- Steps to reproduce the issue

Bug reports go in the [GitHub issue tracker](https://github.com/jelmer/xandikos/issues/new).

It helps a lot to reproduce the issue with a clean Xandikos setup, both to
isolate the problem and to make it safe to share log files.

## Checking server-side contents

Because Xandikos stores data as files in a Git repository, you can inspect the
state of any collection directly:

```shell
# List commits in a calendar collection
git -C /var/lib/xandikos/user/calendars/personal log --oneline

# Show the contents of a specific item
git -C /var/lib/xandikos/user/calendars/personal show HEAD:some-event.ics
```

This is useful for confirming whether data was actually saved correctly,
independent of what any client reports.

## DAV XML logging

Pass `--dump-dav-xml` to have Xandikos print all DAV XML requests and
responses to stdout:

```shell
xandikos --dump-dav-xml -d $HOME/dav
```

!!! warning
    DAV XML payloads may contain personal information (event titles, contact
    names, etc.). Scrub or review them before posting in a public issue.

## Log verbosity

Xandikos logs to stderr by default. To capture logs when running under
systemd:

```shell
journalctl -u xandikos -f
```

Under uWSGI, add `logto = /var/log/xandikos.log` to your uWSGI ini file.

## Common problems

**Client can't find calendars or address books**

Check that service discovery is configured. Clients that support
[RFC 6764](https://www.rfc-editor.org/rfc/rfc6764) look for
`/.well-known/caldav` and `/.well-known/carddav`. See
[Deployment](deployment.md) for the required Nginx redirects.

Clients without service discovery need the direct URL to a collection, e.g.:

```
https://dav.example.com/user/calendars/personal/
```

**Authentication failures**

Verify that `REMOTE_USER` is being set correctly by your proxy. See
[Authentication](authentication.md) for details.

**Empty collections after restart**

Xandikos creates collections lazily. If `--defaults` / `AUTOCREATE=defaults`
is not set, collections are only created when a client requests them or you
create a Git repository manually. See [Configuration](configuration.md).

**Workarounds for buggy clients**

If a specific client behaves oddly, try running with `--no-strict` to enable
compatibility workarounds for known client bugs.
