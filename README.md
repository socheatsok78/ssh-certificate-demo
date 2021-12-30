# ssh-certificate-demo

If you’re not using SSH certificates you’re doing SSH wrong

## Guide

**Enable Vagrant Experimental features**

Add the following variable to your `.bashrc` or `.zshrc`

```
export VAGRANT_EXPERIMENTAL="1"
```

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
Dec 30 09:33:02 ubuntu-focal sshd[1331]: Accepted publickey for vagrant from 10.0.2.2 port 52115 ssh2: RSA SHA256:W9rlwlkM/uLCn8n7/b2BfDR3xwnUDBCVHrjwTC2t7AI
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
