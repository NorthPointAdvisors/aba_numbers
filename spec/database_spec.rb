require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AbaNumbers::Database do

  let(:klass) { AbaNumbers::Database }
  let(:tmp_path) { File.join AbaNumbers::TMP_PATH, 'fpddir_fake.txt' }
  let(:db) { klass.new nil, tmp_path }
  let(:line1) { '325170835FBT FSL PT ANBEL  FIRST FEDERAL SAVINGS & LOAN OF PA  WAPORT ANBELES             Y N20060614' }
  let(:line2) { '325180553AK PAC JUBEAU     ALASKA PASIFIC BANK                 AKJUBEAU                   Y N        ' }
  let(:row1) { AbaNumbers::Database::Row.new line1 }
  let(:row2) { AbaNumbers::Database::Row.new line2 }

  before(:all) { File.open(tmp_path, 'w') { |f| f.puts "#{line1}\n#{line2}" } }
  after(:all) { FileUtils.rm tmp_path }

  describe 'basic' do
    it { db.url.should == AbaNumbers::Database::FEDERAL_URL }
    it { db.path.should == tmp_path }
    it { db.file?.should be_true }
    it { db.line_count.should == 2 }
    it { db.needs_getting_file?.should be_false }
    it { db.instance_variable_get(:@data).should be_nil }
  end

  describe 'processing' do
    before(:all) { db.data }
    after(:all) { db.instance_variable_set :@data, nil }
    it { db.data.size.should == 2 }
    it { db.data.size.should == db.line_count }
    it { db.data[row1.aba_number].should == row1 }
    it { db[row2.aba_number].should == row2 }
  end

  describe 'getting data from federal reserve' do
    if ENV['full_test']
      it 'should download a valid file from the federal reserve database' do
        tmp_path = File.join AbaNumbers::TMP_PATH, 'fpddir.txt'
        FileUtils.rm tmp_path
        db = klass.new nil, tmp_path
        expect { db.get_file_from_url }.to_not raise_error
        db.line_count.should > 0
      end
    else
      pending 'need to run with ENV[\'full_test\'] to test getting an actual data file'
    end
  end

  describe AbaNumbers::Database::Row do
    describe 'basic #1' do
      it { row1.aba_number.should == '325170835' }
      it { row1.short_name.should == 'FBT FSL PT ANBEL' }
      it { row1.name.should == 'FIRST FEDERAL SAVINGS & LOAN OF PA' }
      it { row1.state.should == 'WA' }
      it { row1.city.should == 'PORT ANBELES' }
      it { row1.funds_transfer.should be_true }
      it { row1.settlement_only.should be_false }
      it { row1.securities.should be_false }
      it { row1.last_updated.to_s.should == '2006-06-14' }
      it { row1.to_s.should == "#<AbaNumbers::Database::Row aba_number=\"325170835\" short_name=\"FBT FSL PT ANBEL\" name=\"FIRST FEDERAL SAVINGS & LOAN OF PA\" state=\"WA\" city=\"PORT ANBELES\" funds_transfer=true settlement_only=false securities=false last_updated=2006-06-14>" }
      it { row1.to_s.should == row1.inspect }
    end
    describe 'basic #2' do
      let(:exp_to_s) { "#<AbaNumbers::Database::Row aba_number=\"325180553\" short_name=\"AK PAC JUBEAU\" name=\"ALASKA PASIFIC BANK\" state=\"AK\" city=\"JUBEAU\" funds_transfer=true settlement_only=false securities=false last_updated=>" }
      let(:other) { mock to_s: exp_to_s }
      it { row2.aba_number.should == '325180553' }
      it { row2.short_name.should == 'AK PAC JUBEAU' }
      it { row2.name.should == 'ALASKA PASIFIC BANK' }
      it { row2.state.should == 'AK' }
      it { row2.city.should == 'JUBEAU' }
      it { row2.funds_transfer.should be_true }
      it { row2.settlement_only.should be_false }
      it { row2.securities.should be_false }
      it { row2.last_updated.should be_nil }
      it { row2.to_s.should == exp_to_s }
      it { row2.should == other }
    end
  end

end