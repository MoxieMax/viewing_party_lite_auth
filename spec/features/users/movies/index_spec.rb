require 'rails_helper'

RSpec.describe "/users/:id/movies", type: :feature do
  describe "as a user, when I visit the movie index page" do 
    before :each do
      @picard = User.create!(name: "Jean-Luc Picard", email: "captain@uss-enterprise.com", password: "password123")
    end
    
    it "displays the first 20 top movies & vote average" do
      top_movies = File.read("spec/fixtures/moviedb/top_movies.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false")
      .to_return(status: 200, body: top_movies, headers: {})

      visit "/users/#{@picard.id}/movies"

      expect(page).to have_content("Top Rated Movies")
      expect(page).to have_button("Discover Page")

      within "#top-238" do
        expect(page).to have_link("The Godfather")
        expect(page).to have_content("Vote Average: 8.7")
      end

      within "#top-680" do
        expect(page).to have_link("Pulp Fiction")
        expect(page).to have_content("Vote Average: 8.5")
      end

      expect(page).to have_content("Vote Average:", count: 20)
    end

    it "displays max 20 movies with those keywords & vote average" do
      visit "/users/#{@picard.id}/discover"
      fill_in(:search, with: "space od")
      
      search_results = File.read("spec/fixtures/moviedb/search_results.json")
      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false&query=space%20od")
      .to_return(status: 200, body: search_results, headers: {})
      
      click_button("Search by Movie Title")

      expect(page).to have_content("Movie Results for: space od")
      expect(page).to have_button("Discover Page")

      within "#top-62" do
        expect(page).to have_link("2001: A Space Odyssey")
        expect(page).to have_content("Vote Average: 8.083")
      end
      
      within "#top-443295" do
        expect(page).to have_link("Bowie2001- A Space Oddity")
        expect(page).to have_content("Vote Average: 0.0")
      end

      expect(page).to have_content("Vote Average:", count: 20)
    end  
       
    it "displays the first 20 top movies & vote average" do
      top_movies = File.read("spec/fixtures/moviedb/top_movies.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false")
      .to_return(status: 200, body: top_movies, headers: {})

      visit "/users/#{@picard.id}/movies"
      
      godfather = File.read("spec/fixtures/moviedb/godfather.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: godfather, headers: {})

      cast_response = File.read("spec/fixtures/moviedb/space_cast.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/238/credits?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: cast_response, headers: {})

      reviews_response = File.read("spec/fixtures/moviedb/space_reviews.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/238/reviews?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: reviews_response, headers: {})
      film = MoviedbFacade.new(movie_id: 62)

      click_link("The Godfather")

      expect(current_path).to eq("/users/#{@picard.id}/movies/238")
    end


    it "displays max 20 movies with those keywords & vote average" do
      visit "/users/#{@picard.id}/discover"
      fill_in(:search, with: "space od")
      
      search_results = File.read("spec/fixtures/moviedb/search_results.json")
      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false&query=space%20od")
      .to_return(status: 200, body: search_results, headers: {})

      click_button("Search by Movie Title")
      
      space_odyssey = File.read("spec/fixtures/moviedb/space_odyssey.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: space_odyssey, headers: {})

      cast_response = File.read("spec/fixtures/moviedb/space_cast.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62/credits?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: cast_response, headers: {})

      reviews_response = File.read("spec/fixtures/moviedb/space_reviews.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62/reviews?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: reviews_response, headers: {})
      film = MoviedbFacade.new(movie_id: 62)
      
      click_link("2001: A Space Odyssey")

      expect(current_path).to eq("/users/#{@picard.id}/movies/62")
    end
  end
end

