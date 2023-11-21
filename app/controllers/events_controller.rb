class EventsController < ApplicationController
  require 'dotenv/load'
  include HTTParty

  base_uri 'https://api.iterable.com/api'

  def index
  end

  def create_event_a
    response = send_event('EventA')
    render json: response
  end

  def create_event_b
    response = send_event('EventB')
    send_notification(response.email) if response_successful?(response)
    render json: response
  end

  def search_and_notify
    events_b = search_events('EventB')

    events_b.each do |event|
      send_notification(event['email'])
    end

    render json: { message: 'Notifications sent for Event B' }
  end

  private

  def send_event(eventName)
    response = self.class.post(
      '/events/track',
      headers: {
        'Content-Type' => 'application/json',
        'Api-Key' => ENV['ITERABLE_API_KEY']
      },
      body: {
        email: 'neelam.jain.gour@gmail.com',
        eventName: eventName
      }.to_json
    )

    response.parsed_response
  end

  def search_events(eventName)
    response = self.class.post(
      '/events/search',
      headers: {
        'Content-Type' => 'application/json',
        'Api-Key' => ENV['ITERABLE_API_KEY']
      },
      body: {
        eventName: eventName
      }.to_json
    )

    response.parsed_response['data']
  end

  def send_notification(email)
    email_data = {
      to: email,
      subject: 'Notification for Event B',
      body: 'This is the email content for Event B notification.'
    }

    response = HTTParty.post("#{@api_base_url}/api/email/send", {
      headers: @headers,
      body: email_data.to_json
    })

    if response.success?
      flash[:notice] = 'Email notification sent successfully!'
    else
      flash[:alert] = 'Failed to send email notification.'
    end
  end

  def response_successful?(response)
    if response.success?
      return true
    else
      Rails.logger.error("API request failed with status code #{response.code}: #{response.body}")
      return false
    end
  end
end
