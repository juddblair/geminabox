require "digest/md5"
require "builder"
require 'sinatra/base'
require 'rubygems'
require 'rubygems/builder'
require "rubygems/indexer"

require 'hostess'

require 'rack-ssl-enforcer'


class GeminaboxSecure < Sinatra::Base
  enable :static, :methodoverride

  set :public, File.join(File.dirname(__FILE__), *%w[.. public])
  set :data, File.join(File.dirname(__FILE__), *%w[.. data])
  set :views, File.join(File.dirname(__FILE__), *%w[.. views])
  set :allow_replace, false
  set :force_ssl, false
  
  use Hostess
  
  #defaults for SSL and basic HTTP Auth
  if settings.force_ssl
    use Rack::SslEnforcer
  end
  sec_user = ENV['GEMBOX_USER'].nil? ? 'admin' : ENV['GEMBOX_USER']
  sec_pw = ENV['GEMBOX_PASSWORD'].nil? ? 's3cret' : ENV['GEMBOX_PASSWORD']
  
  #setup HTTP Auth
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [sec_user,sec_pw]
  end

  class << self
    def disallow_replace?
      ! allow_replace
    end
  end

  autoload :GemVersionCollection, "geminabox-secure/gem_version_collection"

  get '/' do
    @gems = load_gems
    @index_gems = index_gems(@gems)
    erb :index
  end

  get '/atom.xml' do
    @gems = load_gems
    erb :atom, :layout => false
  end

  get '/upload' do
    erb :upload
  end

  delete '/gems/*.gem' do
    File.delete file_path if File.exists? file_path
    reindex
    redirect "/"
  end

  post '/upload' do
    return "Please ensure #{File.expand_path(GeminaboxSecure.data)} is writable by the geminabox web server." unless File.writable? GeminaboxSecure.data
    unless params[:file] && (tmpfile = params[:file][:tempfile]) && (name = params[:file][:filename])
      @error = "No file selected"
      return erb(:upload)
    end

    tmpfile.binmode

    Dir.mkdir(File.join(settings.data, "gems")) unless File.directory? File.join(settings.data, "gems")

    dest_filename = File.join(settings.data, "gems", File.basename(name))


    if GeminaboxSecure.disallow_replace? and File.exist?(dest_filename)
      existing_file_digest = Digest::SHA1.file(dest_filename).hexdigest
      tmpfile_digest = Digest::SHA1.file(tmpfile.path).hexdigest

      if existing_file_digest != tmpfile_digest
        return error_response(409, "Gem already exists, you must delete the existing version first.")
      else
        return [200, "Ignoring upload, you uploaded the same thing previously."]
      end
    end

    File.open(dest_filename, "wb") do |f|
      while blk = tmpfile.read(65536)
        f << blk
      end
    end
    reindex
    redirect "/"
  end

private

  def error_response(code, message)
    html = <<HTML
<html>
  <head><title>Error - #{code}</title></head>
  <body>
    <h1>Error - #{code}</h1>
    <p>#{message}</p>
  </body>
</html>
HTML
    [code, html]
  end

  def reindex
    Gem::Indexer.new(settings.data).generate_index
  end

  def file_path
    File.expand_path(File.join(settings.data, *request.path_info))
  end

  def load_gems
    %w(specs prerelease_specs).inject(GemVersionCollection.new){|gems, specs_file_type|
      specs_file_path = File.join(settings.data, "#{specs_file_type}.#{Gem.marshal_version}.gz")
      if File.exists?(specs_file_path)
        gems + Marshal.load(Gem.gunzip(Gem.read_binary(specs_file_path)))
      else
        gems
      end
    }
  end

  def index_gems(gems)
    Set.new(gems.map{|name, _| name[0..0]})
  end

  helpers do
    def spec_for(gem_name, version)
      spec_file = File.join(settings.data, "quick", "Marshal.#{Gem.marshal_version}", "#{gem_name}-#{version}.gemspec.rz")
      Marshal.load(Gem.inflate(File.read(spec_file))) if File.exists? spec_file
    end

    def url_for(path)
      url = request.scheme + "://"
      url << request.host

      if request.scheme == "https" && request.port != 443 ||
          request.scheme == "http" && request.port != 80
        url << ":#{request.port}"
      end

      url << path
    end
  end
end
