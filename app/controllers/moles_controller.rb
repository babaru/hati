class MolesController < ApplicationController
  # GET /moles
  # GET /moles.json
  def index
    @moles = Mole.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moles }
    end
  end

  # GET /moles/1
  # GET /moles/1.json
  def show
    @mole = Mole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mole }
    end
  end

  # GET /moles/new
  # GET /moles/new.json
  def new
    @mole = Mole.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mole }
    end
  end

  # GET /moles/1/edit
  def edit
    @mole = Mole.find(params[:id])
  end

  # POST /moles
  # POST /moles.json
  def create
    @mole = Mole.new(params[:mole])

    respond_to do |format|
      if @mole.save
        format.html { redirect_to @mole, notice: 'Mole was successfully created.' }
        format.json { render json: @mole, status: :created, location: @mole }
      else
        format.html { render action: "new" }
        format.json { render json: @mole.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /moles/1
  # PUT /moles/1.json
  def update
    @mole = Mole.find(params[:id])

    respond_to do |format|
      if @mole.update_attributes(params[:mole])
        format.html { redirect_to @mole, notice: 'Mole was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mole.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moles/1
  # DELETE /moles/1.json
  def destroy
    @mole = Mole.find(params[:id])
    @mole.destroy

    respond_to do |format|
      format.html { redirect_to moles_url }
      format.json { head :no_content }
    end
  end
end
