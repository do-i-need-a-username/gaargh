# frozen_string_literal: true
require_relative "gaargh/version"
require 'google/apis/iamcredentials_v1'
require 'logger'

module Gaargh
  class Error < StandardError; end
  class << self
    attr_writer :logger
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  # Returns an impersonated credentials client to be used with the GCP clients
  # impersonated_credentials_client  = Gaargh.impersonate_service_account(service_account_email: 'my-service-account@my-project-id.iam.gserviceaccount.com')
  # e.g. storage = Google::Cloud::Storage.new(credentials: impersonated_credentials_client, project_id: 'your-storage-project-id')
  #
  # @param [String] service_account_email - the email of the service account to impersonate (e.g. 'my-service-account@my-project-id.iam.gserviceaccount.com')
  # @param [String] lifetime - the lifetime of the access token in seconds (default: 3600s)
  # @param [Array] scopes - the scopes to be used with the access token (default: ['https://www.googleapis.com/auth/cloud-platform'])
  # @return [Signet::OAuth2::Client] client - the client to be used with GCP clients
  def self.impersonate_service_account(service_account_email: '', lifetime: '3600s', scopes: ['https://www.googleapis.com/auth/cloud-platform'])
    creds_service = Google::Apis::IamcredentialsV1::IAMCredentialsService.new

    creds_service.authorization = Google::Auth.get_application_default(scopes)

    generate_token_request = Google::Apis::IamcredentialsV1::GenerateAccessTokenRequest.new(
        lifetime: lifetime,
        scope: ['https://www.googleapis.com/auth/cloud-platform']
    )

    impersonated_account = creds_service.generate_service_account_access_token("projects/-/serviceAccounts/#{service_account_email}", generate_token_request)
    client = Signet::OAuth2::Client.new
    client.access_token = impersonated_account.access_token
    return client
  end

  # Returns information about the access token provided e.g. expiration time, email address etc.
  #
  # @param [String] access_token - the access token to retrieve information about
  # @return [Hash] token_info - a hash containing information about the access token, error informaiton if the request fails
  def self.token_expiration_time(access_token:)
    uri = URI.parse("https://oauth2.googleapis.com/tokeninfo?access_token=#{access_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    if response.code == '200'
      data = JSON.parse(response.body)
      expiration_time = Time.at(data['exp'].to_i)
      logger.info("Token expires at: #{expiration_time}")
      logger.debug("token_info: #{data}")
      token_info = {
        token_data: data,
        token_expiration_time: expiration_time
      }
      return token_info
    else
      error_hash = {
        error: "Failed to retrieve token information",
        response_code: response.code,
        response_body: response.body
      }
      logger.error("Error retrieving token information: response.code: #{response.code}, response.body: #{response.body}")
      return error_hash
    end
  end
end
