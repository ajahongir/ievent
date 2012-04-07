class EventMailer < ActionMailer::Base
  default :from => "brrrr@gmail.com"
 
  def event_email(user, event)
    @user = user
    @event = event
    mail(:to => user.email, :subject => "Remind - #{event.title} at #{event.created_at.strftime("%Y-%m-%d %H:%M")}")
  end
end
