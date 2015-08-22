class SearchController < ApplicationController

	def search
		q = params[:q]
		per = params[:sz]

		results = Tour.search(q, per)
		format_json(results)

		render json: @out
	end
end
