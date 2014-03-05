class ItemsController < ApplicationController

		
	def index
		respond_to do |format|
      format.html { @items = limit_array(items_params) }
      format.json { 
 				@items = Item.find_by_sql('SELECT i.id, i.name, i.price, i.category_id, i.brand_id, i.photo, i.click_url FROM items AS i LEFT OUTER JOIN likes AS l ON i.id = l.item_id GROUP BY i.id, i.name, i.price, i.category_id, i.brand_id, i.photo, i.click_url ORDER BY COUNT(l.item_id) DESC LIMIT 100;') }
    end
	end


	def create 
		@items = limit_array(items_params)
		if params[:is_like] == "true"
			likeClicked()
		elsif params[:is_like] == "false"
			dislikeClicked()
		else
			#this is where we will add new items with an api request
			render action: 'index'
		end
		
	end


	def likeClicked
		Like.create(user_id: current_user.id, item_id: @items.first.id, is_like: true)
		@items.shift
		render action: 'index'
	end

	def dislikeClicked
		Like.create(user_id: current_user.id, item_id: @items.first.id, is_like: false)
		@items.shift
		render action: 'index'
	end


private

	def items_params
		if params[:cat].blank?
			@items = Item.all
		else
			if params[:price].blank?
				@items = Category.find_by(name: params[:cat]).items
			else
				@items = Category.find_by(name: params[:cat]).items.where("price < ?", params[:price].to_f)
				if @items.length == 0
					@items = Category.find_by(name: params[:cat]).items
				end
			end
		end

		return @items.to_a

	end

	def limit_array(array)
		current_user.items.each do |item|
			array.delete(item)
		end
		return array
	end

end