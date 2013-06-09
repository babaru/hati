class Manager::GosController < ApplicationController
  before_filter :authenticate_user!

  # GET /manager/gos
  # GET /manager/gos.json
  def index
    @gos_grid = initialize_grid(Go)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gos_grid }
    end
  end

  # GET /manager/gos/1
  # GET /manager/gos/1.json
  def show
    @go = Go.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @go }
    end
  end

  # GET /manager/gos/new
  # GET /manager/gos/new.json
  def new
    @go = Go.new
    code = RandomAlphaGenerator.generate
    while Go.find_by_code(code)
      code = RandomAlphaGenerator.generate
    end
    @go.code = code

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @go }
    end
  end

  # GET /manager/gos/1/edit
  def edit
    @go = Go.find(params[:id])
  end

  # POST /manager/gos
  # POST /manager/gos.json
  def create
    @go = Go.new(params[:go])
    api = SinaWeibo::Api::UrlShortener.new Settings.app.sina_weibo_access_token
    @go.sina_weibo_shorten_url = api.shorten "#{request.protocol}#{request.host_with_port}/go/#{@go.code}"

    respond_to do |format|
      if @go.save
        format.html { redirect_to manager_gos_path(), notice: 'Go was successfully created.' }
        format.json { render json: @go, status: :created, location: @go }
      else
        format.html { render action: "new" }
        format.json { render json: @go.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manager/gos/1
  # PATCH/PUT /manager/gos/1.json
  def update
    @go = Go.find(params[:id])
    @go.code = params[:go][:code]
    @go.url = params[:go][:url]
    if @go.code_changed?
      api = SinaWeibo::Api::UrlShortener.new Settings.app.sina_weibo_access_token
      @go.sina_weibo_shorten_url = api.shorten "#{request.protocol}#{request.host_with_port}/go/#{@go.code}"
    end

    respond_to do |format|
      if @go.save
        format.html { redirect_to manager_gos_path(), notice: 'Go was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @go.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/gos/1
  # DELETE /manager/gos/1.json
  def destroy
    @go = Go.find(params[:id])
    @go.destroy

    respond_to do |format|
      format.html { redirect_to manager_gos_url }
      format.json { head :no_content }
    end
  end
end
