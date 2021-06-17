# Statsig Ruby SDK

## The Basics

Get started in a few quick steps.

1. [Create a free account on statsig.com](#step1)
2. [Install the SDK](#step2)
3. [Initialize and use the SDK](#step3)

<a name="step1"></a>

#### Step 1 - Create a free account on [www.statsig.com](https://console.statsig.com/sign_up)

You could skip this for now, but you will need an SDK Key and some Feature Gates or Dynamic Configs to use with the SDK in just a minute.

<a name="step2"></a>

#### Step 2 - Install the SDK

If you are using Bundler, add the [gem](https://rubygems.org/gems/statsig) to your Gemfile from command line:
```Ruby
bundle add statsig --version ">= 1.0.0"
```
or directly include it in your Gemfile and run `bundle install`:
```Ruby
gem "statsig", ">= 1.0.0"
```

#### Step 3 - Initialize and use the SDK

Initialize the SDK using a [Server Secret Key from the statsig console](https://console.statsig.com/api_keys):

```Ruby
require 'statsig'

Statsig.initialize('<secret>')

# Now you can check gates, get configs, log events for your users.
# e.g. if you are running a promotion that offers all users with a @statsig.com email a discounted price on your monthly subscription service,
# 1. you can first use check_gate to see if they are eligible
user = StatsigUser.new({'email' => 'jkw@statsig.com'})
if Statsig.check_gate(user, 'has_statsig_email')
  # 2. then get the discounted price from dynamic config
  price_config = Statsig.get_config(user, 'special_item_prices')
  @sub_price = price_config.get('monthly_sub_price')
end

...
# 3. log the conversion event - 'purchase_made' - once they make the purchase
Statsig.log_event(user, 'purchase_made', 1, {'price' => @sub_price})
```
