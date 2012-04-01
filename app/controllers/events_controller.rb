class EventsController < ApplicationController

	before_filter :authenticate_user!
  before_filter :check_date, :only => [:create, :update]

	def index
		if request.xhr?
			result = current_user.events.map {|event|
				record = {:id => event.id, :title => event.title.to_s, :allDay => event.allDay, :start => event.from, :end => event.to, :repeat => event.repeat || Event.notify_types.first, :className => (event.repeat || Event.notify_types.first).downcase}
			}
			render :json => result.to_json
		end
	end

	def list
    @events = current_user.events
  end

	def create
	  event = current_user.events.create(:title => params[:title], :repeat => params[:repeat], :from => @from, :to => @to, :allDay => @allDay)
		render :json => {:id => event.id, :success => true}
	end

	def update
		event = Event.find(params[:id])
		event.update_attributes({:title => params[:title], :repeat => params[:repeat], :from => @from, :to => @to, :allDay => @allDay})
		render :nothing => true
	end

	def destroy
  	@event = current_user.events.find(params[:id])
		render :nothing => true and return unless @event
		@event.destroy
	end

  private

  def check_date
    @allDay = params[:allDay].eql?("true")
    @from = DateTime.strptime(params[:start], "%Y-%m-%d-%H-%M")
    @to = ((params[:allDay].eql?("true") || params[:end].blank?) ? nil : DateTime.strptime(params[:end], "%Y-%m-%d-%H-%M"))
  end

end

