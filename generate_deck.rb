CARDS = [
			'AS', '2S', '3S', '4S', '5S', '6S', '7S', '8S', '9S', 'TS', 'JS', 'QS', 'KS',
			'AD', '2D', '3D', '4D', '5D', '6D', '7D', '8D', '9D', 'TD', 'JD', 'QD', 'KD',
			'AC', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'TC', 'JC', 'QC', 'KC',
			'AH', '2H', '3H', '4H', '5H', '6H', '7H', '8H', '9H', 'TH', 'JH', 'QH', 'KH'
		]

deck = CARDS.shuffle
hand = deck.first(5).join(' ')

def has_flush?(hand)
  suits = hand.split.inject("") { |suits, card| suits + card[1] }
  # puts suits
  return ["DDDDD", "CCCCC", "SSSSS", "HHHHH"].include?(suits)
end

def high_card(hand)
  cards = []
  hand.split.each do |value_with_suit|
    cards << value_with_suit[0]
  end
  count = Hash.new(0)
  cards.each do |value|
    count[value] += 1
  end
  puts count
end

def has_quads?(hand)
  cards = []
  hand.split.each do |value_with_suit|
    cards << value_with_suit[0]
  end
  count = Hash.new(0)
  cards.each do |value|
    count[value] += 1
  end
  count.values.any? {|val| val == 4}
end

puts hand
puts "Has flush?" + " " + has_flush?(hand).to_s
puts "Has quads?" + " " + has_quads?(hand).to_s