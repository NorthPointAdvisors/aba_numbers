require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AbaNumbers::Validation do

  describe 'known valid' do
    %w{ 011501598 011600774 063112728 113093852 114922090 271171674 325272306 }.each do |aba_number|
      it { AbaNumbers::Validation.valid_aba_number?(aba_number).should be_true }
    end
  end

  describe 'known invalid' do
    %w{ 011501599 011600775 063112729 113093853 114922091 271171675 325272307 }.each do |aba_number|
      it { AbaNumbers::Validation.valid_aba_number?(aba_number).should be_false }
    end
  end

end