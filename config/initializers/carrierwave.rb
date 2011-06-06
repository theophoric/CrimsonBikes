StringIO.class_eval { def original_filename; "stringio.txt"; end }

CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'
  config.storage = :s3
  config.s3_access_key_id = 'AKIAICZOJNDMXYASZLUA'
  config.s3_secret_access_key = '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'
  
  if Rails.env.production?
    config.s3_bucket    =  'crimsonbikes-production'
  else
    config.s3_bucket    =  'crimsonbikes-development'
  end
  
end
