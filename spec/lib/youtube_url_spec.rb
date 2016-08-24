require 'rails_helper'

RSpec.describe YoutubeUrl do
  context "valid YouTube URL" do
    subject(:youtube_url){ YoutubeUrl.new(url) }
    describe "without time" do
      let(:url) { "https://www.youtube.com/watch?v=5KtKMLCsA-k" }
      it "returns an array with video id and time in seconds" do
        expect(youtube_url.process).to eq ['5KtKMLCsA-k', nil]
      end
    end
    describe "with time mark" do
      let(:url) { "https://www.youtube.com/watch?v=5KtKMLCsA-k&t=2m2s" }

      it "returns an array with video id and time in seconds" do
        expect(youtube_url.process).to eq ['5KtKMLCsA-k', 122]
      end
    end
  end

  context "valid Youtu.Be URL" do
    subject(:youtube_url){ YoutubeUrl.new(url) }
    describe "without time" do
      let(:url) { "https://youtu.be/5KtKMLCsA-k" }
      it "returns an array with video id and time in seconds" do
        expect(youtube_url.process).to eq ['5KtKMLCsA-k', nil]
      end
    end
    describe "with time mark" do
      let(:url) { "https://youtu.be/5KtKMLCsA-k?t=2m2s" }

      it "returns an array with video id and time in seconds" do
        expect(youtube_url.process).to eq ['5KtKMLCsA-k', 122]
      end
    end
  end

  context "empty URL" do
    let(:url) { "" }
    subject(:youtube_url){ YoutubeUrl.new(url) }
    it "returns an array with two nils" do
      expect(youtube_url.process).to eq [nil, nil]
    end
  end

  context "nil URL" do
    let(:url) { nil }
    subject(:youtube_url){ YoutubeUrl.new(url) }
    it "returns an array with two nils" do
      expect(youtube_url.process).to eq [nil, nil]
    end
  end

  context "invalid URL" do
    context "which looks like url" do
      let(:url) { 'https://vimeo.com/1234567' }
      subject(:youtube_url){ YoutubeUrl.new(url) }
      it "returns an array with two nils" do
        expect{youtube_url.process}.to raise_error YoutubeUrl::Invalid
      end
    end
    context "which does not look like url" do
      let(:url) { 'https-://vimeo .com/' }
      subject(:youtube_url){ YoutubeUrl.new(url) }
      it "returns an array with two nils" do
        expect{youtube_url.process}.to raise_error YoutubeUrl::Invalid
      end
    end
  end
end
