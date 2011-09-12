Gem::Specification.new do |s|
  s.name              = 'geminabox-secure'
  s.version           = '0.3.1'
  s.summary           = 'Really simple secure rubygem hosting'
  s.description       = 'Gem in a box with basic HTTP authentication and forced SSL, designed for use on Heroku or other cloud-based hosting services'
  s.author            = 'Judd Blair'
  s.email             = 'judd+contrib@euclidelements.com'
  s.homepage          = 'http://tomlea.co.uk/p/gem-in-a-box'

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w[README.markdown]
  s.rdoc_options      = %w[--main README.markdown]

  s.files             = %w[README.markdown] + Dir['{lib,public,views}/**/*']
  s.require_paths     = ['lib']

  s.add_dependency('sinatra')
  s.add_dependency('builder')
  s.add_dependency('rack-ssl-enforcer')
end
