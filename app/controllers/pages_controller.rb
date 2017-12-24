class PagesController < ApplicationController
    
    def home
        @rooms = Room.order("RANDOM()").limit(3)
    end
     
    def search
        if params[:search].present? && params[:search].strip != ""
            session[:aiirbnb_search] = params[:search]
        end
        arrResult = Array.new
        
        if session[:aiirbnb_search] && session[:aiirbnb_search] != ""
            @rooms_adress = Room.where(active: true).near(session[:aiirbnb_search], 5, order:'distance')
        else
            @rooms_adress = Room.where(active: true).all
        end
        
        @search =  @rooms_adress.ransack(params[:q])
        @rooms = @search.result
        
        @arrRooms = @rooms.to_a
        
        if (params[:str_date] && params[:end_date] && !params[:str_date].empty? & !params[:end_date].empty?)
            str_date = Date.parse(params[:str_date])
            end_date = Date.parse(params[:end_date])
            
            @rooms.each do |room| 
              not_available = room.reservations.where("(? <= str_date AND str_date <= ?) OR
              (? <= end_date AND end_date <= ?) OR (str_date < ? AND ? < end_date)", str_date, end_date,
              str_date, end_date, str_date, end_date).limit(1)
              
                if not_available.length > 0
                    @arrRooms.delete(room)
                end
            end
        end
    end
end    