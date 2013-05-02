class HemlockDocumentStore
  def initialize
    @client ||= Couchbase.connect(Rails.application.config.database_configuration['couchbase'].symbolize_keys)
    @hemlock_downloader ||= HemlockDownloader.new
  end
  
  def get(id, bucket="hemlock")
    @client.get(id, :bucket => bucket)
  end

  def search(query)
    # query hemlock server
    results_s = @hemlock_downloader.download_url_into_string("#{ENV['HOST_HEMLOCK_SEARCH']}/hemlock/_search?q=#{query}&size=200")
    results_json = JSON.parse(results_s).deep_symbolize_keys

    # compile list of matching results
    ids = []
    results_json[:hits][:hits].each { |match| ids << match["_id"] }
    results_text = get(ids)        
    [results_json, results_text]
  end

private
  
end #HemlockDocumentStore
  
