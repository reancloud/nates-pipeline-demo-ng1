# frozen_string_literal: true

# This set of inspec controls is a simple example of a smoke test for a website.
#
# It will be provided inspec inputs for the following:
#  - website:  The website being tested, as defined in your config.rb
#  - expected: The expected results to test, as defined by your :url_tests setting in config.rb
#

website = input 'website', type: 'Hash', required: true
expected = input 'expected', type: 'Hash', required: false, value: { status: 200 }

describe http(website[:url], website[:http_options] || {}) do
  its('status') { should eq expected[:status] }
  its('body') { should cmp expected[:body] } if expected[:body]

  expected.fetch(:headers, {}).each do |name, value|
    its("headers.#{name}") { should cmp value }
  end
end
