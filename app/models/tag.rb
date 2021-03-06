class Tag < ActiveRecord::Base
	include Indexable
    
    mappings do
    	indexes :name, type: 'multi_field' do 
          	indexes :name_default, type: 'string', analyzer: 'name_default_analyzer'
          	indexes :ngrams_front, type: 'string', analyzer: 'name_front_ngram_analyzer'
      	end
    end

	has_many :tours

	validates_presence_of :name
	validates_uniqueness_of :name

	after_commit :index_document, on: :create
	after_commit :update_document, on: :update 
	after_commit :delete_document, on: :destroy 
end
