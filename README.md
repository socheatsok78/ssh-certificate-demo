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

## Reference

- https://smallstep.com/blog/use-ssh-certificates/
- https://berndbausch.medium.com/ssh-certificates-a45bdcdfac39
- https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates
