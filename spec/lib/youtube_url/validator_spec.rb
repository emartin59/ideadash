require 'rails_helper'

class Validatable
  include ActiveModel::Validations
  attr_accessor  :video_url
  validates :video_url, youtube_url: true
end

describe YoutubeUrlValidator do
  subject { Validatable.new }

  context 'without video_url' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'with valid video_url' do
    it 'is valid' do
      subject.video_url = 'https://www.youtube.com/watch?v=5KtKMLCsA-k'

      expect(subject).to be_valid
    end
  end

  context 'with invalid video_url' do
    it 'is invalid' do
      subject.video_url = 'youtube'

      expect(subject).not_to be_valid
      expect(subject.errors[:video_url]).to eq ["This URL is invalid"]
    end
  end
end