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
- - - - - - - - -
**Note:** See the "Cards" section below for a more convenient interface!
- - - - - - - - -

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

- `:length`   The number of characters in each generated passcode. Default: `4`
- `:alphabet` Either a `Symbol` matching a pre-defined alphabet (See `Ppp.default_alphabets`) or a `String`. The
  alphabet lists the characters in which generated passcodes will be comprised of. Default: `:conservative`

##### Example #####
    cg = Ppp.code_generator Ppp.key_from_string('test'), :length => 8, :alphabet => 'abc123'
    cg.passcodes 0, 5 # => ["2a3b2223", "b3cc21cc", "122133ba", "a1aaccb3", "cabaa2ca"]


### Cards ###

Generating lists of one-time passcodes is all well and fine, but the goal here is to print out "cards" of passcodes
which can be held on your person. In your wallet for example.

Currently there are three types of cards you can choose from (hopefully PDFs to be added soon): 

- Plain text (`:plain`)
- HTML (`:html`)
- XML (`:xml`)

To create a card, all you need is the type of card and a `Generator`:

    generator = Ppp.code_generator Ppp.key_from_string( 'hi' )
    card      = Ppp.card :plain, generator
    card.to_s # => |----------------------------------------|
                   | PPP Passcard                       [1] |
                   |----+----+----+----+----+----+----+-----|
                   |      A    B    C    D    E    F    G   |
                   |  1: xvL3 =6rA J!dc ji36 Mm!H XF#W Z6cv |
                   |  2: FhdA wiu3 v#iJ FkZB WFwm LR?= coza |
                   |  3: CFtT !qWB vyTM vL@V q#PH Cf=a H5y% |
                   |  4: c8Bq C!7q MZkL aN4k W=Xq 7CGr DnJv |
                   |  5: 54#@ 5ei+ 6EKB 5Y:# ?+vY e4K2 3Dh6 |
                   |  6: rTxM jmt4 Hcxj vyTG ZX@f FBHg D+aY |
                   |  7: 42Fp euUu G!f! c5Wy 4nbV Ff9r 5MSc |
                   |  8: a4em ?#MM =B4: Nxme 26!G 7%7F Cv9m |
                   |  9: 2kpA FVDF LMmo Ts8e Fe+j n!ox %:Ym |
                   | 10: t3nh vepZ MhJq :Ps3 +Fph vxz# X=FV |
                   |----+----+----+----+----+----+----+-----|

You can get the passcode for a given cell in the card using one of the following:

    card.passcode 10, 'B' # => "vepZ"
    card.passcode '10B' # => "vepZ"

Or verify a given passcode with one of the following:

    card.verify 10, 'B', 'wrong pass' # => false
    card.verify '10B', 'vepZ' # => true

In the top-right corner of the above example card, you can see the card number: `[1]`. Once all the codes have been used
up from a card, you can just print out another one:

    card.card_number = 2
    card.to_s # => |----------------------------------------|
                   | PPP Passcard                       [2] |
                   |----+----+----+----+----+----+----+-----|
                   |      A    B    C    D    E    F    G   |
                   |  1: d=d% rBgr TL+d Nk42 8B8G b:5N F?8S |
                   |  2: BqUf nayC unhH oipF 5sHy %:k2 FEeC |
                   |  3: %P#n NNDM wPmg 9N#Y EWr2 5e7j 4rN# |
                   |  4: 7N=5 7y2d bK!b PRHr :VEk hp!G 9dah |
                   |  5: ovLN ReU? 2uon WD#P whPW iNzV WLq2 |
                   |  6: f!Cc =%Bx iSTt 95MF d!6a %NCE ewnP |
                   |  7: @jnE p27k NhKU dXFE caBF %!4H zhDR |
                   |  8: yBVf ACox F7Wb u@kr CtFF uZSe MRtb |
                   |  9: !%:6 oMRD LeRV eP#n iKKB Jxfy E5k8 |
                   | 10: mJKG mYPd wi#K @:V3 6zen EFXJ 5dKA |
                   |----+----+----+----+----+----+----+-----|

#### Options ####

Each type of card has its own optional parameters, but they all have the following:

- `:card_title`        Some `String` to put at the head of each card. Default: `PPP Passcard`
- `:row_count`         The number of rows to print on the card. Default: `10`
- `:first_card_number` The number of the first card. Default: `1`
