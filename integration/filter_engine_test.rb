require "minitest/autorun"
require "bharat_filter_engine"

class FilterEngineTest < Minitest::Test
  def test_gem_is_loaded
    assert defined?(BharatFilterEngine)
  end

  def test_apply_method_exists
    assert_respond_to BharatFilterEngine, :apply
  end
end
