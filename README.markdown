# Gem in a Box Secure

![screen shot](http://i.imgur.com/FS9lw.png)

## Really simple secure rubygem hosting

Gem in a Box Secure is a very basic branch of the awesome [Gem in a box][geminabox] - a simple [sinatra][sinatra] app to allow you to host your own in-house gems. The main difference here is the secure flavor provides configurable forced SSL and HTTP basic auth.

## Server Setup

    gem install geminabox-secure

Create a config.ru as follows:

    require "rubygems"
    require "geminabox-secure"

    GeminaboxSecure.data = "/var/geminabox-data" # …or wherever
	GeminaboxSecure.force_ssl = true #if you want SSL redirects enabled
    run GeminaboxSecure

Set environment variables for your username and password: GEMBOX_USER and GEMBOX_PASSWORD, respectively. Gem in a Box Secure defaults to "admin" and "s3cret" respectively if these are not set.

Set up your SSL certificates for your server of choice. 

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
