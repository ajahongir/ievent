class EventMailer < ActionMailer::Base
  default :from => ENV['GMAIL_USERNAME']

  def event_email(event)
    @user = event.user
    @event = event
    mail(:to => event.user.email, :subject => "Remind - #{event.title} at #{event.created_at.strftime("%Y-%m-%d %H:%M")}")
  end
end

