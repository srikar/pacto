module Pacto
  describe ContractFactory do
    let(:host)               { 'http://localhost' }
    let(:contract_name)      { 'contract' }
    let(:contract_path)      { File.join('spec', 'unit', 'data', "#{contract_name}.json") }
    let(:file_pre_processor) { double('file_pre_processor') }
    let(:file_content)       { File.read(contract_path)}

    describe '.build_from_file' do
      it 'should build a contract given a JSON file path and a host' do
        file_pre_processor.stub(:process).and_return(file_content)
        described_class.build_from_file(contract_path, host, file_pre_processor).
          should be_a_kind_of(Pacto::Contract)
      end

      it 'should process files using File Pre Processor module' do
        file_pre_processor.should_receive(:process).with(file_content).and_return(file_content)
        described_class.build_from_file(contract_path, host, file_pre_processor)
      end
    end

    describe '.validate_contract' do
      it 'should not raise error if contract is correct' do
        expect {
          definition = {
            'request' => {
              'method' => 'GET',
              'path' => '/a/path',
              'params' => {},
              'headers' => {}
            },
            'response' => {
              'status' => 200,
              'headers' => {},
              'body' => {
                'type' => 'string',
                'required' => true
              }
            }
          }
          described_class.validate_contract(definition, contract_path)
        }.not_to raise_error
      end
      
      it 'should raise InvalidContract if contract do not contain a Request' do
        expect {
          described_class.validate_contract({}, contract_path)
        }.to raise_error(InvalidContract)
      end
    end
  end
end
