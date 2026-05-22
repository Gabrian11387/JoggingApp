class UsersController < ApplicationController
    before_action :authenticate_user, only: [:show, :index, :role, :weekly_data, :destroy, :update]
    before_action :authorize_admin_or_manager, only: [:update, :destroy, :index]

    def index
      @users = User.where.not(id: @current_user.id)
      render json: @users, status: :ok
    end

    def show
        user = @current_user

        if user
            render json: user, status: :ok
        else
            # datorita lui before_action nu mai e necesara aceasta ramura
            render json: { error: 'Utilizatorul nu a fost găsit' }, status: :not_found
        end
    end

    def update
        user = User.find_by(id: params[:id])
      
        if user
          if user_params[:username].present?
            user.username = user_params[:username]
          end
      
          if user_params[:password].present? || user_params[:password_confirmation].present?
            user.password = user_params[:password]
            user.password_confirmation = user_params[:password_confirmation]
            # Dacă avem câmpurile pentru parole setate, încercăm să facem save în baza de date
            if user.save
              render json: user, status: :ok
            else
              render json: user.errors, status: :unprocessable_entity
            end
          else
            user.update_column(:username, user.username)
            if user.errors.empty?
              render json: user, status: :ok
            else
              render json: user.errors, status: :unprocessable_entity
            end
          end
        else
          render json: { error: 'Utilizatorul nu a fost găsit' }, status: :not_found
        end
    end

    def create
        user = User.new(user_params)  

        if user.save
            render json: user, status: :created     
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    def destroy
      user = User.find_by(id: params[:id])

      if user
          if user == @current_user
              render json: { error: 'Nu poți șterge propriul cont' }, status: :forbidden
          else
              user.destroy
              render json: { message: 'Utilizatorul a fost șters' }, status: :ok
          end
      else
          render json: { error: 'Utilizatorul nu a fost găsit' }, status: :not_found
      end
    end   
    
    def check_email_availability
      email = params[:email]

      if User.exists?(email: email)
        render json: { available: false }, status: :unprocessable_entity
      else
        render json: { available: true }, status: :ok
      end
    end

    def get_user_info
      user = User.find_by(id: params[:id])
  
      if user
        render json: { username: user.username, email: user.email }, status: :ok
      else
        render json: { error: 'Utilizatorul nu a fost găsit' }, status: :not_found
      end
    end

    def role
      render json: { role: @current_user.role }, status: :ok
    end

  def weekly_data
    user = @current_user
    week = params[:week]

    if user && week.present?
      week_start = Date.parse(week).beginning_of_week
      week_end = week_start.end_of_week

      microposts = user.microposts.where(date: week_start..week_end)

      total_distance = microposts.sum(:distance)
      total_time = microposts.sum(:time)

      if total_time > 0
        average_speed = total_distance / total_time
      else
        average_speed = 0
      end

      render json: { total_distance: total_distance, average_speed: average_speed }, status: :ok
    else
      render json: { error: 'Utilizatorul nu a fost găsit sau săptămâna nu a fost specificată' }, status: :not_found
    end
  end

    private
        def user_params
            params.require(:user).permit(:username, :email, :password,
                                         :password_confirmation)
        end
end
