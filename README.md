# Decidim::ComparativeStats

![Test](https://github.com/Platoniq/decidim-module-comparative_stats/workflows/Test/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/59d3415b89244ef0d40b/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-comparative_stats/maintainability)
[![Codecov](https://codecov.io/gh/Platoniq/decidim-module-comparative_stats/branch/master/graph/badge.svg?token=XhzWO0IiWt)](https://codecov.io/gh/Platoniq/decidim-module-comparative_stats)

Allows to compare different Decidim sites by accessing their GraphQL API and
generate graphs.

> NOTE: This module is in beta status, feel free to report issues or contribute in it!

## Usage

This module works by connecting to several Decidim API's.
Just go to your `your-decidim-installation.org/admin/comparative_stats` and
add endpoints to compare.
For instance, Decidim Barcelona endpoint is `https://www.decidim.barcelona/api`

Then, go to graphs and see some nice graphs!

Graphs can be embedded anywhere independently, just use the button
`embed <>` and copy the code to any other place.

The generated code will look something like:

```html
<iframe
  src="http://your_url/comparative_stats/widgets/global_stats.html"
  frameborder="0"
  width="100%"
  height="420"
  scrolling="vertical"></iframe>
```

You might want to customize the `height` parameter to match your particular case.

![Barcelona/Helsinki comparison](example.png)
*A real example comparing the participatory processes carried out by the cities of Barcelona and Helsinki in 2019*

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-comparative_stats", git: "https://github.com/Platoniq/decidim-module-comparative_stats", branch: "master"
```

And then execute:

```bash
bundle
bundle exec rails decidim_comparative_stats:install:migrations
bundle exec rails decidim_comparative_stats:webpacker:install
bundle exec rails db:migrate
```

Depending on your Decidim version, choose the corresponding Awesome version to ensure
compatibility:

| Comparative stats version | Compatible Decidim versions |
|---------------------------|-----------------------------|
| 1.0.x                     | 0.21.x, 0.22.x              |
| 1.1.x                     | 0.23.x, 0.24.x              |
| 1.2.x                     | 0.25.x                      |

## Configuration options

API queries are cached 1 hour by default.
This can be tuned by creating an initializer in your Decidim installation.
For instance, create the file `config/initializers/comparative_stats.rb`
with this content:

```ruby
# frozen_string_literal: true

Decidim::ComparativeStats.configure do |config|
  config.stats_cache_expiration_time = 2.hour
end
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
bundle
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
cd development_app
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
bundle
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

<https://crowdin.com/translate/decidim-comparative-stats>

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.

## Credits

This plugin has been developed by ![Platoniq](app/assets/images/platoniq-logo.png)

> Amb el suport de l'Ajuntament de Barcelona - Direcció de Serveis d'Innovació Democràtica
>
> ![Logo Barcelona](app/assets/images/bcn-logo.png)
