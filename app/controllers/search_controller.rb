class SearchController < ApplicationController

	def search
		q = params[:q]

		@results = Tour.search(q)
		render json: @results
	end
end
