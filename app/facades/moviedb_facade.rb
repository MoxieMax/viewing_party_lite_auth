# require 'ostruct'

class MoviedbFacade
  attr_reader :word,
              :movie_id
    
  def initialize(params)
    # binding.pry
    if params[:search].present?
      @word = params[:search] 
    elsif params[:movie_id].present?
      @movie_id = params[:movie_id]
    # else
    end
  end

  def movie_service
    @_movie_service ||= MoviedbService.new
  end

  def movies_keyword_search
    search_results = movie_service.get_movie_by_word(@word)
    search_results[:results].map do |movie_hash|
      movie_list = { movie: movie_hash }
      Movie.new(movie_list)
    end
  end

  def top_20_movies
    search_results = movie_service.get_top_20
    search_results[:results].map do |movie_hash|
      movie_list = { movie: movie_hash }
      Movie.new(movie_list)
    end
  end

  def all_movie_info
    movie_list = {
      movie: find_movie_info,
      cast: find_cast_info,
      reviews: find_reviews_info,
    }
    Movie.new(movie_list)
  end
  
  # Helper methods: 
  def find_movie_info
    info = movie_service.get_movie(@movie_id)
  end

  def find_cast_info
    info = movie_service.get_cast(@movie_id)
    info[:cast].first(10).map do |cast_hash|
      { actor: cast_hash[:name], character: cast_hash[:character] }
    end
  end

  def find_reviews_info
    info = movie_service.get_reviews(@movie_id)
    info[:results].map do |results_hash|
      { author: results_hash[:author], review: results_hash[:content] }
    end
  end

  ############## REFACTORED: 
  #private <- for later muahaha

  # def get_movies_search
  #   search_results = movie_service.fetch_api("search/movie?query=#{@word}&include_adult=false")
  #   search_results[:results].map do |movie_hash|
  #     movie_list = { movie: movie_hash }
  #     Movie.new(movie_list)
  #   end
  # end

  # def get_top_movies
  #   search_results = movie_service.fetch_api("movie/top_rated?include_adult=false")
  #   search_results[:results].map do |movie_hash|
  #     movie_list = { movie: movie_hash }
  #     Movie.new(movie_list)
  #   end
  # end

  # def get_movie_search(word)
  #   search_results = movie_service.fetch_api("/search/movie?query=#{word}&include_adult=false")
  #   search_results["results"].map do |movie|
  #     Movie.new(movie)
  #   end
  # end

  # def get_top_movies
  #   search_results = movie_service.fetch_api("/movie/top_rated?include_adult=false")
  #   search_results["results"].map do |movie|
  #     Movie.new(movie)
  #   end
  # end

  # def get_movies(keyword)
  #   top_20 = MoviedbService.fetch_api("")
  # end

  #####

  # def self.top_movie_info
  #   movie_list = {
  #     top_movies: get_top_movies # [{}]
  #   }
  #   # x = Movie.new(movie_list)
  #   require 'pry'; binding.pry
  # end
  
  # def initialize
  #   @movie_service = MoviedbService.new # could use memorization so it only uses resources when you need it
  # #   # make keyword an instance here (then can call it later in the view/controller)
  # end
end