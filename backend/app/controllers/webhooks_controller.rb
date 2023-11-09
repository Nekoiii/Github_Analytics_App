class WebhooksController < ApplicationController
  before_action :verify_github_webhook, only: [:github]

  # Handle webhook notifications from GitHub
  def github
    # Convert JSON to hash
    payload = JSON.parse(request.body.read)

    Rails.logger.info "WebhooksController -- github - payload: #{payload.inspect} "

    handle_event(request.headers['X-GitHub-Event'])

    # Send a 200 OK status to Webhook Url
    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse JSON: #{e.message}"
    head :bad_request
  end

  private

  # Handle different event_type
  def handle_event(event_type)
    Rails.logger.info "WebhooksController -- event_type: #{event_type}"

    case event_type
    when 'push'
      Rails.logger.info 'WebhooksController -- event_type -- push'
    when 'pull_request'
      Rails.logger.info 'WebhooksController -- event_type -- pull_request'
    else
      Rails.logger.info "WebhooksController -- event_type(else) -- #{event_type}"
    end
  end

  # Verify if the request is from GitHub.
  # This is a security measure that ensures that only
  # requests with the correct signature can be processed.
  def verify_github_webhook
    request_body = request.body.read

    Rails.logger.info "verify_github_webhook -- request_body--: #{request_body}"

    # Create a HMAC (Hash-based Message Authentication Code) using
    # the SHA1 hashing algorithm and the WEBHOOK_SECRET key to
    # generate a unique signature for the message.
    # signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('WEBHOOK_SECRET', nil),
    signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('WEBHOOK_SECRET', nil),
                                                request_body)}"

    # Compare the signature we just generated with the
    # signature sent by GitHub in the webhook request header
    # to see if they are equal.
    return if Rack::Utils.secure_compare(signature, request.headers['X-Hub-Signature'])

    Rails.logger.error 'Invalid webhook signature'
    head :forbidden
  end
end
