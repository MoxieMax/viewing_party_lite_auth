require 'rails_helper'

RSpec.describe "/", type: :feature do
  before :all do 
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
  end
  
  describe "as a logged in user" do
    before :each do
      visit login_url
      fill_in :email, with: @user1.email
      fill_in :password, with: @user1.password
      click_on "Log In"
      
      visit "/"
    end
    
    it "should display title of app, link to home" do
      # save_and_open_page
      expect(page).to have_content("Viewing Party")
      expect(page).to have_link("Home")

      expect(page).to have_content("Existing Users")
      expect(page).to_not have_button("Create a New User")
    end
    
    it "should show a list of existing users with links to their show pages" do
      expect(page).to have_content("#{@user1.email}")
      expect(page).to have_content("#{@user2.email}")
      expect(page).to have_content("#{@user3.email}")
    end
    
    describe "as a visitor" do
      before :each do
        expect(page).to have_link("Log Out")
        click_on "Log Out"
      end
      
      it 'has a link to the login page when no user is logged in' do
        expect(page).to have_link("Log In")
        
        click_link("Log In")
        
        expect(current_path).to eq(login_path)
      end
      
      it "when I click on the button I'm redirected to '/register' page" do
        expect(page).to have_link("Log In")
        
        click_button("Create a New User")
        
        expect(current_path).to eq("/register")
      end
      
      it "does not list existing users when no user is loged in" do
        expect(page).to_not have_link("#{@user1.email}")
        expect(page).to_not have_link("#{@user2.email}")
        expect(page).to_not have_link("#{@user3.email}")
      end
      
      # it "" do
      # end
    end
  end
end