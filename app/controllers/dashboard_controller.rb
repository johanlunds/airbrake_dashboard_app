class DashboardController < ApplicationController
  http_basic_authenticate_with(
    name:     Rails.configuration.http_auth_username,
    password: Rails.configuration.http_auth_password
  )

  def show
    @errors = ErrorDecorator.decorate_collection(airbrake_client.errors)
  end

  private

  def airbrake_client
    @airbrake_client ||= AirbrakeAPI::Client.new(
      account:    Rails.configuration.airbrake_account, 
      auth_token: Rails.configuration.airbrake_auth_token, 
      secure:     true,
    )
  end
end


