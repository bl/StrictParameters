require 'spec_helper'

describe StrictParameters::IntegerFilter do
  describe "supported?" do
    it "should be true on Integer objects" do
      expect(StrictParameters::IntegerFilter.supported?(100)).to be true
    end

    it "should be true on objects that support to_i" do
      expect(StrictParameters::IntegerFilter.supported?("150")).to be true
    end

    it "should be false on objects that don't support to_i" do
      expect(StrictParameters::IntegerFilter.supported?({})).to be false
    end
  end

  describe "convert" do
    it "should return the recieved integer if object is Integer" do
      expect(StrictParameters::IntegerFilter.convert(15)).to eq 15
    end

    it "should return converted integer if object supports to_i" do
      expect(StrictParameters::IntegerFilter.convert("150")).to eq 150
    end

    it "should raise ConversionUnsupported on object that incorrectly implements to_i" do
      name = "Jimbo"
      allow(name).to receive(:to_i) { '150' }

      expect { StrictParameters::IntegerFilter.convert(name) }.to raise_error(
        StrictParameters::ConversionUnsupported,
        "conversion of 'Jimbo' unsupported for 'StrictParameters::IntegerFilter'"
      )
    end
  end
end
