RANKINGS = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
HAND_RANKINGS = ['straight flush', 'quads', 'full house', 'flush', 'straight', 'trips', 'two pairs', 'pair', 'high card']

def read_file(file_name)
  data = File.open(file_name)
end

def split_hands(both_hands)
  first_hand = both_hands.split[0..4].join(' ')
  second_hand = both_hands.split[5..9].join(' ')
  return first_hand, second_hand
end

def read_hand(hand)
  has_one_pair(hand)
end

def has_flush?(hand)
  suits = []
  hand.split.each do |value_with_suit|
    suits << value_with_suit[1]
  end
  suits = suits.join()
  return ["DDDDD", "CCCCC", "SSSSS", "HHHHH"].include?(suits)
end

def has_straight?(hand)
  hand_without_suits = high_card(hand)
  if hand_without_suits.split.join() == "A5432"
    # puts "yes, bicycle"
    return true
  else
    hand = hand_without_suits.split.join()
    straight = false 
    possible_straights = "AKQJT98765432"
    (4..12).each do |end_index|
      straight = possible_straights[end_index-4..end_index]
      # puts straight
      if hand == straight
        straight = true
        # puts "yes, straight"
        return true
        break
      end
    end
    # puts "no straight"
    return false
  end
end

def high_card(hand)
  sorted_cards = []
  hand_without_suits = []
  hand.split.each do |value_with_suit|
    hand_without_suits << value_with_suit[0]
  end
  count = Hash.new(0)
  hand_without_suits.each do |value|
    count[value] += 1
  end
  RANKINGS.each do |ranking|
    count[ranking].times { sorted_cards << ranking}
  end
  sorted_cards.join(' ')
end

def compare_pair(hand_1, hand_2)
  # hand_1 = hand_1.split.uniq
  # hand_2 = hand_2.split.uniq
  hand_1_pair = nil
  hand_2_pair = nil
  puts hand_1
  puts hand_2


  count_1 = Hash.new(0)
  hand_1.split.each { |val| count_1[val] += 1 }
  count_2 = Hash.new(0)
  hand_2.split.each { |val| count_2[val] += 1 }
  count_1.each do |key, val|
    hand_1_pair = key if 2 == val
  end
  count_2.each do |key, val|
    hand_2_pair = key if 2 == val
  end
  puts hand_2_pair
  case RANKINGS.find_index(hand_1_pair) <=> RANKINGS.find_index(hand_2_pair)
  when 0
    sort_rest(count_1, count_2)
  when -1
     puts hand_1_pair, hand_2_pair
     puts "p1 wins"
     @p1_wins +=1
  when 1
     puts hand_2_pair, hand_1_pair
     puts "p2 wins"
     @p2_wins +=1
  end
end

def sort_rest(hand_1, hand_2)
  hand_1_remaining = []
  hand_2_remaining = []
  hand_1.each do |key, val|
    hand_1_remaining << key if 1 == val
  end
  hand_2.each do |key, val|
    hand_2_remaining << key if 1 == val
  end
  tie = true
  (0..2).each do |num|
    case RANKINGS.find_index(hand_1_remaining[num]) <=> RANKINGS.find_index(hand_2_remaining[num])
      when 0
        next
      when -1
        tie = false
        @p1_wins += 1
        puts "#{hand_1_remaining[num]} high beats #{hand_2_remaining[num]} high"
        break
      when 1
        tie = false
        @p2_wins += 1
        puts "#{hand_2_remaining[num]} high beats #{hand_1_remaining[num]} high"
        break
    end
  end
  @ties +=1 if tie
end

def compare_high_cards(hand_1, hand_2, compare_straight_flush = false)
  winner = nil
  hand = nil

  hand_1 = hand_1.split.join('')
  hand_2 = hand_2.split.join('')
  puts hand_1
  puts hand_2
  puts "COMPARING STRAIGHTS OR FLUSHES" if compare_straight_flush
  (0..4).each do |num|
    case RANKINGS.find_index(hand_1[num]) <=> RANKINGS.find_index(hand_2[num])
      when 0
        next
      when -1
        winner = "player_1"
        @p1_wins += 1
        puts "#{hand_1[num]} high beats #{hand_2[num]} high"
        # hand = "#{hand_1[num]} straight beats #{hand_2[num]} straight" if compare_straight_flush
        break
      when 1
        winner = "player_2"
        @p2_wins += 1
        puts "#{hand_2[num]} high beats #{hand_1[num]} high"
        # hand = "#{hand_2[num]} straight beats #{hand_1[num]} straight" if compare_straight_flush
        break
    end
  end
  puts "PROBLEM #{hand_1} #{hand_2}" if winner.nil?
end

def has_one_pair(hand)
  hand_without_suits = high_card(hand)
  new_hand = [] 
  straight_flush, quads, full_house, flush, straight, trips, two_pair, one_pair = false
  pair_count = 0
  count = Hash.new(0)
  hand_without_suits.split.each { |val| count[val] += 1 }
  4.downto(1).each do |occurences|
    count.each do |key, val|
      if occurences == val
        occurences.times { new_hand << key  }
        quads = true if occurences == 4
        trips = true if occurences == 3
        pair_count += 1 if occurences == 2
      end
    end
  end
  full_house = true if trips && pair_count == 1
  two_pair = true if pair_count == 2
  one_pair = true if pair_count == 1
  straight = has_straight?(hand)
  flush = has_flush?(hand)
  straight_flush = straight && flush
  # puts "Has a straight flush? #{straight_flush}"
  # puts "Has quads? #{quads}"
  # puts "Has full house? #{full_house}"
  # puts "Has flush? #{flush}"
  # puts "Has straight? #{straight}"
  # puts "Has trips? #{trips && !full_house}"
  # puts "Has two pairs? #{two_pair}"
  # puts "Has pair? #{one_pair}"
  hand = nil
  hand = "pair" if one_pair
  hand = "two pairs" if two_pair
  hand = "trips" if trips
  hand = "straight" if straight
  hand = "flush" if flush
  hand = "full house" if full_house
  hand = "quads" if quads
  hand = "straight flush" if straight_flush
  hand ||= "high card"
  # puts "Has #{hand}"
  new_hand.join(' ')
  hand
end

def compare(player_1_hand, player_2_hand, hand_1, hand_2)
  puts "Compare P1:#{player_1_hand}, P2:#{player_2_hand}"
  case HAND_RANKINGS.find_index(player_1_hand) <=> HAND_RANKINGS.find_index(player_2_hand)
  when 0
    puts "same hand ranking"
    compare_same_ranking(hand_1, hand_2, player_1_hand)
  when -1
    @p1_wins +=1
    puts "player 1 wins"
  when 1
    @p2_wins +=1
    puts "player 2 wins"
  end
end

def compare_same_ranking(hand_1, hand_2, rank)
  case rank
  when 'high card'
    puts 'here'
    compare_high_cards(high_card(hand_1), high_card(hand_2))
  when 'pair'
    compare_pair(high_card(hand_1), high_card(hand_2))
  # when 'two pair'
  #   puts 'two pair'
  # when 'trips'
  #   puts 'trips'
  when 'straight'
    compare_high_cards(high_card(hand_1), high_card(hand_2), true)
  #   puts 'straight'
  when 'flush'
    compare_high_cards(high_card(hand_1), high_card(hand_2), true)
  # when 'full house'
  #   puts 'full house'
  # when 'quads'
  #   puts 'quads'
  # when 'straight flush'
  #   puts 'straigt flush'
  else
    puts "deep shit #{rank}"
    @ties +=1
  end
end
puts "Start"
data = read_file("p054_poker.txt")
@p1_wins = 0
@p2_wins = 0
@ties = 0
data.each_with_index do |row, index|
  player_1_hand, player_2_hand = split_hands(row)
  puts "Hand #{index + 1}:"
  puts "Player 1 - #{player_1_hand}"
  p1_hand_rank = read_hand(player_1_hand)
  puts "Player 2 - #{player_2_hand}"
  p2_hand_rank = read_hand(player_2_hand)

  compare(p1_hand_rank, p2_hand_rank, player_1_hand, player_2_hand)
  puts "debug me" if @ties != 0
  puts "\n"
end
puts "Player 1 Wins: #{@p1_wins}"
puts "Player 2 Wins: #{@p2_wins}"
puts "Ties: #{@ties}"
puts "End"