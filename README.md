# Home Assistant Add-on Hashicorp Vault

### Summary

Launch an Hashicorp vault server in raft mode. 
It uses using the default ssl key from /ssl if it exists or launch it in insecure http mode if not.
TLS can be disabled by setting "disable_tls" to true.

### enable the cluster
Cluster addr is set to localhost by default. 
Set it to a valid address through 'vault_cluster_addr' then enable the port forward for tcp/8201 (provide a value for the port)

### custom the configuration
The config can be changed in /config/vault/vault.hcl
or you can use vault_local_config (see https://hub.docker.com/_/vault)
The raft data is stored in /data/vault/raft, it'll be removed if you remove the addon. (You can change that by setting it to /config/vault/raft in the vault.hcl file)

### Use AWS KMS for autounseal
You can set the following values:
```bash
aws_unseal: true
aws_region: eu-west-1
aws_access_key: *****
aws_secret_key: ******
aws_kms_key_id: ******
```

You'll need to create the kms key and the iam user credentials with correct policy (kms:Encrypt,kms:Decrypt and kms:DescribeKey)
