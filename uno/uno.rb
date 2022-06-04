class Card
    RANKS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "TakeTwo", "Stop"]
    SUITS = ["Red", "Blue", "Green", "Yellow"]
  
    attr_accessor :rank, :suit
    
    #beskrivning: Denna funktion initierar objekten rank och suit, den validerar även argumenten. 
    #argument 1: indexet för ranken, alltså en integer
    #argument 2: indexet för suit, också en integer
    def initialize(rank_i, suit_i)
      @rank = RANKS[rank_i]
      @suit = SUITS[suit_i]
      if !@rank || !@suit
        raise "invalid"
      end 
    end

    #beskrivning: funktionen skriver ut varje kort, alltså dess rank och suit 
    def output()
        puts "#{@suit}|#{@rank}"
    end 

    #beskrivning: funktionen tar in ett kort (vilket består av en rank och en suit) och jämför detta med sig själv genom @, vilket när denna funktion används innebär det valda kortet från handen
    #argument 1: ett kort, vilket består av en suit och en rank 
    #return: returnerar en bool, alltså om jämförelsen stämmer returnerar den true, annars false 
    def compatible(card)
        return card.suit == @suit || card.rank == @rank
    end 
end
  
class Deck
    attr_accessor :cards

    #beskrivning: funktionen kombinerar rankar och suits och skapar en kortlek, detta genom två foreach loopar, som sedan shufflas med rubys .shuffle!
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

    #beskrivning: skriver ut varje kort i kortleken
    def output()
        @deck.each do |card|
            card.output
        end 
    end 

    #beskrivning: returnerar och raderar det sista kortet i kortleken, med hjälp av funktionen .pop
    def deal()
        @deck.pop
    end
end

class Player

    #beskrivning: skapar en tom hand, som sedan kan tilldelas olika spelare 
    def initialize()
        @hand = []
    end 

    #beskrivning: denna funktion validerar det valda indexet, genom att jämför det med mängden kort spelaren har på handen. Om det är giltigt så tas kortet vid indexet (i) bort från spelarens hand, annars raisas "ogiltig index", vilket innebär att spelet kraschar 
    #argument 1: en variabel som representerar ett index, alltså en integer 
    def put_down(i)
        if i >= @hand.length
            raise "ogiltig index"
        else 
            @hand.delete_at(i)
        end 
    end 

    #beskrivning: denna funktion, likt den förra krashar vid ett ogiltigt index (alltså om det går utanför antal kort på handens längd), och väljer det kort man har valt 
    #argument 1: en variabel som representerar ett index, alltså en integer
    def get_card(i)
        if i >= @hand.length
            raise "ogiltig index"
        else 
            @hand[i] 
        end 
    end 

    #beskrivning: take lägger till/appendar (lägger till i slutet) ett valt kort till handen 
    #argument 1: ett kort, vilket innebär en kombination av en suit och en rank
    def take(card)
        @hand << card
    end 
    
    #beskrivning skriver ut alla kort på handen med dess index + 1, för att väljaren lätt ska kunna använda korten
    def output() 
        @hand.each_with_index do |card, i|
            print "(#{i + 1}) "
            card.output
        end 
    end 

    #beskrivning: ger antalet kort som finns på handen
    def cards_in_hand()
        @hand.length 
    end 
end 

class Game
    #beskrivning: initierar spelare och kortlek, och skapar alltså då nya objekt. Den skapar också ett bottenkort som består av ett kort från kortleken
    def initialize()
        @players = [Player.new, Player.new]
        @deck = Deck.new
        @latest_card = @deck.deal
    end 

    #beskrivning: denna funktion binder samman alla funktioner och klasser och kör hela programmet. Den delar först ut kort till varje spelare och startar sedan en loop som skiftar mellan spelare och sköter all interaktion med användaren. Den har också undantag för specialkort, hamnar i en evig loop det valda kortet inte är kompatibelt, och avlutas när en spelare har 0 kort på handen. 
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
                if @players[current_player].get_card(action - 1).rank == "TakeTwo"
                    @latest_card = @players[current_player].put_down(action - 1)
                    other_player = 0
                    if current_player == 0
                        other_player = 1
                    end

                    @players[other_player].take(@deck.deal())
                    @players[other_player].take(@deck.deal())
                elsif @players[current_player].get_card(action - 1).rank == "Stop"
                    @latest_card = @players[current_player].put_down(action - 1)
                    if current_player == 0
                        current_plyer = 1
                    else
                        current_player = 0
                    end

                elsif @players[current_player].get_card(action - 1).compatible(@latest_card)
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