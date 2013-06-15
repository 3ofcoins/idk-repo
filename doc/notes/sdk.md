# Software Development Kit

> This is not documentation, these are "what-if" notes to figure out
> how to build an easily installable SDK for Foundation.

The _Foundation SDK_ is a one-click
[Omnibus](https://github.com/opscode/omnibus-ruby/) package that
contains all software needed for the workstation to run - either
inside, or as a chef-solo setup script to install stuff globally. This
would mean that the following should be available after the
installation and boostrap:

 - A blessed, self-contained Ruby installation with rubygems &
   bundler. Rubygems should be writable by end user to support running
   `bundle` instead of having to upgrade the SDK itself too often. It
   should still include basic gems, needed to bootstrap, and needed
   C libraries. 
 - Maybe RVM to support gemsets and sharing the SDK between
   projects. The pre-built Ruby would be mounted in RVM and used by
   default. It may make more sense to set `GEM_HOME` and `GEM_PATH`,
   and have gemsets-like functionality without whole RVM burden.
 - A single point of entry command to run infrastructure-related
   commands and scripts[^1]. It would set all the Ruby, Rubygems,
   Python, path, etc. stuff, and then run command or Thor task.
 - Ruby+C, Python development environment
 - Pygments
 - Git
 - Virtualenv + Vagrant
 - Autoconf
 - GPG

It may make sense to install some of these (like `build-essential`,
Git, or Virtualenv+Vagrant) in runtime by chef-solo rather than
include it in the SDK itself. It may make sense to install
e.g. homebrew on a Mac.

The SDK should ensure that everything is installed and configured
correctly. This includes making sure that user's GPG and SSH key is
installed, that SSH key is passphrase-protected, that ssh-agent is
running.

[^1]: Is it polite to use a one-letter entry point command? It would
      be cool to have the command named `i` after _infrastructure_,
      and parallel to the _`.i` subdomain pattern_.
