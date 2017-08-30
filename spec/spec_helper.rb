# First line of spec/spec_helper.rb
require 'simplecov'
require 'coveralls'
require 'rspec-puppet-facts'

include RspecPuppetFacts

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  # Exclude bundled Gems in `/.vendor/`
  add_filter '/.vendor/'
end

require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.module_path     = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'modules')
  c.manifest_dir    = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests')
  c.manifest        = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
