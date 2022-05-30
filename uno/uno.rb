class Card
    RANKS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "TakeTwo", "Reverse", "Stop"]
    SUITS = ["Red", "Blue", "Green", "Yellow"]
  
    attr_accessor :rank, :suit
    
    def initialize(rank_i, suit_i)
      @rank = RANKS[rank_i]
      @suit = SUITS[suit_i]
      if !@rank || !@suit
        raise "invalid"
      end 
    end

    def output()
        puts "#{@suit}|#{@rank}"
    end 

    def compatible(card)
        return card.suit == @suit || card.rank == @rank
    end 
end
  
class Deck
    attr_accessor :cards
    def initialize
      @deck = []

      Card::RANKS.each_with_index do |_, rank_i|
        Card::SUITS.each_with_index do |_, suit_i|
            @deck << Card.new(rank_i, suit_i)
            @deck << Card.new(rank_i, suit_i)
        end
      end 

      @deck.shuffle!
    end
    
    def output()
        @deck.each do |card|
            card.output
        end 
    end 

    def deal()
        @deck.pop
    end
end

class Player
    def initialize()
        @hand = []
    end 

    def put_down(i)
        if i >= @hand.length
            raise "ogiltig index"
        else 
            @hand.delete_at(i)
        end 
    end 

    def get_card(i)
        if i >= @hand.length
            raise "ogiltig index"
        else 
            @hand[i] 
        end 
    end 

    def take(card)
        @hand << card
    end 
    
    def output()
        @hand.each_with_index do |card, i|
            print "(#{i + 1}) "
            card.output
        end 
    end 

    def cards_in_hand()
        @hand.length 
    end 
end 

class Game
    def initialize()
        @players = [Player.new, Player.new]
        @deck = Deck.new
        @latest_card = @deck.deal
    end 

    def start()
        (1..7).each do |i|
            @players[0].take(@deck.deal())
            @players[1].take(@deck.deal())
        end 

        current_player = 0

        while true 
            system("clear") || system("cls") 
            sleep(2) # så att man hinner byta person 
            error_occurred = false
            print "Botten kort: "
            @latest_card.output
            puts ""
            puts "Nu är det spelare #{current_player + 1}s tur"
            puts ""
            puts "Detta är dina kort:"
            @players[current_player].output
            puts ""
            puts "Vad vill du göra? (1 & upp är index, noll = ta kort)"
            action = gets().chomp.to_i
            if action == 0 
                @players[current_player].take(@deck.deal()) 
            else 
                if @players[current_player].get_card(action - 1).compatible(@latest_card)
                    @latest_card = @players[current_player].put_down(action - 1)
                else 
                    puts "detta kort är icke kompatibelt med bottenkortet"
                    error_occurred = true 
                end 
            end 
            if @players[current_player].cards_in_hand() == 0
                puts "Spelare #{current_player + 1} vinner"
                break
            end 

            if !error_occurred  
                if current_player == 0
                    current_player = 1
                else 
                    current_player = 0
                end 
            end 
        end 
    end 
end 

game = Game.new()
game.start()