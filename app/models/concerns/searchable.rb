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
                                tags: build_tags(q),
                                minimum_should_match: '2<60%'
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

    def self.build_tags(query)
        filtered_tags = Stopword::filter(query)
    end
end
