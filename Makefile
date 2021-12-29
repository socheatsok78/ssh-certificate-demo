trusted-ca=TrustedCA/root-ca
expire=+30m
host-cert-expire=+500w

main:
	@echo Usage:
	@echo - sign: sign my public key with root-ca private key
	@echo - bootstrap: generate trusted root-ca and host-cert
	@echo - generate-trusted-root-ca: generate trusted root-ca
	@echo - generate-trusted-host-cert: generate trusted host-cert
	@echo - sign-trusted-host-cert: sign trusted host-cert

bootstrap: clean reset generate-trusted-root-ca generate-trusted-host-cert

sign:
	ssh-keygen -s ${trusted-ca} -I user-`uuidgen` -n ubuntu -V ${expire} ${HOME}/.ssh/id_ed25519.pub
	ssh-keygen -Lf ${HOME}/.ssh/id_ed25519-cert.pub

generate-trusted-root-ca:
	ssh-keygen -t ed25519 -C "root-ca" -f ${trusted-ca}
	chmod 0400 ${trusted-ca}

generate-trusted-host-cert: sign-trusted-host-cert
	ssh-keygen -t ed25519 -C "root-ca" -f TrustedHost/host_key

sign-trusted-host-cert:
	ssh-keygen -h -s ${trusted-ca} -I host-`uuidgen` -n *.multipass.local -V ${host-cert-expire} TrustedHost/host_key.pub

clean:
	rm ~/.ssh/id_rsa-cert.pub

reset:
	rm {TrustedCA,TrustedHost}/*

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
