require 'spec_helper'

describe StrictParameters::DateTimeFilter do
  describe "supported?" do
    it "returns true when object is already a DateTime" do
      expect(StrictParameters::DateTimeFilter.supported?(DateTime.now)).to be true
    end

    it "returns true when object responds to 'to_datetime'" do
      expect(StrictParameters::DateTimeFilter.supported?(Time.now)).to be true
    end

    it "returns true when object can be converted to DateTime" do
      expect(StrictParameters::DateTimeFilter.supported?(DateTime.now.to_s)).to be true
    end

    it "returns false when object can't be converted to DateTime" do
      expect(StrictParameters::DateTimeFilter.supported?("invalid_date")).to be false
    end
  end

  describe "convert" do
    it "returns the same object when already DateTime" do
      date_time = DateTime.now
      expect(StrictParameters::DateTimeFilter.convert(date_time)).to eq(date_time)
    end

    it "returns converted DateTime on object supported by DateTime.parse" do
      date_time = DateTime.new(2017)
      expect(StrictParameters::DateTimeFilter.convert(date_time.to_s)).to eq(date_time)
    end

    it "returns converted DateTime on object supporting 'to_datetime' method" do
      date_time = DateTime.now
      expect(StrictParameters::DateTimeFilter.convert(date_time.to_time)).to eq(date_time)
    end

    it "raises ConversionUnsupported on object that does not support 'to_datetime' and is't supported by DateTime.parse" do
      expect { StrictParameters::DateTimeFilter.convert("invalid_date") }.to raise_error(
        StrictParameters::ConversionUnsupported,
        /conversion of 'invalid_date' unsupported for 'StrictParameters::DateTimeFilter'/
      )
    end

    it "should raise ConversionUnsupported on object that incorrectly implements 'to_datetime'" do
      date_time = "invalid_date"
      allow(date_time).to receive(:to_datetime) { "not a datetime" }

      expect { StrictParameters::DateTimeFilter.convert(date_time) }.to raise_error(
        StrictParameters::ConversionUnsupported,
        /conversion of 'invalid_date' unsupported for 'StrictParameters::DateTimeFilter'/
      )
    end
  end
end
