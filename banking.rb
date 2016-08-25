require 'csv'

module Bank
  class Account
    attr_accessor :id, :balance

    def initialize(id, balance, open_date)
      @balance = balance
      @id = id
      @open_date = open_date
      if @balance < 0
        raise (ArgumentError)
      end
      #puts "Your Bank Account Number is #{ @id } and your balance is #{ @balance }."
      # assigns initial balance >= 0
    end

    def self.all
      all_accounts = []
      CSV.read('support/accounts.csv', 'r').each do |line|
        all_accounts << self.new(line[0], line[1].to_i, line[2])
      end
      return all_accounts
    end

    def self.find(id)
      all.each do |acc|
        if acc.id == id
          return acc
        end
      end
    end


    def deposit(funds)
      # takes user input and += from balance
      return @balance += funds
    end

    def withdraw(funds)
      # takes user input and -= from balance
      if @balance - funds < 0
        puts "You have insufficient funds."
        return @balance
      else
        return @balance -= funds
      # return  new_balance
      # new_balance >= $0.00, if not, raise ArgumentError
      end
    end
  end
end
