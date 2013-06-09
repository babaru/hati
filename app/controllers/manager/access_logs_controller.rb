class Manager::AccessLogsController < ApplicationController
  # GET /manager/access_logs
  # GET /manager/access_logs.json
  def index
    if params[:go_id]
      @access_logs_grid = initialize_grid(AccessLog.where(go_id: params[:go_id]))
    else
      @access_logs_grid = initialize_grid(AccessLog)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @access_logs_grid }
    end
  end

  # GET /manager/access_logs/1
  # GET /manager/access_logs/1.json
  def show
    @access_log = AccessLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @access_log }
    end
  end

  # GET /manager/access_logs/new
  # GET /manager/access_logs/new.json
  def new
    @access_log = AccessLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @access_log }
    end
  end

  # GET /manager/access_logs/1/edit
  def edit
    @access_log = AccessLog.find(params[:id])
  end

  # POST /manager/access_logs
  # POST /manager/access_logs.json
  def create
    @access_log = AccessLog.new(params[:access_log])

    respond_to do |format|
      if @access_log.save
        format.html { redirect_to manager_access_log_path(@access_log), notice: 'Access log was successfully created.' }
        format.json { render json: @access_log, status: :created, location: @access_log }
      else
        format.html { render action: "new" }
        format.json { render json: @access_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manager/access_logs/1
  # PATCH/PUT /manager/access_logs/1.json
  def update
    @access_log = AccessLog.find(params[:id])

    respond_to do |format|
      if @access_log.update_attributes(params[:access_log])
        format.html { redirect_to manager_access_log_path(@access_log), notice: 'Access log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @access_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/access_logs/1
  # DELETE /manager/access_logs/1.json
  def destroy
    @access_log = AccessLog.find(params[:id])
    @access_log.destroy

    respond_to do |format|
      format.html { redirect_to manager_access_logs_url }
      format.json { head :no_content }
    end
  end
end
