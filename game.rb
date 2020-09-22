# frozen_string_literal: true

class Game
  def call
    @dealer = Dealer.new('Dealer', 100)
    @bank = 0
    sign_in
    start
  end

  private

  attr_reader :user, :dealer, :deck
  attr_accessor :message, :bank

  def sign_in
    print 'Enter your name: '
    name = gets.chomp
    @user = User.new(name.strip, 100)
  end

  def start
    @deck = Deck.new
    user.cards.clear
    dealer.cards.clear
    self.message = 'Game Started'
    2.times do
      initial_deal
    end
    return unless initial_bet(10)
    puts table
    menu
  end

  def initial_deal
    puts 'Dealing cards...'
    user.deal(deck.deal_card)
    dealer.deal(deck.deal_card)
  end

  def initial_bet(amount)
    return unless user.account >= amount && dealer.account >= amount

    user.account -= amount
    dealer.account -= amount
    self.bank += 2 * amount
  end

  def table
    "#{deck.deck.size} cards in deck | Bank: $#{bank} | #{message}\n" \
      "#{user.name}, (#{user.score}, $#{user.account})\n" \
      "| #{user.cards.join(' | ')} |\n" \
      "#{dealer.name}, ($#{dealer.account})\n" \
      "| #{dealer.cards.map { '*' }.join(' | ')} |"
  end

  def interface
    %w[
      ===============
      1\ Pass
      2\ Hit
      3\ Open\ cards
      Exit
    ].each { |opt| puts opt }
  end

  def process_input(input)
    case input.to_i
    when 1
      dealer_move
    when 2
      user_move
      dealer_move
    when 3
      stop
    end
  end

  def menu
    loop do
      interface
      print 'Your action: '
      input = gets.chomp.strip
      break if input.downcase == 'exit'

      process_input(input)
      break if input.to_i == 3
    end
  end

  def dealer_move
    dealer.deal(deck.deal_card) if dealer.cards.size < 3 && dealer.score < 17

    self.message = "Dealer's move"
    puts table
  end

  def user_move
    user.deal(deck.deal_card) if user.cards.size < 3 && user.score < 21

    self.message = 'Hit'
    puts table
  end

  def stop
    self.message = 'Game ended'
    puts table
    puts winner
    puts result_table
    self.bank = 0

    puts 'Again? (Y/N)'
    start if gets.chomp.upcase == 'Y'
  end

  def result_table
    "#{user.name}, (#{user.score}, $#{user.account}), | #{user.cards.join(' | ')} |\n" \
      "#{dealer.name}, (#{dealer.score}, $#{dealer.account}), | #{dealer.cards.join(' | ')} |"
  end

  def winner
    if user.score < 22 && (user.score > dealer.score || dealer.score > 21)
      user.account += bank
      "#{user.name} win!"
    elsif user.score == dealer.score
      user.account += 0.5 * bank
      dealer.account += 0.5 * bank
      'Draw'
    else
      dealer.account += bank
      "#{dealer.name} win!"
    end
  end
end
