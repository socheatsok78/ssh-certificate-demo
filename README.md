# ssh-certificate-demo

If you’re not using SSH certificates you’re doing SSH wrong

## Guide

### Add `cert-authority` to `known_hosts`

```
@cert-authority *.multipass.local ssh-ed25519 AAAAC3...
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

## Reference

- https://smallstep.com/blog/use-ssh-certificates/
- https://berndbausch.medium.com/ssh-certificates-a45bdcdfac39
- https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates
- https://engineering.fb.com/2016/09/12/security/scalable-and-secure-access-with-ssh/
- https://github.com/vedetta-com/vedetta/blob/master/src/usr/local/share/doc/vedetta/OpenSSH_Principals.md
