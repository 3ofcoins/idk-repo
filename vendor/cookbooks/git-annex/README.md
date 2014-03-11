git-annex cookbook
==================

This cookbook installs [git-annex](http://git-annex.branchable.com/)
on Debian, Ubuntu, and MacOS.

This cookbook's home is at https://github.com/3ofcoins/chef-cookbook-git-annex/

Requirements
------------

 - `dmg` (used only on Mac)
 - `apt` (used only on Ubuntu 12.04 to add PPA)

Usage
-----

Add `recipe[git-annex]` to your run list. You may want to add
`recipe[git]` as well, git-annex is pretty much useless without Git.

Author
------

Author:: Maciej Pasternacki <maciej@3ofcoins.net>
