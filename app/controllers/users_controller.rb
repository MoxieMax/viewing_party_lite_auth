class UsersController < ApplicationController

  def show
    if session[:user_id]
      @user = User.find(params[:id])
      @user_all_parties = @user.parties
    else
      flash[:alert] = "You must be logged in to access the dashboard."
      redirect_to login_path
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end
  
  def login_form
    render :login_form
  end
  
  def login
    user = User.find_by(email: params[:email])
    
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = "Your credentials are bad and you should feel bad."
      render :login_form
    end
  end
  
  # def logout
  #   session.delete(:user_id)
  #   redirect_to root_path
  # end

  private
  def user_params
    # params.require(:user).
    params.permit(:name, :email, :password, :password_confirmation)
  end
end

# def login
# if user && user.authenticate(params[:password])
#   # session[:user_id] = user.id
#   flash[:notice] = "Welcome, #{user.name}!"
#   redirect_to user_path(user)
# else
#   flash[:notice] = "Your credentials are bad and you should feel bad."
#   render :login_form
# end