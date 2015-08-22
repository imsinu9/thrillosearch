class Stopword
    class << self
        def list
            %w(a and the to in is or at on)
        end

        def filter(q)
            filter_obj = Stopwords::Filter.new list
            filter_obj.filter q.split
        end
    end
end
