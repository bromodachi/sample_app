class UsersController < ApplicationController
  
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
  
  private 
    def user_params
     params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
