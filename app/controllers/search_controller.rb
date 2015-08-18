class SearchController < ApplicationController

	def search
		q = params[:q]

		results = Tour.search(q)
		format_json(results)

		render json: @out
	end
end
