require "application_system_test_case"

class PollsTest < ApplicationSystemTestCase
  setup do
    @poll = polls(:one)
  end

  test "visiting the index" do
    visit polls_url
    assert_selector "h1", text: "Polls"
  end

  test "should create poll" do
    visit polls_url
    click_on "New poll"

    fill_in "Expires at", with: @poll.expires_at
    fill_in "Max choices", with: @poll.max_choices
    fill_in "Poll type", with: @poll.poll_type
    fill_in "Question", with: @poll.question
    fill_in "Status", with: @poll.status
    fill_in "User", with: @poll.user_id
    click_on "Create Poll"

    assert_text "Poll was successfully created"
    click_on "Back"
  end

  test "should update Poll" do
    visit poll_url(@poll)
    click_on "Edit this poll", match: :first

    fill_in "Expires at", with: @poll.expires_at.to_s
    fill_in "Max choices", with: @poll.max_choices
    fill_in "Poll type", with: @poll.poll_type
    fill_in "Question", with: @poll.question
    fill_in "Status", with: @poll.status
    fill_in "User", with: @poll.user_id
    click_on "Update Poll"

    assert_text "Poll was successfully updated"
    click_on "Back"
  end

  test "should destroy Poll" do
    visit poll_url(@poll)
    click_on "Destroy this poll", match: :first

    assert_text "Poll was successfully destroyed"
  end
end
