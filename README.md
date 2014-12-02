Quick and dirty [Vagrant](http://www.vagrantup.com/) envrionment for working on [Observium](http://www.observium.org).


## Usage
Assuming you already have virtualbox and vagrant installed...

1. git clone git://github.com/jda/vagrant-observium.git
2. cd vagrant-observium
3. set your observium subscription username in misc/svn.user
4. set your observium subscription password in misc/svn.passwd
5. vagrant up
6. check it out:
 * Browse to http://127.0.0.1:8080 and log in as admin with password admin
 * Or log in with ssh: vagrant ssh
