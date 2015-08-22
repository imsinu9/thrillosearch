module Searchable
    extend ActiveSupport::Concern

    def self.search(query, per)
        Elasticsearch::Model.search( search_query(query, per), types, options={}).results
    end

    def self.search_query(q, per)
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
            size: per
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
