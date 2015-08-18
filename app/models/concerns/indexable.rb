module Indexable
    extend ActiveSupport::Concern

    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        index_name "heap"
        document_type self.table_name

        settings index: {
            number_of_shards: 1, 
            number_of_replicas: 0,
            analysis: {
              tokenizer: {
                name_tokenizer: {
                  type: "pattern",
                  pattern: "[^a-zA-Z0-9]"
                }
              },
              filter: {
                name_ngram_filter: {
                  type: "edgeNGram",
                  min_gram: 1,
                  max_gram: 15
                }
              },
              analyzer: {
                name_default_analyzer: {
                  type: "custom", 
                  tokenizer: "name_tokenizer", 
                  filter: ["lowercase", "asciifolding", "word_delimiter"]
                },
                name_front_ngram_analyzer: {
                  type: "custom", 
                  tokenizer: "name_tokenizer",
                  filter: ["lowercase", "asciifolding", "name_ngram_filter"]
                }
              }
            }
          } do 
        end

        def index_document(options={})
          __elasticsearch__.index_document(options)
        end

        def update_document(options={})
          __elasticsearch__.update_document(options) rescue nil
        end

        def delete_document(options={})
          __elasticsearch__.delete_document(options) rescue nil
        end

        def as_indexed_json(options={})
          as_json(
              only: [:name],
              methods: [:tags, :code, :type]  
            )
        end
    end
end