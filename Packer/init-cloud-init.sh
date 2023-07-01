#! /bin/bash

echo "[+] Extracting Vault Secrets"
printf "[?] Login to Vault? [y/N]"
read vault_login
if [[ $vault_login == "y" ]]; then
    vault login
fi
seclab_user=$(vault kv get -field=seclab_user seclab/seclab)
seclab_pw=$(vault kv get -field=seclab_password seclab/seclab)
encrypted_pw=$(openssl passwd -6 $seclab_pw)
echo "[+] Adding encrypted secret to user-data files"
for f in $(find ./ -name user-data); do
    sed -i "s/SECLAB_USER/$seclab_user/g" $f
    sed -i "s/SECLAB_PASSWORD/$encrypted_pw/g" $f
done
exit 0