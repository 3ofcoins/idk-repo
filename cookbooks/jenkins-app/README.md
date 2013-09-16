Jenkins app cookbook
====================

This is the application cookbook that configures Jenkins continuous
integration server within the Foundation Repo framework.

Jenkins is configured to run behind an Apache proxy, SSL-protected,
and authenticated by Odin Auth.

To use the Odin authentication, you need to install the
[Reverse Proxy Auth plugin](https://wiki.jenkins-ci.org/display/JENKINS/Reverse+Proxy+Auth+Plugin),
and in the "Manage Jenkins | Global Security" page:

 - check the _Enable security_ box,
 - select the _HTTP Header by reverse proxy_ option, and
 - set _Header name_ to "OdinAuth-User".
