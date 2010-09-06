signore
=======

Email signature manager/randomiser.

Usage
-----

signore has two subcommands – `prego` and `pronto`, allowing you to retrieve and store them (respectively).

Retrieving signatures is done with `signore prego` and picks a signature at random based on the provided tags:

    $ signore prego tech
    // sometimes I believe compiler ignores all my comments
    $ signore prego tech
    You do have to be mad to work here, but it doesn’t help.
                                          [Gary Barnes, asr]

Storing signatures is also quite simple; the tags can be provided as the parameters to the `signore pronto` command, and signore asks you about the various parts of the signature you might want to store:

    $ signore pronto literature
    text?
    Transported to a surreal landscape, a young girl kills the first person she meets and then teams up with three strangers to kill again.
    
    author?
    Rick Polito
    
    subject?
    on The Wonderful Wizard of Oz
    
    source?
    
    Transported to a surreal landscape, a young girl kills the first
    person she meets and then teams up with three strangers to kill again.
                               [Rick Polito on The Wonderful Wizard of Oz]

Storage
-------

signore stores the signatures in a YAML file (for ease of editing, if such a need arises) in `$XDG_CONFIG_HOME/signore/signatures.yml` (where `$XDG_CONFIG_HOME` is usually `~/.config`).

---

© MMIX-MMX Piotr Szotkowski <chastell@chastell.net>, licensed under AGPL 3 (see LICENCE)
