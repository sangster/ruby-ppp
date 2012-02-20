Ruby PPP
========

Introduction
------------

At grc.com/ppp.htm Steve Gibson describes a system for generating one-time passcodes. The rational for such a sytem is
given:

> "The trouble with a username and password is that they never change. We create them, write them down or memorize them, then
> use them over and over again. What has been needed is an inexpensive system that provides something which changes everytime
> it is used. GRC's Perfect Paper Passwords system offers a simple, safe and secure, free and well documented solution that
> is being adopted by a growing number of security-conscious Internet facilities to provide their users with state-of-the-art
> cryptographic logon security."

John Graham-Cumming has provided an open-source implementation of this system in C (http://www.jgc.org/blog/pppv3-c.zip),
released under the BSD license.

This gem is a ruby interface to that C implementation.

Warning!
--------

This gem is still in alpha, so it may not even work at all. **Use at your own risk!**
