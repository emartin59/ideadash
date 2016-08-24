class YoutubeUrl
  class Invalid < StandardError; end

  attr_accessor :url

  TIME_METHODS = %w(hours minutes seconds)
  VIDEO_URL_REGEXP = /(?:(?:https?:\/\/)(?:www)?\.?(?:youtu\.?be)(?:\.com)?\/(?:.*[=\/])*)([^= &?\/\r\n]{8,11})/

  def initialize url
    @url = URI.parse(url.presence || '')
  rescue URI::InvalidURIError
    raise YoutubeUrl::Invalid
  end

  def process
    if url.to_s.blank?
      return nil, nil
    elsif like_youtube?
      return youtube_com
    end
    raise YoutubeUrl::Invalid
  end

  def self.convert_back video_id, video_time
    return '' if video_id.blank?
    str = "https://youtu.be/#{ video_id }"
    str += "?t=#{video_time}" if video_time.present?
    str
  end

  private
  def youtube_com
    [video_id, time]
  end

  def video_id
    @url.to_s.match(VIDEO_URL_REGEXP)[1]
  end

  def queries
    return {} if @url.query.blank?
    @url.query.split('&').map{ |q| q.split('=') }.to_h
  end

  def like_youtube?
    @url.to_s.match(VIDEO_URL_REGEXP).present?
  end

  def is_youtu_be?
  end

  def time
    return nil if queries['t'].blank?
    mthds = TIME_METHODS.dup
    queries['t'].
        split(/[a-z]/).
        reverse.
        map(&:to_i).
        inject(0) { |tmp, n| tmp + n.send(mthds.pop) }
  end
end
