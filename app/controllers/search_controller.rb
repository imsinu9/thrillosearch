class SearchController < ApplicationController

	def search
		q = params[:q]

		results = Tour.search(q)
		format_json(results)
		
		render json: @out
	end

	def format_json(results)
		@out = []

		results.each do |result|
			@out <<	{
				name: result._source.name,
				code: result._id,
				type: result._type
			}
		end
	end
end
