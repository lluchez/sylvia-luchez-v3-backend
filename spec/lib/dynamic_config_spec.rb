require 'rails_helper'

describe DynamicConfig do
  let(:file_with_env) do
    File.read(Rails.root.join('spec/fixtures/config_yml/with_env.yml'))
  end

  let(:file_without_env) do
    File.read(Rails.root.join('spec/fixtures/config_yml/without_env.yml'))
  end

  describe '#cors_origins' do
    it 'should return the value from the YAML as an array' do
      expect(described_class.cors_origins).to eq(['*'])
    end
  end

  describe '#method_missing' do
    context 'for unknown methods' do
      context 'when a corresponding YAML file exists' do
        it 'should read the YAML file and define it for later use' do
          yml_content = { 'foo' => 'bar' }
          meth = :test123
          expect(File).to receive(:exist?).with(Rails.root.join("config/#{meth}.yml")).exactly(2).times.and_return(true)
          expect(described_class).to receive(:parse_config_file_with_env).with("#{meth}.yml").and_return(yml_content)
          expect(described_class.respond_to?(meth)).to eq(true)
          expect(described_class.send(meth)).to eq(yml_content) # will define the method for later use
          expect(described_class.respond_to?(meth)).to eq(true)
        end
      end

      context 'when no corresponding YAML file exists' do
        it 'should use the default behavior and raise an exception' do
          meth = :test456
          expect(File).to receive(:exist?).exactly(3).times.and_return(false)
          expect(described_class.respond_to?(meth)).to eq(false)
          expect { described_class.send(meth) }.to raise_error(NoMethodError)
          expect(described_class.respond_to?(meth)).to eq(false)
        end
      end
    end
  end

  describe '#parse_config_file' do
    it 'should return the whole file regardless of the current environment' do
      expect(File).to receive(:read).with(Rails.root.join('config/with_env.yml')).and_return(file_with_env)
      expect(described_class.send(:parse_config_file, 'with_env.yml')).to eq({
        'any' => { 'foo' => 'bar' },
        'test' => { 'foofoo' => 'barbar' }
      })
    end

    it 'should return the whole file regardless of the current environment' do
      expect(File).to receive(:read).with(Rails.root.join('config/without_env.yml')).and_return(file_without_env)
      expect(described_class.send(:parse_config_file, 'without_env.yml')).to eq({
        'any' => { 'foo' => 'bar' },
        'foo' => { 'abc' => 'def' }
      })
    end
  end

  describe '#parse_config_file_with_env' do
    it 'should return the section related to the current environment' do
      expect(File).to receive(:read).with(Rails.root.join('config/with_env.yml')).and_return(file_with_env)
      expect(described_class.send(:parse_config_file_with_env, 'with_env.yml')).to eq('foofoo' => 'barbar')
    end

    it 'should return the `any` section when the current environment is missing' do
      expect(File).to receive(:read).with(Rails.root.join('config/without_env.yml')).and_return(file_without_env)
      expect(described_class.send(:parse_config_file_with_env, 'without_env.yml')).to eq('foo' => 'bar')
    end
  end
end
