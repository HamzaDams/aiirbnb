class ReservationsController < ApplicationController
    
    before_action :authenticate_user!
      def preload
           room = Room.find(params[:room_id])
           today = Date.today
           reservations = room.reservations.where("str_date >= ? OR end_date >= ?", today, today)
           
           render json: reservations
        end
        
        def preview
            str_date = Date.parse(params[:str_date])
            end_date = Date.parse(params[:end_date])
            
            output = {
                conflict: is_conflict(str_date, end_date)
            }
            
            render json: output
        end
     
    private
        def is_conflict(str_date, end_date)
            room = Room.find(params[:room_id])
     
            check = room.reservations.where("? < str_date AND end_date < ?", str_date, end_date)
            check.size > 0? true : false
        end
       def reservation_params
           params.require(:reservation).permit(:str_date, :end_date, :price, :total, :room_id)
        end
end