trusted-ca=TrustedCA/root-ca
expire=+1m
host-cert-expire=always:forever
# host-cert-expire=+500w

user=${USER}
team=team-default
remote-host=default

main:
	@echo Usage:
	@echo - sign: sign my public key with root-ca private key
	@echo - bootstrap: generate trusted root-ca and host-cert
	@echo - generate-trusted-root-ca: generate trusted root-ca
	@echo - generate-trusted-host-cert: generate trusted host-cert
	@echo - sign-trusted-host-cert: sign trusted host-cert

bootstrap: clean reset generate-trusted-root-ca generate-trusted-host-cert sign-trusted-host-cert

sign:
	@ssh-keygen -s ${trusted-ca} \
		-I ${user} \
		-n ${team} \
		-V ${expire} \
		${HOME}/.ssh/id_ed25519.pub
	@ssh-keygen -Lf ${HOME}/.ssh/id_ed25519-cert.pub

generate-trusted-root-ca:
	@ssh-keygen -t ed25519 -C "root-ca" -f ${trusted-ca}
	@chmod 0400 ${trusted-ca}

generate-trusted-host-cert:
	@ssh-keygen -t ed25519 -C "root-ca" -f TrustedHost/host_key

sign-trusted-host-cert:
	@ssh-keygen \
		-s ${trusted-ca} \
		-h \
		-I ${remote-host}.multipass.local \
		-n ${remote-host}.multipass.local \
		-V ${host-cert-expire} \
		-z 1 \
		TrustedHost/host_key.pub
	@mkdir -p SignedHost/${remote-host}.multipass.local
	@mv TrustedHost/host_key-cert.pub SignedHost/${remote-host}.multipass.local/${remote-host}-cert.pub
	@ssh-keygen -Lf SignedHost/${remote-host}.multipass.local/${remote-host}-cert.pub

clean:
	rm ~/.ssh/id_ed25519-cert.pub | true

reset:
	rm {TrustedCA,TrustedHost}/* | true

create-machine:
	multipass launch -vvvv \
		--name remote-host-01 \
		--network en0 \
		--cloud-init cloud-init/config.yml \
		focal
	multipass list

remove-machine:
	multipass delete remote-host-01
	multipass purge
