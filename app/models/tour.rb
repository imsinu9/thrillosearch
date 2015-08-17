class Tour < ActiveRecord::Base
	include Indexable
	include Searchable

	mappings do
		indexes :name, type: 'multi_field' do 
			indexes :name_default, type: 'string', analyzer: 'name_default_analyzer'
			indexes :ngrams_front, type: 'string', analyzer: 'name_front_ngram_analyzer'
		end
		indexes :tags, type: 'string'
	end

  	belongs_to :city
  	belongs_to :tag

  	validates_presence_of :city, :name

  	after_commit :index_document, on: :create
  	after_commit :update_document, on: :update 
  	after_commit :delete_document, on: :destroy 

  	class << self
  		def search(query)
  			Searchable.search(query).results
  		end		
  	end

  	def tags
  		tags = [self.city.name]

  		if self.tag.present?
  			tags << self.tag.name 
  		end
  	end
end