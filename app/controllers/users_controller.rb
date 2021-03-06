class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

	require 'securerandom'

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
		@events = User.find(session[:user_id]).events
		@friends = friends()
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

	def friends
	  user = User.find(session[:user_id])
		@graph = Koala::Facebook::API.new(user.auth_token)
		friends = @graph.get_connections("me", "friends")
		return friends
	end

	def create_from_facebook
	  oauth_hash = request.env['omniauth.auth']

		auth_token = oauth_hash["credentials"]["token"]
		uid = oauth_hash["uid"]
		name = oauth_hash["info"]["name"]
		email = oauth_hash["info"]["email"]

		if (User.where("uid = ?", uid).empty?)
			@user = User.create({:email => email, :auth_token => auth_token, :uid => uid, :name => name})
			session[:user_id] = @user.id
			redirect_to session[:url]
		else
			session[:user_id] = User.find(:first, :conditions => ["uid = ?", uid]).id
			redirect_to session[:url]
# give something back
		end

    # raise .inspect.to_s
	end

	def create_new_event
		@user = User.find(session[:user_id])
		hash = SecureRandom.hex(8)
		@event = @user.events.create({ :event_hash => hash, :status => "created", :start_date => Time.now, :end_date => nil, :money_limit => 0, :host_id => @user.id, :has_started => false})
		session[:event_id] = @event.id
		redirect_to "/event/" + hash + "/edit"
	end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

	def log_out
		session[:user_id] = nil
		redirect_to "/"
	end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :auth_token, :uid)
    end
end
