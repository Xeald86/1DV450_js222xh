class SayController < ApplicationController
  def hello
    @time = Time.now
    @files = Dir.glob('*')
    @message = say_goodnight('Jimmy')
  end

  def goodbye
  end
  
  def say_goodnight(name)
    result = "Good night, #{name.capitalize}"
    return result
  end
end
