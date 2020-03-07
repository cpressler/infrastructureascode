keepalived
=========

ansible-keepalived: Ansible role for setting up keepalived

Requirements
------------

One virtual IP
Two hosts

You just need to provide an small amount of information to have it running

Add "keepalived" role to both hosts
Add variable keepalived_role: "master" | "slave" to the appropiate hosts
Add variable keepalived_shared_ip: "floating IP address" to both hosts
Other variables can be configured, overwriting defaults/main.yml

Keepalived can watch processes to influence on which node should be the master. Setting variable "keepalived_check_process" to the name of the process will do. I use keepalived to give high availability to haproxy, so I use.

keepalived_check_process: "haproxy"

Role Variables
--------------

keepalived_auth_pass: "1111"
keepalived_role: "MASTER"
keepalived_router_id: "52"
keepalived_shared_iface: "eth0"
keepalived_shared_ip: "192.168.74.1"
keepalived_check_process: "keepalived"
keepalived_priority: "100"
keepalived_backup_priority: "50"

Dependencies
------------

None

Example Playbook
----------------

- hosts: s1
  roles:
     - { role: keepalived, keepalived_shared_ip: "192.168.1.1", keepalived_role: "master" }

- hosts: s2
  roles:
     - { role: keepalived, keepalived_shared_ip: "192.168.1.1", keepalived_role: "slave" }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
