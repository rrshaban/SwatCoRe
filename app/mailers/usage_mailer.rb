class UsageMailer < ApplicationMailer
  default from: 'swatcoreteam@gmail.com'

  def stats_email()
    mail(to: 'swatcoreteam@gmail.com', subject: 'SwatCoRe Usage Stats')
  end

end
