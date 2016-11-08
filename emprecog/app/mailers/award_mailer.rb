class AwardMailer < ApplicationMailer
  # Once the award has been created, the system should email a PDF certificate to the person
  # getting the award, that has been custom generated using LaTeX, with the person's name,
  # date, and the name of the user who authorized the award, along with the authorizing user's
  # signature image.
  def award_email(awardee, date, awarder, signature, award)
    @awardee = awardee
    @date = date
    @awarder = awarder
    @signature = signature
    @award = award

    mail(to: @awardee.email, subject: 'You\'ve been given an award!')
  end
end
