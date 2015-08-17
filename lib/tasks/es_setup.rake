namespace :es do
  task :setup => 'environment' do
    searchable_classes = ["Tour", "City", "Tag"]

    searchable_classes.each do |klass_name|
      klass = Object.const_get klass_name
      es_indices = klass.__elasticsearch__.client.indices

      options = {index: klass.index_name}
      
      unless es_indices.exists(options)
        es_indices.create(options.merge!({body: {settings: klass.settings.to_hash}}))
        puts "Index Created"
      end

      puts "Importing mappings for #{klass_name}"
      es_indices.put_mapping(
        {
          index: klass.index_name,
          type: klass.document_type,
          body: klass.mappings.to_hash
        }
      )
      
      puts "Indexing documents for #{klass_name}"
      klass.import
    end
  end
end