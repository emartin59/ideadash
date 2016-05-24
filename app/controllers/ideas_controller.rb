class IdeasController < ApplicationController
  load_and_authorize_resource :user, only: [:index]
  load_and_authorize_resource :idea, through: :user, shallow: true

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = @ideas.includes(:user) unless @user
    @ideas = @ideas.current if params[:filter] == 'current'
    @ideas = @ideas.safe_order(params[:order].to_sym) if params[:order]
  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
  end

  # GET /ideas/new
  def new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas
  # POST /ideas.json
  def create
    respond_to do |format|
      if @idea.save
        format.html { redirect_to @idea, notice: 'Idea was successfully created.' }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1
  # PATCH/PUT /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Idea was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:title, :summary, :description, :tos_accepted)
    end
end
