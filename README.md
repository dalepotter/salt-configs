# Salt States

This is a repo for handy Salt States.


## What is Salt?

The following tutorials give an overview of Salt and its setup :

- TalPor Solitions - [Salt - Beginners Tutorial](https://blog.talpor.com/2014/07/saltstack-beginners-tutorial/)
- Digital Ocean - [How To Create Your First Salt Formula](https://www.digitalocean.com/community/tutorials/how-to-create-your-first-salt-formula)
- Saltier - [Salt in 60 seconds](http://www.saltstat.es/posts/quickstart.html)
- PyCon Australia talk - [Salt: How to be Truly Lazy] (https://www.youtube.com/watch?v=-abRRUK19lE)


## Installation

### Overview

It is assumed that the states in this repository will be deployed using [salt-ssh](https://docs.saltstack.com/en/latest/topics/ssh/).  Similar commands can be used under a Salt master/minion relationship. A quickstart guide is available for [setting up a Salt master and minion](http://www.barrymorrison.com/2013/Mar/13/setting-up-a-salt-master-and-minion/).


### Installing salt-ssh

The offical Salt website gives an overview of [salt-ssh](https://docs.saltstack.com/en/latest/topics/ssh/).

On a Mac, Salt can be installed using Brew:

```
brew install saltstack
```

### Setting up the server roster

A roster file defines the name and IP address for each server accessible using Salt.

```
sudo echo "SERVER_NAME: [IP OF SERVER]" >> /etc/salt/roster
```

This roster file can be stored at an alternative location, if set in the [Salt configuration file](https://docs.saltstack.com/en/latest/topics/ssh/#configuring-salt-ssh) (i.e. `/etc/salt/master`, under `roster_file`).

It may be necessary to add a public key to each server to enable access.


## Using Salt

Once a roster is defined, Salt can be used to remotely execute commands on the target server:

```
sudo salt-ssh '*' test.ping
sudo salt-ssh '*' cmd.run 'date'
```

Note the use of `sudo`. The Salt documentation gives some thoughts on running [salt-ssh as non-root user](https://docs.saltstack.com/en/latest/topics/ssh/#running-salt-ssh-as-non-root-user).


### Running states in this repository

By default, Salt assumes that `.sls` states are stored in `/srv/salt`, however this can again be modified in the [Salt configuration file](https://docs.saltstack.com/en/latest/topics/ssh/#configuring-salt-ssh) (i.e. `/etc/salt/master`, under `file_roots`).

This repo assumes `file_roots` is configured to run from a 'my documents' type folder:

```
git clone https://github.com/dalepotter/saltstates.git
# Edit /etc/salt/master to set file root accordingly
```

From here, it should be possible to run:

- Individual states using: `sudo salt-ssh '*' state.sls nano`
- [More examples to follow]
