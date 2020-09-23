module Interface
  module_function

  def user_name
    print 'Enter your name: '
    gets.chomp
  end

  def action
    menu
    print 'Your action: '
    gets.chomp.strip
  end

  def menu
    %w[
      ===============
      1\ Pass
      2\ Hit
      3\ Open\ cards
      Exit
    ].each { |opt| puts opt }
  end

  def restart?
    puts 'Again? (Y/N)'
    gets.chomp.downcase == 'y'
  end

  def show_result_table(user, dealer)
    puts "#{user.name}, (#{user.score}, $#{user.account}), | #{user.cards.join(' | ')} |\n"
    puts "#{dealer.name}, (#{dealer.score}, $#{dealer.account}), | #{dealer.cards.join(' | ')} |"
  end

  def show_table(user, dealer)
    puts "#{user.name}, (#{user.score}, $#{user.account})\n"
    puts "| #{user.cards.join(' | ')} |\n"
    puts "#{dealer.name}, ($#{dealer.account})\n"
    puts "| #{dealer.cards.map { '*' }.join(' | ')} |"
  end

  def winner(player)
    puts "#{player.name} win!"
  end

  def draw
    puts 'Draw!'
  end
end
