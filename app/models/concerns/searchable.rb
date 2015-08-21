module Searchable
    extend ActiveSupport::Concern

    def self.search(query)
        Elasticsearch::Model.search( search_query(query), types, options={}).results
    end

    def self.search_query(q)
       query = {
            query: {
                bool: {
                    should: [
                        {
                            query_string: {
                                fields: fields,
                                allow_leading_wildcard: false,
                                analyzer: "name_default_analyzer",
                                query: q
                            }
                        },
                        {
                            terms: {
                                tags: tag_builder(q),
                                minimum_should_match: tag_length(q)
                            }
                        }
                    ]
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

    def self.tag_builder(query)
        query.split(' ')
    end

    def self.tag_length(query)
        query.split(' ').length
    end
end
