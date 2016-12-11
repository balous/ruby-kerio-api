require 'spec_helper'
require 'kerio-api/session'
require 'uri'
require 'json'

describe Kerio::Api::Session do

	let(:session){described_class.new(URI.parse('http://xxx:4000/admin'))}

	before do
		allow(Kernel).to receive(:rand).and_return(1)
		session.instance_eval do
			@token = 'token'
			@cookie = 'cookie'
		end
	end

	describe '#request' do
		context 'successfull request' do

			it 'sends request' do
				stub = stub_request(:post, 'http://xxx:4000/admin').with(
					:body => "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"method\",\"params\":{\"k\":\"v\"},\"token\":\"token\"}",
					:headers => {
						'Accept'=>'application/json-rpc',
						'X-Token'=>'token',
						'Cookie'=>'cookie',
					}
				).to_return(
					status: 200,
					body: JSON.generate({"result" => 42}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				result = session.request('method', {k: 'v'})

				expect(result).to be 42
				expect(stub).to have_been_requested
			end
		end

		context 'error response' do
			it 'raises error' do
				stub = stub_request(:post, 'http://xxx:4000/admin').to_return(
					status: 200,
					body: JSON.generate({"error" => ""}),
					headers: {
						'Content-Type' => 'application/json-rpc',
					}
				)

				expect{session.request('method', {})}.to raise_error(Kerio::Api::Error)
			end
		end
	end
end