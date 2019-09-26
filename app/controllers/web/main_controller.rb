class Web::MainController < Web::ApplicationController
  before_filter :authenticate_admin!, except: [:logout]

  def index
    # puts "teste"
    # puts current_web_user ? current_web_user.email : nil
  end

  def logout
    sign_out current_user
    redirect_to new_web_user_session_path
  end
   
end
