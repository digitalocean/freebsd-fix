# freebsd-fix

This repo contains the fix broken FreeBSD images.

To run it:
1. Download a tarball from: https://github.com/digitalocean/freebsd-fix
2. Run:
```
cd /tmp
tar xvvf <tarballname>
sh apply_fix.sh
```
3. They need to completely power-off
4. Then power-back on

##

Side effects:

* This will install cloud-init
* The images must be configured for ConfigDrive. Please ping @bh for customer snapshots.
* This makes FreeBSD snapshot-safe
* It upgrade-proofs the droplet
* It fixes our mistake in using a custom /etc/rc.digitalocean.d directory

