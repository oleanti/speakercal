require 'test_helper'
require 'fixture.rb'
require 'match.rb'

#require 'calendar_controller'

class CalendarControllerTest < ActionController::TestCase
  def test_malicious_ids
    malicious_tests = [nil, "abcdef", "  123", "123  ", "123 456", "1abcdef2", "a8a8a8"]

    malicious_tests.each do |test|
      run_id_test(test)
    end
  end

  def test_good_id
    assert_nothing_raised do
      get :matches, { :id => "123456" }
    end
  end

  def test_long_id
    run_id_test(1234567891234567)
    run_id_test("1"*16)
  end

  private

  def run_id_test(string)
    assert_raise RuntimeError do 
      get(:matches, { :id => string.to_s })
    end
  end
end
