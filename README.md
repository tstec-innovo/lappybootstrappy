## Known Issues / Needed Improvements

The su.expect script is hackey shite. I think expect is the right approach, but the author made it so it "just (barely) works".

ANSIBLE_CONTENT_SSH_KEY will not be used to authenticate in the case where another valid key (ex. the default id_rsa) is already loaded into ssh-agent.

## Terminology

### Stages of configuration management.

* *Build:* Build isos, containers, images.
* *Provision:* Provision builds to instances (metal or virtual).
* *Equip:* Configure and reconfigure instances.

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
