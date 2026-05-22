# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  
    private
  
    def authenticate_user
      token = request.headers['Authorization']
      # puts "Received token: #{token}"
      
      decoded_token = decode_token(token)
      # puts "Decoded token: #{decoded_token}"
      
      if decoded_token
        @current_user = User.find(decoded_token['user_id'])
        # puts "Current user: #{@current_user.inspect}"
      else
        render json: { error: 'Nu sunteti logat' }, status: :unauthorized
      end
    end

    def authorize_admin
      render_unauthorized unless @current_user&.is_admin?
    end

    def authorize_manager
      # puts "Current user: #{@current_user.inspect}"
      render_unauthorized unless @current_user&.is_manager?
    end

    def authorize_admin_or_manager
      render_unauthorized unless @current_user&.is_admin? || @current_user&.is_manager?
    end

    def render_unauthorized
      render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
    end
  
    def decode_token(token)
      JWT.decode(token, Rails.application.credentials.jwt_secret_key, true, algorithm: 'HS256')[0] rescue nil
    end
  end
  