module AbaNumbers
  module Validation

    def valid_aba_number?(aba_number)
      aba_number_str = aba_number.to_s.strip

      return false if aba_number_str.empty?
      return false unless aba_number_str =~ /^\d{9}$/

      total = 0
      0.step(9, 3) do |i|
        total += aba_number_str[i..i].to_i * 3
        total += aba_number_str[(i+1)..(i+1)].to_i * 7
        total += aba_number_str[(i+2)..(i+2)].to_i * 1
      end

      total % 10 == 0
    end

    module_function :valid_aba_number?

  end
end
