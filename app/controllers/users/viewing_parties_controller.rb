class Users::ViewingPartiesController < ApplicationController

  def new
    if session[:user_id]
      @user = User.find(params[:user_id])
      facade = MoviedbFacade.new(movie_id: params[:movie_id]).find_movie_info
      @movie = Movie.new(movie: facade)
      @party = Party.new #create!(create_params)
    else
      flash[:alert]= "You must be logged in or registered to create a viewing party"
      redirect_to "/users/#{params[:user_id]}/movies/#{params[:movie_id]}"
    end
  end
  
  # def create
  #   @user = User.find(params[:host_id])
  #   @party = Party.new(params)
  #   @party.save
  #   @party_users = User.where(id: params[:user_ids].reject(&:empty?))
  #   @party.users = @invitees
  #   PartyUser.new(user_id: @user.id, viewing_party_id: @viewing_party.id)
  # end
  
  private
  def create_params
    params.permit(:duration,:start_time, :date, :movie_id, :host_id)
  end
end