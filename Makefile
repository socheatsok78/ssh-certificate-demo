trusted-ca=TrustedCA/root-ca
expire=+1m

user=${USER}
team=team-default

# host-cert-expire=+500w
host-cert-expire=always:forever
remote-host=remote-host

main:
	@echo Usage:
	@echo - sign: sign my public key with root-ca private key
	@echo - bootstrap: generate trusted root-ca and host-cert
	@echo - generate-trusted-root-ca: generate trusted root-ca
	@echo - generate-trusted-host-cert: generate trusted host-cert
	@echo - sign-trusted-host-cert: sign trusted host-cert

bootstrap: clean reset generate-trusted-root-ca generate-trusted-host-cert sign-trusted-host-cert

sign: fix-perm
	@ssh-keygen -s ${trusted-ca} \
		-I ${user} \
		-n ${team} \
		-V ${expire} \
		${HOME}/.ssh/id_ed25519.pub
	@ssh-keygen -Lf ${HOME}/.ssh/id_ed25519-cert.pub

genkey:
	@mkdir -p Users/${user}
	@ssh-keygen -t ed25519 -C ${user} -f Users/${user}/id_ed25519

signkey: fix-perm
	@ssh-keygen -s ${trusted-ca} \
		-I ${user} \
		-n ${team} \
		-V ${expire} \
		Users/${user}/id_ed25519.pub
	@ssh-keygen -Lf Users/${user}/id_ed25519-cert.pub

generate-trusted-root-ca:
	@ssh-keygen -t ed25519 -C "root-ca" -f ${trusted-ca}
	@chmod 0400 ${trusted-ca}

generate-trusted-host-cert:
	@ssh-keygen -t ed25519 -C "root-ca" -f TrustedHost/host_key

sign-trusted-host-cert: fix-perm
	@ssh-keygen \
		-s ${trusted-ca} \
		-h \
		-I ${remote-host}.vagrant.local \
		-n ${remote-host}.vagrant.local \
		-V ${host-cert-expire} \
		-z 1 \
		TrustedHost/host_key.pub
	@mv TrustedHost/host_key-cert.pub SignedHosts/${remote-host}-cert.pub
	@ssh-keygen -Lf SignedHosts/${remote-host}-cert.pub

clean:
	rm ~/.ssh/id_ed25519-cert.pub | true

reset:
	rm {TrustedCA,TrustedHost}/* | true

create-machine:
	vagrant up --provider=virtualbox

remove-machine:
	vagrant destroy -f

fix-perm:
	chmod 0400 TrustedCA/root-ca
	chmod 0400 TrustedHost/host_key
