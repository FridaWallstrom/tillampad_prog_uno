
    def take_two(card)
        return card.rank == 10 || card.rank == "TakeTwo"
    end 


    if @players[current_player].take_two(get_card(action - 1))
        @latest_card = @players[current_player].put_down(action - 1)
        if current_player = 0
            (1..2).each do |value|
                @players[1].take(@deck.deal()) 
            end 
        else
            (1..2).each do |value|
                @players[0].take(@deck.deal()) 
            end  
        end