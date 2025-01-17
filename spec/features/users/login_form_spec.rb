require 'rails_helper'

RSpec.describe "Login Form", type: :feature do
  describe "renders a login page" do
    before :each do
      visit login_path
      
      @user1 = User.create!(id: 1,
                            name: "Gideon Nav", 
                            email: "cav-life@ninth.net",
                            password: 'password123'
                          )
    end
    
    it "has fields" do
      expect(page).to have_field(:email)
      expect(page).to have_field("Password")
      expect(page).to have_button("Log In")
    end
    
    it "is fillable and will authenticate in a user" do
      fill_in(:email, with: @user1.email)
      fill_in("Password", with: @user1.password)
      click_on("Log In")
      
      expect(current_path).to eq(user_path(@user1))
      expect(page).to have_content("Welcome, Gideon Nav!")
    end
    
    it "will not authenticate with improper credentials" do
      fill_in(:email, with: @user1.email)
      fill_in("Password", with: "Harrowhark")
      click_on("Log In")
      
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your credentials are bad and you should feel bad.")
    end
  end
end