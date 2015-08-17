module Searchable
    extend ActiveSupport::Concern

    def self.search(query)
        Elasticsearch::Model.search( search_query(query), types, options={}).results
    end

    def self.search_query(query)
       query = {
            query: {
                bool: {
                    should: {
                        query_string: {
                            fields: fields,
                            defaultOperator: 'or',
                            query: query
                        }
                    }
                }
            },
            size: 6
        }
    end

    def self.types
        [Tour, City, Tag]
    end

    def self.fields
        ['name.name_default^3', 'name.ngrams_front']
    end
end