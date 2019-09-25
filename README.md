# Hardened AWS AMI Images

## Build
* define a profile (e.g. `sandbox`) in your `~/.aws/credentials` file
* run this: `packer build -var 'profile=sandbox' amzn-linux2.json`

## Test sshd config
```
wget https://raw.githubusercontent.com/arthepsy/ssh-audit/master/ssh-audit.py
python ./ssh-audit.py $(curl -L 169.254.169.254/latest/meta-data/local-ipv4)
```
## Test with AWS Inspector
....
