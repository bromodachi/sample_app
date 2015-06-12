module SessionsHelper
  
  #logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #returns the user corresponding to the remember token cookie
  def current_user
    if(user_id =  session[:user_id]) #if we have a persistent state of the user in session
      @current_user ||=User.find_by(id: session[:user_id])
    elsif(user_id = cookies.signed[:user_id]) #else, if we have a cookie of the user
      
      user = User.find_by(id: user_id)
      if (user && user.authenticated?(cookies[:remember_token])) #if we have a user and if it's the right cookie for that user
        log_in user
        @current_user = user
      end
    end
  end
  
  #checks if the user is logged in the current session
  def logged_in?
    !current_user.nil?
  end
  
  #logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  #remembers a user in a current session. Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
    
end