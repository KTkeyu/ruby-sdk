require 'minitest'
require 'minitest/autorun'
require 'statsig'

class TestStatsig < Minitest::Test
  def before_setup
    super
    Statsig.shutdown
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

  def test_check_gate_works
    Statsig.initialize('secret-9IWfdzNwExEYHEW4YfOQcFZ4xreZyFkbOXHaNbPsMwW')
    gate = Statsig.check_gate(StatsigUser.new({'userID' => '123'}), 'test_public')
    assert(gate == true)
  end

  def test_email_gate_works
    Statsig.initialize('secret-9IWfdzNwExEYHEW4YfOQcFZ4xreZyFkbOXHaNbPsMwW')
    pass_gate = Statsig.check_gate(StatsigUser.new({'userID' => '123', 'email' => 'jkw@statsig.com'}), 'test_email')
    assert(pass_gate == true)

    fail_gate = Statsig.check_gate(StatsigUser.new({'userID' => '123', 'email' => 'jkw@gmail.com'}), 'test_email')
    assert(fail_gate == false)
  end

  def test_no_userid_raises
    Statsig.initialize('secret-9IWfdzNwExEYHEW4YfOQcFZ4xreZyFkbOXHaNbPsMwW')
    assert_raises{ Statsig.check_gate(StatsigUser.new({'email' => 'jkw@statsig.com'}), 'test_email')}
    assert_raises{ Statsig.get_config(StatsigUser.new({'email' => 'jkw@statsig.com'}), 'fake_config_name')}
  end
end