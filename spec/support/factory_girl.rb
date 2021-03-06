RSpec.configure do |config|
  
  config.include FactoryGirl::Syntax::Methods

  # lint all the factories when running the suite
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

end

# Test::Unit
class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
