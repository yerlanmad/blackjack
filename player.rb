# frozen_string_literal: true

class Player
  attr_reader :name, :cards, :score
  attr_accessor :account

  def initialize(name, account = 0)
    @name = name
    @cards = []
    @score = 0
    @account = account
  end

  def deal(card)
    cards << card
    count_score
  end

  protected

  attr_writer :score

  def count_score
    self.score = cards.inject(0) do |sum, card|
      if ace?(card)
        sum + 11
      elsif faces?(card)
        sum + 10
      else
        sum + card.to_i
      end
    end

    cards.select { |card| ace?(card) }.each { self.score -= 10 if score > 21 }
  end

  def ace?(card)
    card.include?('A')
  end

  def faces?(card)
    %w[K Q J].any? { |rank| card.include?(rank) }
  end
end
