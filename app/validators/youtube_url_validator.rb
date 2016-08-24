class YoutubeUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    YoutubeUrl.new(value).process
  rescue YoutubeUrl::Invalid
    record.errors[attribute] << (options[:message] || "This URL is invalid")
  end
end
