require_relative 'factory'

class Main

  MyFactory = Factory.new(:user_code, :secret_code, :users) do
    def compare
      @user_code == @secret_code
    end

    def add_users(user)
      @users = user
    end
  end
  my = MyFactory.new('1111', '2222')
  puts my.compare
  puts my.user_code
  puts my.class
  my.add_users(['Steve', 'Tom', 'Andrew'])
  puts my.users.length
end
