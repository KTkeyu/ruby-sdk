require 'minitest'
require 'minitest/autorun'
require 'statsig'
require 'webmock/minitest'

class TestStatsig < Minitest::Test
  @@json_file = File.read("#{__dir__}/download_config_specs.json")

  def before_setup
    super
    Statsig.shutdown
    WebMock.disable!
    WebMock.allow_net_connect!
  end

  def test_a_secret_must_be_provided
    assert_raises { Statsig.initialize(nil) }
  end

  def test_an_empty_secret_will_fail
    assert_raises { Statsig.initialize('') }
  end

  def test_client_api_keys_will_fail
    assert_raises { Statsig.initialize('client') }
  end

  def test_no_userid_raises
    Statsig.initialize('secret-123')
    assert_raises{ Statsig.check_gate(StatsigUser.new({'email' => 'jkw@statsig.com'}), 'test_email')}
    assert_raises{ Statsig.get_config(StatsigUser.new({'email' => 'jkw@statsig.com'}), 'fake_config_name')}
    assert_raises{ Statsig.check_gate(StatsigUser.new({'email' => 'jkw@statsig.com', 'custom_ids' => {}}), 'test_email')}
    assert_raises{ Statsig.get_config(StatsigUser.new({'email' => 'jkw@statsig.com', 'custom_ids' => {}}), 'fake_config_name')}
    Statsig.check_gate(StatsigUser.new({'email' => 'jkw@statsig.com', 'custom_ids' => {'cid' => '1'}}), 'test_email')
    Statsig.get_config(StatsigUser.new({'email' => 'jkw@statsig.com', 'custom_ids' => {'cid' => '1'}}), 'fake_config_name')
  end

  def test_error_callback_called
    Statsig.initialize('secret-fake', nil, (-> (e) {
      assert(e.message.include?('401'))
    }))
  end

  def test_bootstrap_option
    # without bootstrap gate should evaluate to false
    Statsig.initialize('secret-123')
    assert_equal(Statsig.check_gate(StatsigUser.new({'userID' => 'jkw'}), 'always_on_gate'), false)
    Statsig.shutdown

    # without bootstrap gate should evaluate to true due to bootstrapped values
    options = StatsigOptions.new(bootstrap_values: @@json_file)
    Statsig.initialize('secret-123', options)
    assert_equal(Statsig.check_gate(StatsigUser.new({'userID' => 'jkw'}), 'always_on_gate'), true)
  end

  def teardown
    super
    Statsig.shutdown
  end
end