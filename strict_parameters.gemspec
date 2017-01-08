require 'rake'
Gem::Specification.new do |s|
  s.name      = "strict_parameters"
  s.version   = "0.0.1"
  s.authors   = ["Bernard Laveaux"]
  s.email     = ["blaveaux@outlook.com"]
  s.summary   = "A StrongParameters-like param filtering module for filtering on specific object types"
  s.homepage  = "https://github.com/bl/StrictParameters"
  s.license   = "MIT"

  s.files     = FileList['lib/**/*.rb',
                         'spec/**/*',
                         '[A-Z]*'].to_a

  s.add_dependency "activesupport", "~> 5.0"

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "pry", "~> 0.10"
end
