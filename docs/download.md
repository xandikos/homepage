# Download

## PyPI

Xandikos can be installed from PyPI using pip by running:

```shell
python3 -m pip install --upgrade xandikos
```

## Git

You can either clone the Xandikos repository at [GitHub](https://github.com/jelmer/xandikos/):

```shell
git clone https://github.com/jelmer/xandikos
```

## Releases

For a list of releases, see the [Releases page on GitHub](https://github.com/jelmer/xandikos/releases).

## Debian/Ubuntu

If you're running a recent version of Debian or Ubuntu, you can install a
nightly snapshot of Xandikos built by the [Debian Janitor](https://janitor.debian.net/).
See [the instructions](https://janitor.debian.net/fresh) for details, or run:

```shell
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/debian-janitor.gpg]" \
    https://janitor.debian/net/ fresh-snapshots main | \
    sudo tee /etc/apt/sources.list.d/fresh-snapshots.list
sudo curl -o /usr/share/keyrings/debian-janitor.gpg https://janitor.debian.net/pgp_keys
sudo apt update
sudo apt install -t fresh-snapshots xandikos
```

## Docker

Xandikos is also available as a Docker image on `ghcr.io/jelmer/xandikos`. You can pull it using:

```shell
docker pull ghcr.io/jelmer/xandikos:latest
```
