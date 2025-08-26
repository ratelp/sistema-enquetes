class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_poll

  def create
    if @poll.closed?
      redirect_to @poll, alert: t("polls.votes.create.closed")
      return
    end

    if @poll.voted_by?(current_user)
      redirect_to @poll, alert: t("polls.votes.create.already_voted")
      return
    end

    if @poll.unica_escolha?
      handle_single_choice_vote
    elsif @poll.multipla_escolha?
      handle_multiple_choice_vote
    else
      redirect_to @poll, alert: "Invalid poll type."
    end
  end

  private

  def set_poll
    @poll = Poll.find(params[:poll_id])

    if @poll.expired? && @poll.open?
      @poll.update(status: :closed)
    end
  end

  def vote_params
    params.require(:vote).permit(:poll_option_id, poll_option_ids: [])
  end

  def handle_single_choice_vote
    option_id = vote_params[:poll_option_id]
    redirect_to(@poll, alert: t("polls.votes.create.no_option"), status: :unprocessable_entity) and return if option_id.blank?

    option = @poll.poll_options.find_by(id: option_id)
    redirect_to(@poll, alert: t("polls.votes.create.invalid_option"), status: :unprocessable_entity) and return if option.nil?

    current_user.votes.create(poll_option: option)
    redirect_to @poll, notice: t("polls.votes.create.success")
  end

  def handle_multiple_choice_vote
    option_ids = vote_params[:poll_option_ids].reject(&:blank?)

    redirect_to(@poll, alert: t("polls.votes.create.no_options"), status: :unprocessable_entity) and return if option_ids.empty?
    
    redirect_to(@poll, alert: t("polls.votes.create.too_many_options", count: @poll.max_choices), status: :unprocessable_entity) and return if option_ids.count > @poll.max_choices

    
    valid_options = @poll.poll_options.where(id: option_ids)
    redirect_to(@poll, alert: t("polls.votes.create.invalid_option"), status: :unprocessable_entity) and return if valid_options.count != option_ids.count

    ActiveRecord::Base.transaction do
      valid_options.each do |option|
        current_user.votes.create!(poll_option: option)
      end
    end
    redirect_to @poll, notice: t("polls.votes.create.success")
  rescue ActiveRecord::RecordInvalid
    redirect_to @poll, alert: t("polls.votes.create.error"), status: :unprocessable_entity
  end
end
