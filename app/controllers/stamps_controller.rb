class StampsController < ApplicationController
  before_action :set_stamp, only: [:show, :edit, :update, :destroy]
  before_action :find_available_stamps, only: [:giveaway, :damage]

  # def search
  #     @stamps = Stamp.search(params[:search]).sort_by &:id
  # end

  def index
    if params[:search]
      # @start_date = 7.days.ago
      # @stamps = Stamp.search(start_date).sort_by &:id
      @stamps = Stamp.search(params[:search]).sort_by &:id
    else
      @stamps = Stamp.all.sort_by &:id
      @inventory = Stamp.inventory.count
      @giveaway = Stamp.giveaways
      @damage = Stamp.damages
    end
  end

  def show
  end

  # GET /stamps/new
  def new
    @stamp = Stamp.new
  end

  # GET /stamps/1/edit
  def edit
  end

  # POST /stamps
  # POST /stamps.json
  def create
    # @stamp = Stamp.new(stamp_params)
    2.times do
      @stamp = Stamp.create
    end
    
    respond_to do |format|
      if @stamp.save
        format.html { redirect_to stamps_url, notice: 'Two stamps were successfully created.' }
        format.json { render :show, status: :created, location: @stamp }
      else
        format.html { render :new }
        format.json { render json: @stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  def giveaway
    respond_to do |format|
      if @stamp_exists && @stamps.count > 1
        @stamps.each do |stamp|
          stamp.update(giveaway: true)
        end
        format.html { redirect_to stamps_url, notice: 'Two stamps successfully given away.' }
        format.json { render :show, status: :ok, location: @stamp }
      else
        format.html { redirect_to stamps_url, alert: 'Not enough stamps to give away.' }
        format.json { render json: @stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  def damage
    respond_to do |format|
      if @stamp_exists
        @stamp.update(damage: true)
        format.html { redirect_to stamps_url, notice: 'One stamp successfully marked as damaged.' }
        format.json { render :show, status: :ok, location: @stamp }
      else
        format.html { redirect_to stamps_url, alert: 'There are no stamps in inventory.' }
        format.json { render json: @stamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /stamps/1
  # # PATCH/PUT /stamps/1.json
  # def update
  #   respond_to do |format|
  #     if @stamp.update(stamp_params)
  #       format.html { redirect_to @stamp, notice: 'Stamp was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @stamp }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @stamp.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_students] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end


  # DELETE /stamps/1
  # DELETE /stamps/1.json
  def destroy
    @stamp.destroy
    respond_to do |format|
      format.html { redirect_to stamps_url, notice: 'Stamp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stamp
      @stamp = Stamp.find(params[:id])
    end

    def find_available_stamps
      @stamp_exists = Stamp.available.exists?
      @stamps = Stamp.available
      @stamp = @stamps.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stamp_params
      params.require(:stamp).permit(:devkit, :damage, :giveaway)
    end
end
