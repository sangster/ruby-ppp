Ruby PPP
========

Introduction
------------

At [grc.com/ppp.htm](http://www.grc.com/ppp.htm) Steve Gibson describes asystem for generating one-time passcodes. The
rational for such a sytem is given:

> The trouble with a username and password is that they never change. We create them, write them down or memorize them,
> then use them over and over again. What has been needed is an inexpensive system that provides something which
> changes everytime it is used. GRC's Perfect Paper Passwords system offers a simple, safe and secure, free and well
> documented solution that is being adopted by a growing number of security-conscious Internet facilities to provide
> their users with state-of-the-art cryptographic logon security.

John Graham-Cumming has provided an [open-source implementation](http://www.jgc.org/blog/pppv3-c.zip) of this system in
C, released under the BSD license.

This gem is a ruby interface to that C implementation.

Warning!
--------

This gem is still in alpha, so it may not even work at all. **Use at your own risk!**

Usage
-----


### Code Generator ###

The only required object to begin generating one-time passcodes is `Ppp::Generator`. A generator can be created with:

    code_gen = Ppp.code_generator '17d08c38930b084789cd389fafa85d4d8d01472bb4fb3ca7813e3b035b310f00'

Then you can start creating as many codes as you like:

    offset        = 0
    num_to_create = 5
    code_gen.passcodes offset, num_to_create # => ["uZ:K", "avNC", "B:6@", "Utqh", "+buY"]

Generators are "seeded" with a given 64 hex-digit string representation of a SHA-256 hash
(`17d08c38930b084789cd389fafa85d4d8d01472bb4fb3ca7813e3b035b310f00` in the given example). Two generators seeded with
the same SHA-256 hash will always create the same series of passcodes (assuming they are both set to create passcodes
of the same length of course). Likewise, the same generator will create the exact same passcodes if called with the
same offset multiple times:

    code_gen.passcodes 10, 3 # => ["uNs2", "zWuL", "y4wz"]
    code_gen.passcodes 10, 2 # => ["uNs2", "zWuL"]

If you can to verify that a given passcode (say, from a user) is correct, you just need the index of the expected
passcode:

     code_gen.verify 11, 'zWuL' # => true


#### Generating seeds ####

You can provide any seed you want when creating a generator, but there are two helper methods to create them for you:

- `Ppp.random_key` will return a random SHA-256 hash based off junk like the current time and your computer's
  current CPU usage.
- `Ppp.key_from_string( 'my string' )` will return a SHA-256 hash of the given string.


#### Options ####

Generators have two optional parameters:

- `:length`   The number of characters in each generated passcode.
- `:alphabet` Either a `Symbol` matching a pre-defined alphabet (See `Ppp.default_alphabets`) or a `String`. The
  alphabet lists the characters in which generated passcodes will be comprised of.

##### Example #####
    cg = Ppp.code_generator Ppp.key_from_string('test'), :length => 8, :alphabet => 'abc123'
    cg.passcodes 0, 5 # => ["2a3b2223", "b3cc21cc", "122133ba", "a1aaccb3", "cabaa2ca"]


### Cards ###

a
