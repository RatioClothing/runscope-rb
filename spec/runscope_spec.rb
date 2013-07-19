require 'spec_helper'

describe Runscope do
  context "#version_string" do
    it 'should return correct version string' do
      Runscope.version_string.should eq("Runscope version #{Runscope::VERSION}")
    end
  end

  context '#monitor?' do
    before(:each){
      Runscope.domains = ["api.stackexchange.com", /\S+\.desk\.com/]
    }
    after(:each){ Runscope.reset }
    context "when enabled" do
      before{ Runscope.enabled = true }
      it{expect(Runscope.monitor?("api.stackexchange.com")).to eq(true)}
      it{expect(Runscope.monitor?("api.twitter.com")).to eq(false)}
    end

    context "when disabled" do
      before(:each){ Runscope.enabled = false }
      it{expect(Runscope.monitor?("api.stackexchange.com")).to eq(false)}
      it{expect(Runscope.monitor?("api.twitter.com")).to eq(false)}
    end
  end

  context '#monitor_domain?' do
    before(:each){
      Runscope.domains = ["api.stackexchange.com", /\S+\.desk\.com/]
    }

    it{expect(Runscope.monitor_domain?("api.stackexchange.com")).to eq(true)}
    it{expect(Runscope.monitor_domain?("test.desk.com")).to eq(true)}
    it{expect(Runscope.monitor_domain?("api.twitter.com")).to eq(false)}
    it "should raise an error if no domains are set" do
      Runscope.domains = nil
      expect {Runscope.monitor_domain?("api.stackexchange.com")}.to(
        raise_error(NoDomainsSetError)
      )
    end
  end

  context '#proxy_domain' do
    before(:each) do
      @bucket = "1234abcd"
      Runscope.bucket = @bucket
    end

    it{expect(Runscope.proxy_domain("api.stackexchange.com")).to(
      eq("api-stackexchange-com-#{@bucket}.runscope.net")
    )}

    it "should raise an error if no bucket is set" do
      Runscope.bucket = nil
      expect {
        Runscope.proxy_domain("api.stackexchange.com")
      }.to raise_error(BucketNotSetError)
    end
  end
end
