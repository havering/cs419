class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :get_signature]
  #before_action :require_user, except: [:new, :create]
  protect_from_forgery

  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.role == 'admin'
      @users = User.all
    else
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    unless current_user && current_user.id == @user.id || current_user && current_user.role == 'admin'
      redirect_to root_path
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless @user.id == current_user.id || current_user.role == 'admin'
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_password
    num = rand(1..3)

    if num == 1
      @question = 'What is your favorite color?'
    elsif num == 2
      @question = 'What is the name of your high school?'
    else
      @question = 'At what age did you get your driver\'s license?'
    end
  end

  def newpassword
    puts "params answer is #{params[:users][:answer]}"
    puts "params email is #{params[:users][:email]}"

    answer = params[:users][:answer]

    @password_user = User.find_by_email(params[:users][:email])

    # puts "Answers are the same?"
    # puts "#{@password_user.answer1} - #{@password_user.answer1 == answer}"
    # puts "#{@password_user.answer2} - #{@password_user.answer2 == answer}"
    # puts "#{@password_user.answer3} - #{@password_user.answer3 == answer}"

    if @password_user
      if (answer == @password_user.answer1.to_s) || (answer == @password_user.answer2.to_s) || (answer == @password_user.answer3.to_s)
        return render :set_new
      else
        return redirect_to reset_password_path, notice: 'Invalid answer to security question'
      end
    else
      return redirect_to reset_password_path, notice: 'User not found'
    end
  end

  def set_new
    email = params[:users][:email]
    password = params[:users][:newpassword]

    user = User.find_by_email(email)
    user.update(password: password)

    redirect_to login_path, notice: 'Password updated. Please log in.'
  end

  def get_signature
    @signature = @user.signature
    puts "class of signature: #{@user.signature.class}"
    puts "encoding of signature: #{@user.signature.encoding}"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :signature, :answer1, :answer2, :answer3)
  end
end
