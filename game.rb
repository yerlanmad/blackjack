# frozen_string_literal: true

class Game
  INITIAL_PLAYER_BALANCE = 100
  INITIAL_BET = 10

  def call
    @dealer = Dealer.new('Dealer', INITIAL_PLAYER_BALANCE)
    @bank = 0
    sign_in
    start
  end

  private

  attr_reader :user, :dealer, :deck
  attr_accessor :bank

  def sign_in
    name = Interface.user_name
    @user = User.new(name.strip, INITIAL_PLAYER_BALANCE)
  end

  def start
    @deck = Deck.new
    user.cards.clear
    dealer.cards.clear
    2.times do
      initial_deal
    end
    return unless initial_bet(INITIAL_BET)

    Interface.show_table(user, dealer)
    action
  end

  def action
    loop do
      input = Interface.action
      process_input(input)
      break if input.to_sym == :exit || input.to_i == 3
    end
    start if Interface.restart?
  end

  def process_input(input)
    case input.to_i
    when 1
      dealer_move
      Interface.show_table(user, dealer)
    when 2
      user_move
      dealer_move
      Interface.show_table(user, dealer)
    when 3
      stop
    end
  end

  def initial_deal
    user.deal(deck.deal_card)
    dealer.deal(deck.deal_card)
  end

  def initial_bet(amount)
    return unless user.account >= amount && dealer.account >= amount

    user.account -= amount
    dealer.account -= amount
    self.bank += 2 * amount
  end

  def dealer_move
    dealer.deal(deck.deal_card) if dealer.cards.size < 3 && dealer.score < 17
  end

  def user_move
    user.deal(deck.deal_card) if user.cards.size < 3 && user.score < 21
  end

  def stop
    result
    Interface.show_result_table(user, dealer)
    self.bank = 0
  end

  def result
    if user.score < 22 && (user.score > dealer.score || dealer.score > 21)
      user.account += bank
      Interface.winner(user)
    elsif user.score == dealer.score
      user.account += 0.5 * bank
      dealer.account += 0.5 * bank
      Interface.draw
    else
      dealer.account += bank
      Interface.winner(dealer)
    end
  end
end
