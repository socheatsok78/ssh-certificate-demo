# ssh-certificate-demo

If you’re not using SSH certificates you’re doing SSH wrong

## Guide

### Add `cert-authority` to `known_hosts`

Copy the `root-ca` public key and add it to the `known_hosts` file by append `@cert-authority` and `list-of-host` in front of the public key.

```
@cert-authority *.vagrant.local ssh-ed25519 AAAAC3...
```

## Troubleshooting

By default, SSH logs to /var/log/auth.log, but so do many other things. To extract just the SSH logs, use the following:

```
tail -f /var/log/auth.log | grep --line-buffered "sshd"
```

On some versions of SSH, you may get the following error on target host:

```
userauth_pubkey: certificate signature algorithm ssh-rsa: signature algorithm not supported [preauth]
```

Fix is to add below line to `/etc/ssh/sshd_config`

```
CASignatureAlgorithms ^ssh-rsa

# or

CASignatureAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
```

### Logs

**Authenticate with Public Key**

```log
Dec 30 03:41:42 ubuntu sshd[1922]: Connection closed by authenticating user vagrant 192.168.56.1 port 50217 [preauth]
Dec 30 03:43:54 ubuntu sshd[2028]: Accepted publickey for vagrant from 10.0.2.2 port 50253 ssh2: RSA SHA256:LSfV4x3IJ/0vdKO+JI659xoFI8Vyb6sjmTw7y8UdvC0
```

**Certificate does not contain an authorized principal**

```log
Dec 30 03:44:52 ubuntu sshd[2185]: error: Certificate does not contain an authorized principal
Dec 30 03:44:52 ubuntu sshd[2185]: Connection closed by authenticating user vagrant 192.168.56.1 port 50269 [preauth]
```

## Reference

- https://smallstep.com/blog/use-ssh-certificates/
- https://berndbausch.medium.com/ssh-certificates-a45bdcdfac39
- https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates
- https://engineering.fb.com/2016/09/12/security/scalable-and-secure-access-with-ssh/
- https://github.com/vedetta-com/vedetta/blob/master/src/usr/local/share/doc/vedetta/OpenSSH_Principals.md
