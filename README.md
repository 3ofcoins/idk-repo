> **Disclaimer:** This software is alpha. We want it to be as easy and
> straightforward to use as possible, but can't promise anything. You
> have been warned.

The IDK Repository
==================

This repository is [Three of Coins'](http://3ofcoins.net/) take on
a usable base [Chef](http://www.opscode.com/chef/) repository. While
Opscode provides
a [barebone empty repository](https://github.com/opscode/chef-repo/),
it is completely blank slate; it's not so easy to get from there to
a running environment, and it's even harder to collect all the
community software and best practices, and incorporate them by trial
and error.

The IDK Repository is an opinionated Chef repo. It includes
a set of tools, scripts, and cookbooks that we have found to gather
all over again. Its aim is to provide a ready to use infrastructure
development environment, already including tools, skeleton setup, and
instructions to get up and running.

While The IDK Repository may run with manually installed software, it
is recommended to use
[Infrastructure Development Kit](https://github.com/3ofcoins/idk/releases)
as your client software.

Getting started
---------------

Install latest version of
[the Infrastructure Development Kit](https://github.com/3ofcoins/idk/releases). Run
`idk setup` to set up IDK itself. Run `thor repo:bootstrap` in this
repository's checkout to get yourself started.
  
