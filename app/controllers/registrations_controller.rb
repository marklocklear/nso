class RegistrationsController < ApplicationController
	before_filter :authorize, :only => [:index, :all_registrations, :find_by_student_id, :find_by_class_date,
																			:find_by_name, :find_by_registration_date]
  # GET /registrations
  # GET /registrations.json
  def index
		if params[:orientation_id] != nil
			@orientation = Orientation.find params[:orientation_id]
			@registrations = Registration.where(orientation_id: @orientation, cancelled: false).
												paginate(:page => params[:page], :per_page => 100)
		else
			registrations = Registration.where :orientation_id => nil
			@registrations= registrations.sort {|vn1, vn2| vn2[:created_at] <=> vn1[:created_at]}.
											paginate(:page => params[:page], :per_page => 100)
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registrations }
    end
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
    @registration = Registration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.json
  def new
    @registration = Registration.new
		@registration.orientation = Orientation.find params[:orientation_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find(params[:id])
  end

  # POST /registrations
  # POST /registrations.json
  def create
		@registration = Registration.new(params[:registration])

    respond_to do |format|
      if @registration.save
				if @registration.orientation != nil #TODO replace this with an online? method
        	format.html { render "scheduling_text.html.erb" }
        	format.json { render json: @registration, status: :created, location: @registration }
					NsoMailer.registration_email(@registration).deliver
				else
        	format.html { render "online_scheduling_text.html.erb" } 
        	format.json { render json: @registration, status: :created, location: @registration }
					NsoMailer.online_registration_email(@registration).deliver
				end
      else
        format.html { render action: "new" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /registrations/1
  # PUT /registrations/1.json
  def update
    @registration = Registration.find(params[:id])
		
    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # Registrations are never destroyed. If they are cancelled, the 'cancelled' flag is set to true
  def destroy
    @registration = Registration.find(params[:id])
		@registration.cancelled = true
		@registration.save

		#if orienation is closed, re-open it
		if  @registration.orientation != nil #ignore online registration
			orientation = @registration.orientation
			if orientation.active == false
				orientation.active = true
				orientation.save
			end
		end

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Registration was successfully canceled.' }
      format.json { head :no_content }
			NsoMailer.after_cancellation_email(@registration).deliver
    end
  end

	def online
    @registration = Registration.new
	end

  def toggle
    @registration = Registration.find(params[:id])
    @registration.update_attributes(:checked_in => params[:checked_in])
    render :nothing => true
  end

	def all_registrations
		registrations = Registration.all
		@registrations= registrations.sort {|vn1, vn2| vn2[:created_at] <=> vn1[:created_at]}.
											paginate(:page => params[:page], :per_page => 100)
	end

	def find_by_class_date
		@class_date = params[:class_date]
		@registrations = Registration.includes(:orientation).
											where(orientations: {:class_date => @class_date})
	end

	def find_by_registration_date
		@registration_date = params[:registration_date]
		@registrations = Registration.where("DATE(created_at) = ? ", @registration_date)
		@wintas = Registration.order :first_name
		respond_to do |format|
			format.html
			format.csv { send_data @registrations.to_csv }
		end
	end

	def find_by_student_id
		@student_id = params[:student_id]
		@registrations = Registration.where(:student_id => @student_id)
	end

	def find_by_name
		@name = '%' + params[:name].downcase + '%'
 		@registrations = Registration.find(:all, :conditions =>
											['lower(first_name) LIKE ? OR lower(last_name) LIKE ?', @name, @name])
	end
end
