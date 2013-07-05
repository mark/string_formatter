Gem::Specification.new do |s|
  s.name        = 'string_formatter'
  s.version     = '2.0.1'
  s.date        = '2013-07-05'
  s.summary     = "A gem for creating strf-style methods on any Ruby object."
  s.description = <<-END
    Ruby has useful formatter methods, like Time#strftime.  This gem
    allows you to define your own similar methods on any Ruby
    object easily, using a nice little DSL.
  END
  s.authors     = ["Mark Josef"]
  s.email       = 'McPhage@gmail.com'
  s.files       = ["lib/string_formatter.rb",
                   "lib/format_evaluator.rb",
                   "lib/format_parser.rb",
                   "lib/formattable.rb"]
  s.homepage    = "http://github.com/mark/string_formatter"
end
