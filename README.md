# sprout-vim cookbook

[![Build Status](https://travis-ci.org/pivotal-sprout/sprout-vim.png?branch=master)](https://travis-ci.org/pivotal-sprout/sprout-vim)

Cookbook for managing vim on an OS X workstation

## Usage

### Prerequisites

- [system ruby](.ruby-version)

### Quickstart

```
./sprout exec soloist
```

## Cookbook Usage

### Attributes

*NOTE:* All preferences are namespaced under `sprout => vim => config` they include:

* `path` &mdash; path to the cloned vim-config repo; default is `~/.vim`
* `repo` &mdash; url of the vim-config remote; default is `git://github.com/pivotal/vim-config.git`
* `ref` &mdash; ref-spec to clone; default is `master`


### Recipes

1. `sprout-vim`
1. `sprout-vim::config`
1. `sprout-vim::tmux`

## Contributing

### Before committing

```
./sprout exec rake
```

The default rake task includes rubocop, foodcritic, unit specs

### [Rubocop](https://github.com/bbatsov/rubocop)

```
./sprout exec rake rubocop
```

### [FoodCritic](http://acrmp.github.io/foodcritic/)

```
./sprout exec rake foodcritic
```

### Unit specs

Unit specs use [ServerSpec](http://serverspec.org/)

```
./sprout exec rake spec:unit
```

### Integration specs

Integrations specs will run the default recipe on the host system (destructive) and make assertions on the system after
install.

*Note:* It has a precondition that vim is _not_ already installed on the system.

```
./sprout exec rake spec:integration
```
