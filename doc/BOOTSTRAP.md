Bootstrapping the infrastructure
================================

This assumes that the working repository is already initialized, as
described in [README.md](../README.md).

Chef Server / Headquarters
--------------------------

1. Have the server for HQ ready, and with DNS name configured
2. Copy whole content of the repository to the server:

    $ ssh chef.i.example.com mkdir foundation
    $ git archive HEAD | gzip | ssh chef.i.example.com tar -C foundation/ -xzv
    
3. On the server, as root:

    # cd foundation/config/bootstrap
    # ./configure --with-chef-server NAME=headquarters SERVER_FQDN=chef.example.com
    # chef-server-ctl test
    
3. Copy following files from Chef server to `.chef` directory on the
   workstation:
   
   - `/etc/chef-server/chef-validator.pem`
   - `/etc/chef-server/chef-webui.pem`
   - `/etc/chef-server/admin.pem`
   
4. Create your own user:

    $ bundle exec knife client create MY_USERNAME --key .chef/admin.pem --user admin --admin --file .chef/client.pem
    $ bundle exec knife status

5. **WTF?** Delete admin user? Or not? What are "users" and how are they
   different from "clients?

6. Upload cookbooks etc

   $ thor repo:upload

7. Update run list

    $ bundle exec knife node run list add headquarters 'role[__base]'

8. Re-run chef-client

    # mkdir /var/cache/chef # <- this shouldn't be necessary
    # chef-client -S https://chef.example.com/ -N headquarters
    # chef-client # <- to see if client.rb is fine

TODOs
-----

 - Automate much of the above
 - Mergeable branch shouldn't finclude vendored stuff or
   Gemfile/Berkshelf lockfiles
   - should /vendor and *.lock be soft-gitignored (in .git directory)?
   - hidden task `thor foundation:developer_mode` to ignore what is to
     be ignored
   - we also shouldn't have vendorificator's tags & branches pushed to
     foundation repo itself
     - its place is in the implementation (now it's `ronja.git`, it
       will probably be `infrastructure.git`)
   - bootstrap tasks should then require running `vendor sync`

