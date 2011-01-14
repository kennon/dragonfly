require 'spec_helper'
require 'dragonfly/processing/shared_processing_spec'

describe Dragonfly::Processing::ImageMagickProcessor do
  
  before(:each) do
    sample_file = File.dirname(__FILE__) + '/../../../samples/beach.png' # 280x355
    @image = Dragonfly::TempObject.new(File.new(sample_file))
    @processor = Dragonfly::Processing::ImageMagickProcessor.new
  end

  it_should_behave_like "processing methods"
  
  describe "convert" do
    it "should allow for general convert commands" do
      image = @processor.convert(@image, '-scale 56x71')
      image.should have_width(56)
      image.should have_height(71)
    end
    it "should allow for general convert commands with added format" do
      image, extra = @processor.convert(@image, '-scale 56x71', :gif)
      image.should have_width(56)
      image.should have_height(71)
      image.should have_format('gif')
      extra[:format].should == :gif
    end
  end

  describe "composite" do
    before(:each) do
      unwatermarked_filename = File.dirname(__FILE__) + '/../../../samples/unwatermarked.jpg' # 600x600
      @image_to_watermark = Dragonfly::TempObject.new(File.new(unwatermarked_filename))
      @watermark_filename = File.dirname(__FILE__) + '/../../../samples/watermark.png'
    end

    it "allow for general composite commands" do
      lambda {
        @processor.composite(@image_to_watermark, "-tile #{@watermark_filename}")
      }.should_not raise_error
    end

    it "should not change original image dimensions or format" do
      image = @processor.composite(@image_to_watermark, "-tile #{@watermark_filename}")
      image.should have_width(600)
      image.should have_height(600)
      image.should have_format('jpeg')
    end
  end

  describe "watermark" do
    before(:each) do
      unwatermarked_filename = File.dirname(__FILE__) + '/../../../samples/unwatermarked.jpg' # 600x600
      @image_to_watermark = Dragonfly::TempObject.new(File.new(unwatermarked_filename))
      @watermark_filename = File.dirname(__FILE__) + '/../../../samples/watermark.png'
    end

    it "should not change original image dimensions or format" do
      watermarked_image = @processor.watermark(@image_to_watermark, @watermark_filename)
      watermarked_image.should have_width(600)
      watermarked_image.should have_height(600)
      watermarked_image.should have_format('jpeg')
    end
  end
  
end
