class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  
  def index
    @users  =User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def create
   @user = User.new(user_params)
    if @user.save #if I can save the user,  
        log_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user #redirect to the user profile redirect_to user_url(@user)
        #Rails automatically infers from redirect_to @user that we want to redirect to user_url(@user).
    else 
      render 'new' #else, go back to the new method
    end
  end
  
  def edit
    @user = User.find(params[:id]) #get the user id with params
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] ="Profile has been updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private 
    def user_params
     params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
  #before filters
  
  #confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
  
  def correct_user
    @user = User.find_by(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
 
end
