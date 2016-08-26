require 'csv'

module Bank
  class Account
    attr_accessor :id, :balance, :open_date

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

  ##########################################################################################
  # -------------------------------------------------------------------------------------- #
  ##########################################################################################

  class SavingsAccount < Account
    attr_accessor :id, :balance, :open_date
    def initialize(id, balance, open_date)
      @balance = balance
      @id = id
      @open_date = open_date
      @saving_account_minimum = 1000
      super(id, balance, open_date)
      if @balance < @saving_account_minimum
        raise (ArgumentError)
      end
    end


    def self.all
      super
    end


    def self.find(id)
      super(id)
    end


    def deposit(funds)
      super(funds)
    end


    def withdraw(funds)
      transaction_fee = 200
      # Doesn't allow acct to go below $10 min balance
      if (@balance - funds) < (@saving_account_minimum + transaction_fee)
        # Will output warning message & return original unmodified balance
        puts "You have insufficient funds."
        return @balance
      else
        # Each withdrawal 'transaction' incurs $2 fee taken from balance
        @balance = @balance - transaction_fee
        return @balance -= funds
      end
    end


    def add_interest(rate)
      # Calculate the interest on the balance
      @interest = @balance * (rate/100)
      # add the interest to the balance
      @balance = @interest + @balance
      # return interest that was calculated & added to balance (not new balance)
      return @interest
    end


  end


##########################################################################################
# -------------------------------------------------------------------------------------- #
##########################################################################################


  class CheckingAccount < Account
    attr_accessor :id, :balance, :open_date, :withdraw_using_check, :check_count


    def initialize(id, balance, open_date)
      @counter = 0
      @balance = balance
      @id = id
      @open_date = open_date
      super(id, balance, open_date)
      if @balance < 0
        raise (ArgumentError)
      end
    end


    def self.all
      super
    end


    def self.find(id)
      super(id)
    end


    def deposit(funds)
      super(funds)
    end


    def withdraw(funds)
      checking_account_minimum = 0
      transaction_fee = 100
      # Does not allow the account to go negative. Will output a
      # warning message and return the original un-modified balance.
      if (@balance - funds) < (checking_account_minimum + transaction_fee)
        puts "You have insufficient funds."
        return @balance
      else
        # Each withdrawal 'transaction' incurs a fee of $1 that is
        # taken out of the balance. Returns the updated account balance.
        @balance = @balance - transaction_fee
        return @balance -= funds
      end
    end


    def check_count
      puts "You have used #{ @counter } of your 3 free check writing transactions this month."
    end


    # @check_writing_transaction_fee =
    #   if @counter < 4
    #       @check_writing_fee = 0
    #     else
    #       @check_writing_fee = 200
    #   end
    # end


    def withdraw_using_check(funds)
      check_writing_account_minimum = -1000
      check_writing_transaction_fee = 200
      @counter = @counter += 1
      # Allows account to go into overdraft up to -$10 but not any lower
      if (@balance - funds) < (check_writing_account_minimum + check_writing_transaction_fee)
        @counter -= 1
        puts "You have insufficient funds."
        return @balance
      else
        if @counter < 4
          # input amount gets taken out of account through check withdrawal
          # returns the updated account balance
          return @balance -= funds
        elsif @counter > 3
          @balance = @balance - check_writing_transaction_fee
          return @balance -= funds
        end
      end

      # The user is allowed three free check uses in one month, but any
      # subsequent use adds a $2 transaction fee
    end


    def reset_transactions
      @counter = 0
    end


  end
end
