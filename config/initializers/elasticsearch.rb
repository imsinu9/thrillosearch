case Rails.env
  when 'production'
    Elasticsearch::Model.client = Elasticsearch::Client.new({url: ENV['ES_PROD_URL'], logs: false})
  when 'development'
    Elasticsearch::Model.client = Elasticsearch::Client.new({url: 'http://localhost:9200', logs: false})
end