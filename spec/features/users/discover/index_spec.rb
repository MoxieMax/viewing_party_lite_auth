require 'rails_helper'

RSpec.describe "/users/:id/discover", type: :feature do
  describe "as a user, when I visit the movie dashboard page" do 
    before :each do
      @picard = User.create!(name: "Jean-Luc Picard", email: "captain@uss-enterprise.com", password: "password123")
      visit "/users/#{@picard.id}/discover"
    end

    it "exists and should display page details" do
      expect(page).to have_content("Discover Movies")
      expect(page).to have_button("Find Top Rated Movies")
      expect(page).to have_field("Movie Title", :with => "search")
      expect(page).to have_button("Search by Movie Title")
    end
    
    it "click Top Rated Movies button, redirected to '/users/:id/movies' (movies result page) " do
      top_movies = File.read("spec/fixtures/moviedb/top_movies.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false")
      .to_return(status: 200, body: top_movies, headers: {})
      
      click_button("Find Top Rated Movies")
      expect(current_path).to eq("/users/#{@picard.id}/movies")
    end

    it "can accept partial keywords & redirect to result page" do
      search_results = File.read("spec/fixtures/moviedb/search_results.json")
      stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false&query=space%20od")
      .to_return(status: 200, body: search_results, headers: {})
      
      fill_in(:search, with: "space od")
      click_button("Search by Movie Title")

      expect(current_path).to eq("/users/#{@picard.id}/movies")
    end

    # User Story 5 - Sad Path Test ??? how ??? -> empty space/nil
  end
end