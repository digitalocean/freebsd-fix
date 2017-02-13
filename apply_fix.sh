#!/bin/sh

cd $(dirname ${0})
echo "Copying scripts"
cp -av fix/digitalocean* /usr/local/etc/rc.d

cat <<EOM
Installing new packages to fix this droplet:
- cloud-init: for handling per-cloud instance
- jq: for reading DigitalOcean meta-data
EOM

pkg update -f
pkg install net/cloud-init py27-cheetah jq

echo "Applying DigitalOcean configuration"
mkdir -p /usr/local/etc/cloud/cloud.cfg.d
cp -av fix/99-digitalocean.cfg /usr/local/etc/cloud/cloud.cfg.d


echo "Updating /etc/rc.conf"
grep -v ifconfig /etc/rc.conf > /tmp/rc.conf
cat > /etc/rc.conf <<EOM

# Added by DigitalOcean repair script
cloudinit_enable="YES"
digitaloceanpre="YES"
digitalocean="YES"

$(cat /tmp/rc.conf)
EOM

echo "Populating CloudInit droplet Configuration"
instanceid=$(kenv -q smbios.system.uuid)
instance_d="/var/lib/cloud/instances/${instanceid}"
mkdir -p ${instance_d}/sem
ln -sF ${instance_d} /var/lib/cloud/instance
for i in locale rightscale_userdata scripts_user ssh _users_groups phone_home runcmd seed_random ssh_authkey_fingerprints data power_state_change  scripts_per_instance set_hostname ssh_import_id;
do
    touch ${instance_d}/sem/config_$i
done

cat <<EOM
Please power-off your droplet and power it back on
Upon power-on, the droplet will use CloudInit.
EOM
