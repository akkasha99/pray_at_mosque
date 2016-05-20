class PrayAtMosqueMailer < ApplicationMailer
  default from: "petawayapp@gmail.com"

  def child_invitation(password, child)
    @password = password
    @child = child
    mail(:to => child.email, :subject => 'Pray At Mosque /"Account Invitation/"', :@password => @password, :@child => @child)
  end
end
