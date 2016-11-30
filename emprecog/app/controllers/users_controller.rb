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

  def reporting
    @user_select = User.where(role: 'user')
  end

  def all_awards
    duct_tape = Award.where(award_type: 'Duct Tape')
        ofthemonth = Award.where(award_type: 'Employee of the Month')
        eyeofthe = Award.where(award_type: 'Eye of the Storm')
        swissarmy = Award.where(award_type: 'Swiss Army Knife')
        bulls = Award.where(award_type: 'Running with the Bulls')
        appreciation = Award.where(award_type: 'Appreciation')

        @award_overview = {
          type: 'pie',
          data: {
          labels: ["Duct Tape", "Employee of the Month", "Eye of the Storm", "Swiss Army Knife", "Running with the Bulls", "Appreciation"],
          datasets: [
            {
              label: "All Awards",
              backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)',
              ],
              borderColor: "rgba(220,220,220,1)",
              data: [duct_tape.count, ofthemonth.count, eyeofthe.count, swissarmy.count, bulls.count, appreciation.count]
            }]
        }}

    render :json => @award_overview
  end

  def award_by_user
    id = params[:id]

    duct_tape = Award.where(award_type: 'Duct Tape', given_by: id)
    ofthemonth = Award.where(award_type: 'Employee of the Month', given_by: id)
    eyeofthe = Award.where(award_type: 'Eye of the Storm', given_by: id)
    swissarmy = Award.where(award_type: 'Swiss Army Knife', given_by: id)
    bulls = Award.where(award_type: 'Running with the Bulls', given_by: id)
    appreciation = Award.where(award_type: 'Appreciation', given_by: id)

    @by_user = {
      type: 'pie',
      data: {
           labels: ["Duct Tape", "Employee of the Month", "Eye of the Storm", "Swiss Army Knife", "Running with the Bulls", "Appreciation"],
           datasets: [
            {
             label: "Awards by User",
             backgroundColor: [
               'rgba(255, 99, 132, 0.2)',
               'rgba(54, 162, 235, 0.2)',
               'rgba(255, 206, 86, 0.2)',
               'rgba(75, 192, 192, 0.2)',
               'rgba(153, 102, 255, 0.2)',
               'rgba(255, 159, 64, 0.2)',
             ],
             borderColor: "rgba(220,220,220,1)",
          data: [duct_tape.count, ofthemonth.count, eyeofthe.count, swissarmy.count, bulls.count, appreciation.count]
        }]}
    }

    # passing it back to jquery: http://stackoverflow.com/questions/33319924/in-rails-how-to-pass-parameters-to-controller-method-from-jquery-and-then-get-r
    render :json => @by_user
  end

  def user_awards
    id = params[:id]

    duct_tape = Award.where(award_type: 'Duct Tape', user_id: id)
    ofthemonth = Award.where(award_type: 'Employee of the Month', user_id: id)
    eyeofthe = Award.where(award_type: 'Eye of the Storm', user_id: id)
    swissarmy = Award.where(award_type: 'Swiss Army Knife', user_id: id)
    bulls = Award.where(award_type: 'Running with the Bulls', user_id: id)
    appreciation = Award.where(award_type: 'Appreciation', user_id: id)

    @user_awards = {
      type: 'pie',
      data: {
           labels: ["Duct Tape", "Employee of the Month", "Eye of the Storm", "Swiss Army Knife", "Running with the Bulls", "Appreciation"],
           datasets: [
            {
             label: "Awards by User",
             backgroundColor: [
               'rgba(255, 99, 132, 0.2)',
               'rgba(54, 162, 235, 0.2)',
               'rgba(255, 206, 86, 0.2)',
               'rgba(75, 192, 192, 0.2)',
               'rgba(153, 102, 255, 0.2)',
               'rgba(255, 159, 64, 0.2)',
             ],
             borderColor: "rgba(220,220,220,1)",
          data: [duct_tape.count, ofthemonth.count, eyeofthe.count, swissarmy.count, bulls.count, appreciation.count]
        }]}
    }

    render :json => @user_awards
  end

  def admin
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
