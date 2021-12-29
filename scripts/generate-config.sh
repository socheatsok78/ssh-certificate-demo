#!/usr/bin/env bash

function indent () {
    local string="$1"
    local num_spaces="$2"

    printf "%${num_spaces}s%s\n" '' "$string"
}

trusted_user_ca_keys=`cat TrustedCA/root-ca.pub`
ssh_host_rsa_key=`cat TrustedHost/host_key`
host_key_cert=`cat TrustedHost/host_key-cert.pub`

cloud_config=$(cat <<EOF
#cloud-config

write_files:
  # TrustedCA/root-ca.pub
  - path: /etc/ssh/trusted-user-ca-keys.pem
    content: |
      $(indent $trusted_user_ca_keys 4)

  # TrustedHost/host_key
  - path: /etc/ssh/ssh_host_rsa_key
    content: |
      ${ssh_host_rsa_key}

  # TrustedHost/host_key-cert.pub
  - path: /etc/ssh/ssh_host_rsa_key-cert.pub
    content: |
      ${host_key_cert}

  - path: /etc/ssh/sshd_config.d/00-vault-config.conf
    content: |
      # For client keys
      TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem

      # For host keys
      HostKey /etc/ssh/ssh_host_rsa_key
      HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub
EOF
)

echo "$cloud_config"
