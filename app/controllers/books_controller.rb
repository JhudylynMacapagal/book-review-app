class BooksController < ApplicationController
	before_action :find_book, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:new, :edit]


	def index
		@books =Book.all #ngayon ko lng inadd
		#@books = Book.where('title LIKE ?', "%#{params[:search]}%")
		if params[:category].blank?
			@books = Book.all.order("created_at DESC").paginate(page: params[:page], per_page: 8)
			@books = Book.where('title LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: 8) 
			#@books = Book.where('title LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: 4) 
			#@books = Book.search("%#{params[:search]}%").paginate(page: params[:page], per_page: 4) 
																		#will paginate above	
		else
			@category_id = Category.find_by(name: params[:category]).id
			@books = Book.where(:category_id => @category_id).order("created_at DESC").paginate(page: params[:page], per_page: 4)
																						#will paginate above
		end	

	end



	def show

		@book = Book.find(params[:id]) #added for ajax modal
		#@book = Book.find(params[:id])
		#active_model_serializer
		  @book = Book.find(params[:id])
		  respond_to do |format|
		    format.html
		    format.json { render json: @book }
		  end
		

		#ERROR WHEN THE NEW ADDED BOOK AND YOU ADD REVIEW THAT IS BLANK NOT WORKING
		#if @book.reviews.blank?
		  #@average_review = 0
		#else
		 #  @average_review = @book.reviews.average(:rating).round(2)
		#end   

		#TRY THIS
			@reviews =  @book.reviews.order("created_at DESC")
				unless @reviews.present?
						@average_review = 0
				else
						@average_review = @reviews.average(:rating).present? ? @reviews.average(:rating).round(2) : 0
				end

	end


	def new
		#@book =Book.new
		@book =Book.new
		@book = current_user.books.build
		@categories = Category.all.map{ |c| [c.name, c.id] }

	end
	
	def create
		@books = Book.all
        @book = Book.create(book_params)

		@book = current_user.books.build(book_params)
		@book.category_id = params[:category_id]
		#@book =Book.new(book_params)

		if @book.save
			redirect_to root_path,  notice: "The book #{@book.title} has been added."
		else
			render 'new'
		end	
	end	


#EDIT

	def edit

		@book = Book.find(params[:id]) #for ajax modal

		@categories = Category.all.map{ |c| [c.name, c.id] }


	end

	def update

		@books = Book.all
	    @book = Book.find(params[:id])

	    @book.update_attributes(book_params)
	    

		@book.category_id = params[:category_id]
		if @book.update(book_params)
			redirect_to book_path(@book)
		else
		render 'edit'	
	 end
	end


	def destroy
		@book.destroy
		redirect_to root_path, notice: 'Book was successfully destroyed.'


	end	


#FOR SIDEKIQ
	def report
		#generate_report()
		ReportWorker.perform_async("02-01-2019", "03-25-2019")
		render text: "REQUEST TO GENERATE A REPORT ADDED TO THE QUEUE"
	end


	private
		def book_params
			params.require(:book).permit(:title, :description, :author, :category_id, :user_pic)
		end	

		def find_book
			@book = Book.find(params[:id])
		end	

		#SIDEKIQ
		def generate_report
			sleep 30
		end	


end
