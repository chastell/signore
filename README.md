signore
=======

Email signature manager/randomiser.



Usage
-----

signore has two subcommands – `prego` and `pronto`, allowing you to retrieve and store signatures (respectively).

Retrieving signatures is done with `signore prego` and picks a signature at random based on the provided tags:

    $ signore prego tech
    // sometimes I believe compiler ignores all my comments
    $ signore prego tech
    You do have to be mad to work here, but it doesn’t help.
                                          [Gary Barnes, asr]

A tilde (`~`) before a tag means tag negation – i.e., it means that the returned signature cannot be tagged with the given tag:

    $ signore prego tech ~work ~programming
    Bruce Schneier knows Alice and Bob’s shared secret.
                                 [Bruce Schneier Facts]

Storing signatures is also quite simple; the tags can be provided as the parameters to the `signore pronto` command, and signore asks you about the various parts of the signature you might want to store (the source in this example is omitted); the signature is then displayed (formatted the way it will be when fetched with `signore prego`):

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



Properties
----------

Most `Signature`s have `text` and `tags`, some also have `author`, `source` and `subject`. Currently `tags` are used to query the sig database, while `author`, `source` and `subject` are combined into meta information displayed below the actual signature (right aligned and and in square brackets).



Storage
-------

signore stores the signatures in a YAML file (for ease of editing, if such a need arises) in `$XDG_DATA_HOME/signore/signatures.yml` (where `$XDG_DATA_HOME` is usually `~/.local/share`).



Requirements
------------

signore requires Ruby 1.9 and works best with Ruby 1.9.2 compiled with Psych (for sanity when hand-editing the YAML file, if it happens to sport non-US-ASCII characters).



---

© MMIX-MMX Piotr Szotkowski <chastell@chastell.net>, licensed under AGPL 3 (see LICENCE)
