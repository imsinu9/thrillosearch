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
		def search(query, per = 6)
			Searchable.search(query, per).results
		end
	end

	def tags
		tags = self.city.name.downcase.split(" ")

		tags.concat(self.tag.name.downcase.split(" ")) if self.tag.present?

		tags
	end
end
