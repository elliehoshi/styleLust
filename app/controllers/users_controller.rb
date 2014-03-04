class UsersController < ApplicationController
	def index
		@user = User.new		
	end

	def new
		@user=User.new
		redirect_to root_path

	end

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def create
		@user = User.new(valid_params)
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "account created"
			redirect_to root_path
		else
			flash[:error] = "account could not be created"
			redirect_to root_path
		end
	end




	private

	def valid_params
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end
end