# app/controllers/auth_controller.rb
class AuthController < ApplicationController
    before_action :authenticate_user, except: [:login]
  
    def login
      user = User.find_by(email: params[:email])
  
      if user && user.authenticate(params[:password])
        # cream un token in care avem id-ul user-ului criptat
        # token-ul e salvat in partea de front(cookie) si cu el avem acces la resursele acestui user
        # cu alte cuvinte, stim ce user e logat
        token = encode_token(user_id: user.id)
        render json: { user: user, token: token }, status: :ok
      else
        render json: { error: 'Autentificare eșuată' }, status: :unauthorized
      end
    end
  
    def current_user
      render json: @current_user
    end
  
    def logout
      # delogarea în JWT nu necesita acțiuni speciale 
      head :no_content
    end
  
    private
  
    def encode_token(payload)
      JWT.encode(payload, Rails.application.credentials.jwt_secret_key, 'HS256')
    end
  end
  