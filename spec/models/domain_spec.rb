# frozen_string_literal: true

require "spec_helper"

describe Domain do
  describe "#update_meta!" do
    it do
      resource = double(get: "<html><head><title>\nmorph.io   </title><meta name='Description' content='Get structured data out of the web. Code collaboration through GitHub. Run your scrapers in the cloud.'></head></html>")
      expect(RestClient::Resource).to receive(:new).with("http://morph.io", verify_ssl: OpenSSL::SSL::VERIFY_NONE).and_return(resource)

      domain = Domain.create!(name: "morph.io")
      domain.update_meta!
      domain.reload
      expect(domain.name).to eq "morph.io"
      expect(domain.meta).to eq "Get structured data out of the web. Code collaboration through GitHub. Run your scrapers in the cloud."
      expect(domain.title).to eq "morph.io"
    end

    it "should record nothing if there was an error" do
      resource = double
      expect(RestClient::Resource).to receive(:new).with("http://morph.io", verify_ssl: OpenSSL::SSL::VERIFY_NONE).and_return(resource)
      domain = Domain.create!(name: "morph.io")
      expect(resource).to receive(:get).and_raise Net::HTTPBadResponse

      domain.update_meta!
      domain.reload
      expect(domain.name).to eq "morph.io"
      expect(domain.meta).to be_nil
      expect(domain.title).to be_nil
    end
  end
end
