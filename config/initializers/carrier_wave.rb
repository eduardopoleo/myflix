CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['AWSKEYID'],                        # required
      :aws_secret_access_key  => ENV['AWSKEYACCESS']                        # required
    }
    config.fog_directory  = ENV['BUCKET']                          # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
