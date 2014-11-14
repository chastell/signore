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



Application
-----------

One of the ways to use signore is teaching your old email editor new tricks. If you happen to be a [Vim](http://www.vim.org/) user, the following will delete the current signature and replace it with a random one on every `,ss` sequence:

    map ,ss  G?^-- $<CR><Down>dG:r! signore prego<CR>Go<CR><CR><Esc>

Of course you can pass any tags to the command – so if you’re often writing emails to a technical mailing list, you might want to be able to use, say, `,stt` to get a signature tagged with ‘tech’:

    map ,stt G?^-- $<CR><Down>dG:r! signore prego tech<CR>Go<CR><CR><Esc>

This can be helpful if you happen to send emails in different languages and want the signature to be actually readable by the recipient. If you tag all your signatures with the right language, the following will allow you to press `,sp` to get a signature in Polish and `,se` to get a signature in English:

    map ,sp  G?^-- $<CR><Down>dG:r! signore prego pl<CR>Go<CR><CR><Esc>
    map ,se  G?^-- $<CR><Down>dG:r! signore prego en<CR>Go<CR><CR><Esc>

Finally, remember that tags can be combined and negated – and so if you often write to non-technical people who prefer Polish, the following will make sure that `,slp` will generate a proper signature (assuming all your Polish signatures are tagged with ‘pl’ and all your technical ones are tagged with ‘tech’):

    map ,slp G?^-- $<CR><Down>dG:r! signore prego pl ~tech<CR>Go<CR><CR><Esc>

Another aproach would be to create a named pipe that your email program reads from, and run `signore prego` on every read.



Properties
----------

Most `Signature`s have `text` and `tags`, some also have `author`, `source` and `subject`. Currently `tags` are used to query the sig repository, while `author`, `source` and `subject` are combined into meta information displayed below the actual signature (right aligned and and in square brackets).

The `text` of the `Signature`s is wrapped to 80 characters or fewer upon display (separately for every line). Additionally, if the result is two lines, signore attempts to make them roughly the same length. The wrapping engine also attempts to avoid one-letter words at ends of lines (moving them to the next line if possible).



Storage
-------

signore stores the signatures in a YAML file (for ease of editing, if such a need arises) in `$XDG_DATA_HOME/signore/signatures.yml` (where `$XDG_DATA_HOME` is usually `~/.local/share`).



Requirements
------------

signore requires Ruby 1.9 and works best with Ruby 1.9.2 compiled with Psych (for sanity when hand-editing the YAML file, if it happens to sport non-US-ASCII characters).



---

© MMIX-MMXIV Piotr Szotkowski <chastell@chastell.net>, licensed under AGPL-3.0 (see LICENCE)
