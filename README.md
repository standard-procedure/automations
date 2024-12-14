# StandardProcedureAutomations

This module allows you to define "automations" (think [IFTTT](https://ifttt.com) or [Shortcuts](https://support.apple.com/en-gb/guide/shortcuts/welcome/ios) but for your Rails app).

## Installation

Update your `Gemfile`

```ruby
gem "standard_procedure_automations"
```

Then write a configuration and define your trigger and action classes.  Finally, run the automation.

## Usage

There are three parts to building an automation.

### Triggers

A trigger is an object that, given some parameters as a `Hash`, responds with a boolean.  If the result is falsey, the actions will not run.  If the result is truthy, the actions will run.

Each trigger is a Ruby class that takes a single `config` `Hash` parameter for initialisation.  And has a `call` method that takes a single `Hash` parameter and returns a `Boolean`.

For example (taken from the [specification](/spec/automations/implementation_spec.rb)):

```ruby
class ConfiguredAutomation < Data.define(:config)
  def call(params) = config[:should_fire]
end
```

### Actions

An action is a simple class that, given some parameters as a `Hash`, will do something and return another `Hash`.

Each action is, like triggers, a Ruby class that takes a single `config` `Hash` parameter for initialisation.  And has a `call` method that takes a single `Hash` parameter and returns a `Hash`.

For example (taken from the [specification](/spec/automations/implementation_spec.rb)):

```ruby
class ConfiguredAction < Data.define(:config)
  def call(params) = {config[:key].to_sym => config[:value]}
end
```

Most automations consiste of sequences of actions, that are executed in order.  The first action is `call`ed with the incoming `parameters`.  The next action is `call`ed with the incoming parameters merged with the results from the first action.  The next action is `call`ed with the incoming parameters merged with the results from the first and second actions.

### Configuration

The configuration is a simple `Hash` that defines the trigger and actions for an automation. This is done by providing the class name and configuration for each item.

An example (taken from the [specification](/spec/automations/implementation_spec.rb)):

```ruby
config = {
  name: "Sequence of actions",
  class_name: "Automations::TriggerDoesFire",
  configuration: {},
  actions: [
    {class_name: "Automations::AddsFirst", configuration: {}},
    {class_name: "Automations::AddsSecond", configuration: {}}
  ]
}
```

### Calling an automation

Use the `Automations` module to build your automation from a config.  Then `call` the automation with the relevant parameters.

```ruby
@config = {
  name: "Sequence of actions",
  class_name: "Automations::TriggerDoesFire",
  configuration: {},
  actions: [
    {class_name: "Automations::AddsFirst", configuration: {}},
    {class_name: "Automations::AddsSecond", configuration: {}}
  ]
}
@automation = Automations.create(@config)
@result = @automation.call name: "Alice"
```

If the trigger does not fire, then `@result` will be an empty `Hash`, otherwise it will be the combination of the incoming parameters, merged with the outputs of each `action` that was `call`ed.  If an action raises an exception, you will need to handle that yourself.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/standard_procedure/automations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/standard_procedure/automations/blob/main/CODE_OF_CONDUCT.md).
