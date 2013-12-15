class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

	def start_event
		@event = Event.find(session[:event_id])
	end

  # GET /events
  # GET /events.json
  def index
		session[:url] = '/'
		if session[:user_id] == nil
			redirect_to "/auth/facebook"	
		end
  end

	def show_events
		@events = User.find(session[:user_id]).events
	end

  # GET /events/1
  # GET /events/1.json
  def show
		@current_user = User.find(session[:user_id])
		@event = Event.find_by_event_hash(params[:event_hash])
		@participants = @event.users
		session[:event_id] = @event.id
		if (session[:user_id] == nil) 
			session[:url] = request.original_url
			redirect_to '/'
			#render==redirect login page
			#save url
		else
			@is_host = false
			if (session[:user_id] == @event.host_id)
				@is_host = true
			end
		end
  end

	def join_event
		unless Event.find(session[:event_id]).users.include?(session[:user_id])
			UserToEvent.create({ :user_id => session[:user_id], :event_id => session[:event_id]})
			redirect_to "/event/" + Event.find(session[:event_id]).event_hash
		end
	end

	def start_event
		#s-a terrminat smecheria!
		@users = UserToEvent.where("event_id = ?", session[:event_id]).pluck(:user_id)
		@users.shuffle
		@users.each_cons(2) do |id1, id2|
			UserToEvent.where("event_id = ? AND user_id = ?", session[:event_id], id1).first.update_attributes(:receiver_id => id2)
		end
#last person give present to first
		UserToEvent.where("event_id = ? AND user_id = ?", session[:event_id], @users.last).first.update_attributes(:receiver_id => @users.first)
		Event.find(session[:event_id]).update_attributes(:has_started => true, :status => "started")
#redirect to ceva?
		redirect_to "/event/" + Event.find(session[:event_id]).event_hash
	end

	def stop_event
		Event.find(session[:event_id]).update_attributes(:status => "finished")
		redirect_to "/event/" + Event.find(session[:event_id]).event_hash
	end	

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by_event_hash(params[:event_hash])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:start_date, :end_date, :status, :money_limit, :host_id, :has_started)
    end
end
