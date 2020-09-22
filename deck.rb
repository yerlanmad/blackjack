class Deck
  RANKS = %w[A K Q J 10 9 8 7 6 5 4 3 2].freeze
  SUITS = ["\u2665", "\u2666", "\u2663", "\u2660"].freeze

  attr_reader :deck

  def initialize
    @deck = new_deck.shuffle
  end

  def deal_card
    deck.shift
  end

  private

  def new_deck
    SUITS.flat_map { |s| RANKS.map { |r| r + s } }
  end
end
