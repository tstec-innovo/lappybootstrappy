## LappyBootstrappy overview.

I'd like this script to support MacOS, Linux, and BSD one day. For now it's only tested for MacOS Sierra.

Project is broken up into 3 components: LappyBootstrappy, Dansible, and AnsibleContent.

**Note:** Refactoring will be required to separate concerns as follows. Currently, most work is centralized in LappyBootStrappy.

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
* Dansible: The name is a portmanteau of Docker & Ansible. This approach ensures portability by providing a clean build of a fixed version of Ansible is running within a stable Docker-based environment.
  * Install and run Docker.
  * Download / Update specified Ansible Content.
  * Initialize Ansible Content with admin credentials, SSH private key, and host machine's LAN IP.
  * Build Dansible Docker image.
  * Mounts ansible_content/artifacts to the container so that dockerhost's secret ansible_content/artifacts/dansible_vault.password can be used.
* Ansible Content:
  * Update hosts with host machine's LAN IP.
  * Generate secrets file with given SSH private key and admin credentials.

## Known Issues / Needed Improvements

* ANSIBLE_CONTENT_SSH_KEY will not be used to authenticate in the case where another valid key (ex. the default id_rsa) is already loaded into ssh-agent.
* The script assumes the correct admin password has been supplied. Admin password should be checked immediately and the script should fail if not working.
* SSH known_hosts is not included on the Docker instance. For now, host_key_checking=False has been set in ansible config.
* IO redirection and pipes don't work in commands wrapped by expect (to be expected from expect).
* The su.expect script and wrapper "run_as" functions areound it are some hackey shite. I do think an 'expect' command is the right approach to enable only requiring the admin password to be entered once. It's available on the base-install of OSX and at-worst an easily available supported package on any linux/bsd distro. Still I've hacked on the script repeatedly until it just works. Some examples which may point to possible issues: The run_as_sudo function requires that full paths to binaries are passed, seems like environment isn't initializing for some reason.

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