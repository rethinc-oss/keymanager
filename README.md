## Getting started

Download the latest tarball from the release page and extract the archive into a directory... that's all.

## What is this?

**keymanager** is a simple shellscript to manage an offline gpg masterkey with subkeys, stored in an encrypted LUKS file image.

The script supports the following commands:

### init

Create a fresh encrypted container and generate a new master key.

You are prompted for two passwords:

1. For the encrypted LUKS container.
2. For the master key.

#### Parameters

| Name               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| -n / --name        | Your name or the name of the organization you create the key for   |
| -e / --email       | The email address associated with the key                          |

Example: `./keymanager init -n "ACME inc." -e "blackhole@acme.inc"`

### addkey

Add a new subkey to the keyring.

#### Parameters

| Name               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| -a / --algorithm   | The public key algorithm, either 'rsa4096' or 'ed25519'            |
| -u / --usage       | What the key is used for, either 'sign' or 'encrypt'               |

Example: `./keymanager addkey -a "ed25519" -u "sign"`

### listkeys

List information abaout the available subkeys.

Example: `./keymanager listkeys`

### exportkey

Export a single subkey without the private masterkey for everyday usage.

#### Parameters

| Name               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| -k / --keyid       | The id of the key to export, as listed in the output of 'listkeys' |

Example: `./keymanager exportkey -k "0CB38197687DDFFE"`

### setexpire

Set the expiry date for a subkey.

#### Parameters

| Name               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| -k / --keyid       | The id of the key to export, as listed in the output of 'listkeys' |
| -e / --expire      | The expire expression. E.g. "5y"                                   |

Example: `./keymanager setexpire -k "0CB38197687DDFFE" -e 6m`

## References

- [gpg man page] (https://www.gnupg.org/documentation/manuals/gnupg24/gpg.1.html)
- [--with-colons format] (https://github.com/CSNW/gnupg/blob/master/doc/DETAILS)
- [key creation] (https://keyring.debian.org/creating-key.html)
- [subkey creation] (https://wiki.debian.org/Subkeys)
- [offline masterkey howto] (https://www.digitalneanderthal.com/post/gpg/)
- [publishing to maven central] (https://central.sonatype.org/publish/requirements/gpg/)
