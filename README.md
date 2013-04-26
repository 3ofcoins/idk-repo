> **Disclaimer:** This software is alpha. We want it to be as easy and
> straightforward to use as possible, but can't promise anything. You
> have been warned.

The Foundation Repository
=========================

This repository is [Three of Coins'](http://3ofcoins.net/) take on
a usable base [Chef](http://www.opscode.com/chef/) repository. While
Opscode provides
a [barebone empty repository](https://github.com/opscode/chef-repo/),
it is completely blank slate; it's not so easy to get from there to
a running environment, and it's even harder to collect all the
community software and best practices, and incorporate them by trial
and error.

The Foundation Repository is an opinionated Chef repo. It includes
a set of tools, scripts, and cookbooks that we have found to gather
all over again. Its aim is to provide a ready to use infrastructure
development environment, already including tools, skeleton setup, and
instructions to get up and running.

What you need
=============

 - Git
 - Ruby 1.9.3 with Rubygems and Bundler (rvm or rbenv is recommended)
 - VirtualBox and Vagrant
 - Python 2.6+ (to generate Sphinx documentation)
 - GNU Autoconf 2.69+ (optional, to regenerate bootstrap configuration
   script if needed)
