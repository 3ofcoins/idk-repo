Configuration
=============

Shared, global configuration lives in ``config/`` subdirectory. Most of
configuration can be provided in multiple files, to avoid merge
conflicts when main configuration file lives in original, pure
foundation repository.

Files in the ``config/`` directory should contain values that are shared
among users, and are safe to check into Git repository.

Custom configuration and secrets that should not be in the Git
repository should live in ``.chef/`` subdirectory (which was created on
``thor repo:setup``). Managing and sharing the secrets is one of future
features of the Foundation Repository.

Shared config
-------------

Foundation provides shared configuration for different Ruby-based
components. It is read from following files, in order:

``config/foundation.rb``
  Main shared configuration.
``config/foundation-*.rb``
  You can put detailed shared configuration in separate files, to
  avoid merge conflicts.
``.chef/foundation.rb``
  Main custom configuration (not checked into repository).
``.chef/foundation-*.rb``
  Detailed custom configuration (not checked into repository).

Configuration variables are plain Ruby. If you are familiar with Chef
configuration files (like ``knife.rb``, ``client.rb`` or ``server.rb``),
you'll feel at home -- the same library (``mixlib-config``) is used by
Foundation. Syntax for setting the variables is simple, for example:

.. code-block:: ruby

   domain "example.com"
   custom_email "#{username}@#{domain}" # uses the default username

Available settings
''''''''''''''''''

``root_dir``
  Initially set to full path of root of the repository. It is not wise
  to change it, but it can be read.
``domain``
  DNS domain of your project (without the leading "``i.``").
``username``
  Shell username of current user. Defaults to username configured in
  SSH config for ``whatever.i.*domain*`` host, or to current user login
  name. If your login name on the development machine is different
  from your login name on the servers, it is simpler to configure it
  in ``~/.ssh/config`` for the domain rather than in Foundation's
  configuration.
``opscode_organization``
  Name of organization, if you use Opscode Hosted Chef
``opscode_username``
  Your username for Opscode Hosted Chef. If unset, ``chef_username`` is
  used.
``chef_username``
  Your username (node name, client name) for accessing Chef server. If
  unset, ``username`` is used.

You can also set and reuse in other places any other variables;
configuration variable names are not validated against any list.

Accessing config
''''''''''''''''

.. code-block:: ruby

   require 'foundation/config'
   Foundation::Config[:name_of_variable]
   Foundation::Config.path('relative/path') # given path relative to repository root, returns the full path
   Foundation::Config.config_files(basename, ext='rb') # RTFS

Knife
-----

Main knife configuration file (symlinked as ``.chef/knife.rb`` by ``thor
repo:setup``) contains sensible defaults and includes other files. It
is located in ``lib/config/knife.rb``. Default settings can be further
customized in knife configuration files in layout similar to
``foundation.rb``:

 - ``config/knife.rb``
 - ``config/knife-*.rb``
 - ``.chef/knife-*.rb``
