class OrientationsController < ApplicationController
	before_filter :authorize, :except => [:index, :show]
  # GET /orientations
  # GET /orientations.json
  def index
    @orientations = Orientation.all
    @orientation_by_date = @orientations.group_by(&:class_date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orientations }
    end
  end

  # GET /orientations/1
  # GET /orientations/1.json
  def show
    @orientation = Orientation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orientation }
    end
  end

  # GET /orientations/new
  # GET /orientations/new.json
  def new
    @orientation = Orientation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orientation }
    end
  end

  # GET /orientations/1/edit
  def edit
    @orientation = Orientation.find(params[:id])
  end

  # POST /orientations
  # POST /orientations.json
  def create
		from_date = Date.parse(params[:from_date])
		if params[:to_date] != '' #do this only if to_date is not empty
			to_date = Date.parse(params[:to_date])
			if params[:ignored_days] #do this if any of the days are checked
      	date_range = (from_date..to_date).to_a
				date_range.each do |r|
  				next if params[:ignored_days].include? r.wday.to_s
  				params[:orientation][:class_date] = r
  				@orientation = Orientation.new(params[:orientation])
  				@orientation.save
				end			

			else #else create an orientation for each day
				to_date = Date.parse(params[:to_date])
				from_date = Date.parse(params[:from_date])
      	date_range = (from_date..to_date).to_a
				date_range.each do |r|
					next if [0,6].include? r.wday #this excludes Sat/Sunday
					params[:orientation][:class_date] = r
					@orientation = Orientation.new(params[:orientation])
					@orientation.save
				end
			end
  	else #if to_date is empty just create a single orientation
      params[:orientation][:class_date] = params[:from_date]
    	@orientation = Orientation.new(params[:orientation])
    	@orientation.save
	  end

    respond_to do |format|
      if @orientation.save
        format.html { redirect_to orientations_path, notice: 'Orientation was successfully created.' }
        format.json { render json: @orientation, status: :created, location: @orientation }
      else
        format.html { render action: "new" }
        format.json { render json: @orientation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orientations/1
  # PUT /orientations/1.json
  def update
    @orientation = Orientation.find(params[:id])
		if @orientation.active == false #open orientation if its full
				@orientation.active = true
		end

    respond_to do |format|
      if @orientation.update_attributes(params[:orientation])
        format.html { redirect_to @orientation, notice: 'Orientation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orientation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orientations/1
  # DELETE /orientations/1.json
  def destroy
    @orientation = Orientation.find(params[:id])
		registrations = @orientation.registrations
		registrations.each do |r|
			NsoMailer.after_cancellation_email(r).deliver
			r.destroy
		end
    @orientation.destroy

    respond_to do |format|
      format.html { redirect_to orientations_url }
      format.json { head :no_content }
    end
  end
end
