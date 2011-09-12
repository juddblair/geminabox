# Gem in a Box Secure

![screen shot](http://i50.tinypic.com/2yknxnr.png)

## Really simple secure rubygem hosting

Gem in a Box secure is a very basic branch of the awesome [Gem in a box][geminabox] - a simple [sinatra][sinatra] app to allow you to host your own in-house gems. The main difference here is the secure flavor provides forced SSL and HTTP basic auth.

## Server Setup

    gem install geminabox-secure

Create a config.ru as follows:

    require "rubygems"
    require "geminabox-secure"

    GeminaboxSecure.data = "/var/geminabox-data" # …or wherever
    run GeminaboxSecure

Set environment variables for your username and password: GEMBOX_USER and GEMBOX_PASSWORD, respectively. 

Set up your SSL certificates.

And finally, hook up the config.ru as you normally would ([passenger][passenger], [thin][thin], [unicorn][unicorn], whatever floats your boat).


## Client Usage

    gem install geminabox-secure

    gem inaboxsecure pkg/my-awesome-gem-1.0.gem

Simples!

## Licence

Fork it, mod it, choose it, use it, make it better. All under the [do what the fuck you want to + beer/pizza public license][WTFBPPL].

[geminabox]: http://tomlea.co.uk/posts/gem-in-a-box/
[WTFBPPL]: http://tomlea.co.uk/WTFBPPL.txt
[sinatra]: http://www.sinatrarb.com/
[passenger]: http://www.modrails.com/
[thin]: http://code.macournoyer.com/thin/
[unicorn]: http://unicorn.bogomips.org/
