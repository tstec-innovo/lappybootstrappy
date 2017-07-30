## LappyBootstrappy overview.

Project is broken up into 3 components: LappyBootstrappy, Dansible, and AnsibleContent.

* LappyBootstrappy:
  * Require configuration of Ansible Content repository.
  * Optionally configure repository private key for Ansible Content.
  * Gather user info including admin authentication credentials
  * Generate SSH keys.
  * Enable host machine SSH access with SSH public key.
  * Download / Update Dansible.
  * Initialize Dansible with SSH keys, admin credentials, and specified Ansible Content repo.
  * Start SSHd.
  * Run Dansible against localhost.
  * Stop SSHd.
* Dansible:
  * Install and run Docker.
  * Download / Update specified Ansible Content.
  * Initialize Ansible Content with admin credentials, SSH private key, and host machine's LAN IP.
  * Build Dansible Docker image.
* Ansible Content:
  * Update hosts with host machine's LAN IP.
  * Generate secrets file with given SSH private key and admin credentials.

## Known Issues / Needed Improvements

The su.expect script is hackey shite. I think expect is the right approach, but the author made it so it "just (barely) works".

ANSIBLE_CONTENT_SSH_KEY will not be used to authenticate in the case where another valid key (ex. the default id_rsa) is already loaded into ssh-agent.

## Author

[Neutron37](http://neutron37.com), 2017.

## Credits

Influenced by the following works:

* [ansible-macos-setup](wilsonmar/ansible-macos-setup) -- Wilson Mar
* [ansible-macbook](https://github.com/eduardodeoh/ansible-macbook]) -- Eduardo de Oliveira Hernandes
* [Mac Dev Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook) -- Jeff Geerlings
* [OSX-Post-Install-Script](https://github.com/ryanmaclean/OSX-Post-Install-Script) -- Ryan MacLean
* [thoughtbot/laptop](https://github.com/thoughtbot/laptop) (boostrapping, dev tools)
* [OSX for Hackers](https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716)
* [Mackup](https://github.com/lra/mackup)
