# -*- encoding: utf-8 -*-
# stub: materialize-form 1.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "materialize-form".freeze
  s.version = "1.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["James La".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-04-03"
  s.description = "This gem includes a generator for SimpleForm configuration with Materialize. It also includes custom inputs for materialize.".freeze
  s.email = ["jamesla0604@gmail.com".freeze]
  s.homepage = "http://materialize-form.herokuapp.com/users/new".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "Materialize - SimpleForm Generator.".freeze

  s.installed_by_version = "2.7.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.12.5", "~> 1.12"])
      s.add_development_dependency(%q<rake>.freeze, [">= 11.1.2", "~> 11.1"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 1.12.5", "~> 1.12"])
      s.add_dependency(%q<rake>.freeze, [">= 11.1.2", "~> 11.1"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 1.12.5", "~> 1.12"])
    s.add_dependency(%q<rake>.freeze, [">= 11.1.2", "~> 11.1"])
  end
end
