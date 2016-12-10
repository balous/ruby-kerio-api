require 'spec_helper'
require 'kerio-api/client'
require 'uri'

describe Kerio::Api::Client do

	let(:url){double(URI)}
	let(:session) do
		s = double(Kerio::Api::Session)
		allow(s).to receive(:login)
		s
	end

	describe '#initialize' do

		it 'calls functions correctly' do

			expect(Kerio::Api::Session).to receive(:new).with(url).and_return(session)
			expect(session).to receive(:login).with('username', 'pass')

			described_class.new(url: url, user: 'username', password: 'pass')
		end
	end

	describe '#method_missing' do
		let(:client){described_class.new(url: url, user: 'username', password: 'pass')}
		let(:urva){double(Kerio::Api::Interface)}

		before do
			allow(Kerio::Api::Session).to receive(:new).and_return(session)
		end

		it 'Returns interface' do
			expect(Kerio::Api::Interface).to receive(:new).with(:Urva, session).and_return(urva)
			expect(client.Urva).to eq urva
		end
	end
end
