

class HemlockDownloader
  require 'net/ftp'
  require 'json'

  def initialize
    # stub
  end
  
  # download a URI/URL into a string for processing
  # detect whether input is URI or a URL and account for non-SSL, SSL, and HTTP redirects
  def download_url_into_string(uri_or_host, limit=10)
    require 'net/http'
    
    # create or get URI
    uri = (uri_or_host.is_a? String) ? URI.parse(URI.encode(uri_or_host)) : uri = uri_or_host
    
    # create connection agent
    agent = Net::HTTP
    
    # use different methods for SSL vs. HTTP
    # use of SSL requires creating new requestor and setting SSL
    # which prevents being able to follow redirects
    if uri.instance_of? URI::HTTPS
      req = agent.new(uri.host, uri.port)
      
      # explicitly set ssl
      req.use_ssl = true

      # download    
      req.start do |http|
        response = http.get(uri.path)
        response.body
      end
      
    else
      response = agent.get_response(uri)
      
      case response
      when Net::HTTPSuccess then
        response.body
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        download_url_into_string(location, limit - 1)
      else
        response.value
      end
      
    end
    
  end
      
  # call Hemlock's API and take mysql results in the form of
  #   +----------+--------------------------------------+
  #   | Property |                Value                 |
  #   +----------+--------------------------------------+
  # and convert into {"Property" => "Value", ...}
  def call_api(url)
    begin
      # format url
      url_full = ENV['HOST_HEMLOCK_API'] + url
         
      # get data
      data = download_url_into_string(url_full)
      
      # regex to parse MySQL stdout
      regex_onecolumn = Regexp.new('^ *\| +([^\|]+?) +\| *$')
      regex_twocolumn = Regexp.new('^ *\| +([^\|]+?) +\| +([^\|]+?) +\| *$')
      
      # parse MySQL results into Hash
      parsed_onecolumn = data.scan regex_onecolumn
      if parsed_onecolumn.empty?
        parsed_twocolumn = data.scan regex_twocolumn
        raise "Invalid format of API results:\n#{url_full}\n#{data}" if parsed_twocolumn.empty?
        
        parsed_twocolumn.shift
        Hash[*parsed_twocolumn.flatten]
                
      else
        parsed_onecolumn.shift
        Array[*parsed_onecolumn.flatten].uniq
      end

    
    rescue Exception => e
      puts "#{__method__}: #{e.message}"
      nil
    end
  end  

  def test_response
    "
     +----------+--------------------------------------+
     | Property |                Value                 |
     +----------+--------------------------------------+
     |    id    |                  1                   |
     |   uuid   | 62b8a809-e868-43ce-8365-cf96ecb8dd8f |
     |   name   |               tenant1                |
     | created  |         2013-06-10 21:38:07          |
     +----------+--------------------------------------+
    "  
  end
  
end # HemlockDownloader
  
