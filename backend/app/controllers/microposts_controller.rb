class MicropostsController < ApplicationController
  before_action :authenticate_user, only: [:user_posts, :update, :create, :destroy]
  
  def index
    if params[:from].present? && params[:to].present?
      from_date = DateTime.parse(params[:from])
      to_date = DateTime.parse(params[:to])
      @microposts = Micropost.where(date: from_date..to_date)
    else
      @microposts = Micropost.all
    end
    render json: @microposts, status: :ok
  end
  
  def create
    micropost = Micropost.new(micropost_params)
    if micropost.save
      render json: micropost, status: :created
    else
      render json: micropost.errors, status: :unprocessable_entity
    end
  end

  def user_posts
    user = @current_user
    user_posts = user.microposts
    render json: user_posts, status: :ok
  end

  def destroy 
    micropost = Micropost.find_by(id: params[:id])
    if micropost
      if micropost.user == @current_user || @current_user.is_admin?
        micropost.destroy
        head :no_content # Răspuns fără conținut pentru indicarea ștergerii cu succes(cod 204)
      else
        render json: { error: "Nu ai permisiunea de a șterge această postare" }, status: :forbidden
      end
    else
      render json: { error: "Micropost not found" }, status: :not_found
    end
  end

  def update
    micropost = Micropost.find_by(id: params[:id])
    if micropost
      if micropost.user == @current_user || @current_user.is_admin?
        if micropost.update(micropost_params)
          render json: micropost, status: :ok
        else
          render json: micropost.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Nu ai permisiunea de a șterge această postare" }, status: :forbidden
      end
    else
      render json: { error: "Micropost not found" }, status: :not_found
    end
  end
  
  private

  def micropost_params
    params.require(:micropost).permit(:date, :distance, :time, :location, :user_id)
  end
end
