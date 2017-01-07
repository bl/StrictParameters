require 'spec_helper'

describe StrictParameters::StringFilter do
  describe "supported?" do
    it "should be true on String objects" do
      expect(StrictParameters::StringFilter.supported?('Jimmy')).to be true
    end

    it "should be true on objects that support to_s" do
      expect(StrictParameters::StringFilter.supported?(150)).to be true
    end
  end

  describe "convert" do
    it "should return the recieved string if object is String" do
      expect(StrictParameters::StringFilter.convert('Billy')).to eq 'Billy'
    end

    it "should return converted string if object supports to_s" do
      expect(StrictParameters::StringFilter.convert(100)).to eq '100'
    end

    it "should raise ConversionUnsupported on object that incorrectly implements to_s" do
      name = Object.new
      allow(name).to receive(:to_s) { 10 }

      expect { StrictParameters::StringFilter.convert(name) }.to raise_error(
        StrictParameters::ConversionUnsupported,
        /conversion of '.+?Object.+?' unsupported for 'StrictParameters::StringFilter'/
      )
    end
  end
end
