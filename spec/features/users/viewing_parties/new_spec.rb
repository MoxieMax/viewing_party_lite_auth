require 'rails_helper'

RSpec.describe "/users/:id/movies/:movie_id/viewing_party/new" do
  describe "as a user, when I visit the new viewing party page" do
    before :each do
      PartyUser.delete_all
      Party.delete_all
      User.delete_all
    
      @user1 = User.create!(id: 1,
                            name: "Gideon Nav", 
                            email: "cav-life@ninth.net",
                            password: 'password123'
                          )
      @user2 = User.create!(id: 2,
                            name: "Harrowhark Nonagesimus", 
                            email: "revdaughter@ninth.net",
                            password: 'password123'
                          )
      @user3 = User.create!(id: 3,
                            name: "Ianthe Tridentarius", 
                            email: "archenemy@third.com",
                            password: 'password123'
                          )
      @user4 = User.create!(id: 4,
                            name: "Coronabeth Tridentarius", 
                            email: "goldenchild@third.com",
                            password: 'password123'
                          )
    
      @movie_response = File.read("spec/fixtures/moviedb/space_odyssey.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62?api_key=#{ENV["TMDB_API_KEY"]}")
        .to_return(status: 200, body: @movie_response, headers: {})
        
      # movie_hash = (:movie => @movie_response)
      facade = MoviedbFacade.new(movie_id: 62).find_movie_info
      @movie = Movie.new(movie: facade)
      # binding.pry
      
      visit "/users/#{@user1.id}/movies/62/viewing_party/new"
    end
    
    describe "should render a create page" do
      it "has the following information" do
        # binding.pry
        expect(page).to have_content("Viewing Party")
        expect(page).to have_content("Create a Movie Party for 2001: A Space Odyssey")
        expect(page).to have_button("Discover Page")
        
        expect(page).to have_content("Movie Title")
        expect(page).to have_content(@movie.title)
        
        expect(page).to have_field("Duration of Party", with: @movie.runtime)
        expect(page).to have_field(:date)
        expect(page).to have_field(:start_time)
        
        # expect(page).to have_field("Invite Other Users")
        # 
        # expect(page).to have_unchecked_field("revdaughter@ninth.net")
        # expect(page).to have_unchecked_field("archenemy@third.com")
        # expect(page).to have_unchecked_field("goldenchild@third.com")
        
        expect(page).to have_button("Create Party")
      end
      
      it "discover page link goes to the discover page" do
        click_button("Discover Page")
        
        expect(current_path).to eq("/users/#{@user1.id}/discover")
      end
      
      it "can create a new viewing party" do
        fill_in(:duration, with: 160)
        fill_in(:date, with: Date.today)
        fill_in(:start_time, with: Time.now + 2.hours)
        
        # check(@user2.email)
        
        # click_button("Create Party")
        # expect(current_path).to eq("/users/#{@user1.id}/")
      end
    end
  end
end




# I should see the name of the movie title rendered above a form with the following fields:
# 
# Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
# When: field to select date
# Start Time: field to select time
# Checkboxes next to each existing user in the system
# Button to create a party
# Details When the party is created, the user should be redirected back to the dashboard where the new event is shown. The event should also be listed on any other user's dashbaords that were also invited to the party.