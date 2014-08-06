task :send_reminder_emails => :environment do
	Rails.configuration.active_record.observers = []
  Registration.send_reminder_emails
end
