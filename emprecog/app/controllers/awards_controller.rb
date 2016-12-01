class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]
  before_action :check_admin

  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.all
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
  end

  # GET /awards/new
  def new
    @award = Award.new
  end

  # GET /awards/1/edit
  def edit
    unless @award.given_by == current_user.id
      redirect_to awards_path
    end
  end

  # POST /awards
  # POST /awards.json
  def create
    date = date_from_form(params[:award])

    user = User.find(award_params[:name])

    user_name = user.full_name

    @award = Award.new(award_params.merge({user_id: user.id, email: user.email, given_by: current_user.id, granted: date, name: user_name}))

    respond_to do |format|
      if @award.save
        # if it saves, then send off an email about it
        sig = current_user.signature
        sig = sig['data:image/png;base64,'.length .. -1]

        File.open('TEST_FILE1.png', 'wb') do |f|
          f.write(Base64.decode64(sig))
        end

        # http://stackoverflow.com/questions/5685492/pdf-generating-with-prawn-how-can-i-acces-variable-in-prawn-generate
        Prawn::Document.generate("test.pdf") do |pdf|
          pdf.text "#{@award.award_type}", align: :center, size: 42
          pdf.move_down 20
          pdf.text "presented to #{@award.name}", align: :center, size: 26
          pdf.move_down 20
          pdf.text "on #{@award.granted.strftime("%m/%d/%Y at %I:%M %p %Z") }", align: :center, size: 20
          pdf.move_down 40
          pdf.text "Signed and sealed by #{current_user.firstname} #{current_user.lastname}", align: :center, size: 20
          img = "#{Rails.root}/TEST_FILE1.png"
          pdf.image img, :at => [20, 450], :scale => 0.33
          # pdf.image "#{current_user.signature}", align: :center
        end

        mail = AwardMailer.award_email(user, @award.granted, current_user, current_user.signature, @award)

        results = mail.deliver_now

        File.delete("#{Rails.root}/test.pdf")
        File.delete("#{Rails.root}/TEST_FILE1.png")

        format.html { redirect_to @award, notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to @award, notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to awards_url, notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_pdf
    html = render_to_string(:action => '../views/award_mailer/award_email.html.erb', :layout => false)
    pdf = PDFKit.new(html)
    pdf # return the pdf blob prior to converting it to actual pdf
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_award
    @award = Award.find(params[:id])
  end

  def check_admin
    if current_user.role == 'admin'
      redirect_to root_path
    end
  end

  def date_from_form(ev)
    DateTime.new(ev["granted(1i)"].to_i, ev["granted(2i)"].to_i, ev["granted(3i)"].to_i, ev["granted(4i)"].to_i, ev["granted(5i)"].to_i)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def award_params
    params.require(:award).permit(:award_type, :granted, :name)
  end
end
