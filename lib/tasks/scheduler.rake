desc "This task is called by the Heroku scheduler add-on"
task :email_stats => :environment do
  puts "Emailing daily stats..."

  UsageMailer.stats_email().deliver_now
  
  puts "done."
end
