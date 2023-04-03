require 'rails_helper'

RSpec.describe "user registration page" do
  before :each do
    User.delete_all
    
    visit register_path
  end
  
  describe "initial testing" do
    it "exists and has a registration form" do
      expect(page).to have_field("Name")
      expect(page).to have_field("Email")
      expect(page).to have_field("Password")
      expect(page).to have_button("Create New User")
    end
    
    it "takes input to create a new user" do
      fill_in('Name', with: 'Lightning McQueen')
      fill_in('Email', with: 'Kachow@cars.net')
      fill_in('Password', with: 'password123', match: :prefer_exact)
      fill_in('Password Confirmation', with: "password123")
      click_on("Create New User")

      expect(current_path).to eq(root_path)
      expect(page).to have_content("User has been created!")
    end
    
    it "won't create a user with an already used email" do
      user = User.create(name: "Lightning McQueen", email: "kachow@cars.net", password: "password123")
      
      fill_in('Name', with: 'Chick Hicks')
      fill_in('Email', with: 'kachow@cars.net')
      fill_in('Password', with: 'password123', match: :prefer_exact)
      fill_in('Password Confirmation', with: "password123")
      click_on("Create New User")

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Email has already been taken")
    end
    
    describe "sad path testing" do
      it "won't create a user with two blank fields" do
        click_on("Create New User")
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Password can't be blank")
      end
      
      it "won't create a user without an email" do
        fill_in('Name', with: "Jeff Goldblum")
        fill_in('Password', with: 'password123', match: :prefer_exact)
        fill_in('Password Confirmation', with: 'password123')
        click_on("Create New User")
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email can't be blank")
        expect(page).to_not have_content("Name can't be blank")
      end
      
      it "won't create a user without a name" do
        fill_in('Email', with: "JurassicSnark@jp.com")
        fill_in('Password', with: 'password123', match: :prefer_exact)
        fill_in('Password Confirmation', with: 'password123')
        click_on("Create New User")
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name can't be blank")
        expect(page).to_not have_content("Email can't be blank")
      end
      
      it "won't create a user without a password" do
        fill_in('Name', with: "Jeff Goldblum")
        fill_in('Email', with: "JurassicSnark@jp.com")
        click_on("Create New User")
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password can't be blank")
        expect(page).to_not have_content("Name can't be blank")
        expect(page).to_not have_content("Email can't be blank")
      end
      
      it "won't create a user if passwords don't match" do
        fill_in('Name', with: "Jeff Goldblum")
        fill_in('Email', with: "JurassicSnark@jp.com")
        fill_in('Password', with: 'password123', match: :prefer_exact)
        fill_in('Password Confirmation', with: 'password124')
        click_on("Create New User")
        
        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password confirmation doesn't match Password")
        expect(page).to_not have_content("Password can't be blank")
        expect(page).to_not have_content("Name can't be blank")
        expect(page).to_not have_content("Email can't be blank")
      end
    end
  end
end

