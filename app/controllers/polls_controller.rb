class PollsController < ApplicationController
  before_action :set_poll, only: %i[ show edit update destroy close ]
  before_action :authenticate_user!

  # GET /polls or /polls.json
  def index
    @polls = Poll.includes(poll_options: :votes).all
  end
  
  # GET /ownPolls
  def ownPolls
    @polls = current_user.polls.includes(poll_options: :votes)
  end

  # GET /votedPolls

  def votedPolls
    @polls = Poll.joins(:votes).where(votes: { user_id: current_user.id }).distinct.includes(poll_options: :votes)
  end

  # GET /polls/1 or /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
    3.times { @poll.poll_options.build }
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls or /polls.json
  def create
    @poll = current_user.polls.build(poll_params)

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: t(".success") }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1 or /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: t(".success"), status: :see_other }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1 or /polls/1.json
  def destroy
    @poll.destroy!

    respond_to do |format|
      format.html { redirect_to polls_path, notice: t(".success"), status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /polls/1/close
  def close
    if current_user != @poll.user
      redirect_to @poll, alert: t(".unauthorized") and return
    end

    if @poll.open?
      @poll.update(status: :closed)
      redirect_to @poll, notice: t(".success")
    else
      redirect_to @poll, alert: t(".already_closed")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.includes(poll_options: :votes).find(params[:id])

      # Automatically close the poll if it's expired and still open.
      if @poll.expired? && @poll.open?
        @poll.update(status: :closed)
      end
    end


    # Only allow a list of trusted parameters through.
    def poll_params
      params.require(:poll).permit(:question, :poll_type, :expires_at, :max_choices, poll_options_attributes: [ :id, :text, :_destroy ])
    end
end
