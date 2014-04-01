class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :plus, :zero]
  before_action :require_login, except: [:welcome]
  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.where('user_id = ?', current_user)
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = current_user.cards.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to new_card_url, notice: 'Карточка успешно создана' }
        format.json { render action: 'show', status: :created, location: @card }
        flash[:success] = 'post updated!'
      else
        format.html { render action: 'new' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Карточка успешно отредактирована' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  def test
    sec_per_day = 86400
    time_now = Time.now
    cards = Card.all
    cards_for_test = []

    cards.each do |card|
      rating = card.rating
      updated_at = card.updated_at
      time = (time_now - updated_at)/sec_per_day
      if rating == 0 || rating >= 1 && rating < 5 && time > 1 || rating >= 5 && rating < 10 && time > 2 || rating >= 10 && rating < 15 && time > 3 || rating >= 15 && rating < 15 && time > 7 || rating >= 20 && time > 30
        cards_for_test.push(card)
      end
    end
    if cards_for_test == []
      redirect_to root_url, notice: 'Тестирование завершено'
    else
      @card = cards_for_test.sample
      @@id = @card.id
      #sample аналог rand в rails
    end
  end

  def plus
    @card.increment!(:rating)
    redirect_to action: :test
  end

  def zero
    @card.update_attributes(rating: 0)
    redirect_to action: :test
  end

  def answer
    @card = Card.where(id: @@id).first
  end

  def welcome
    sec_per_day = 86400
    time_now = Time.now
    cards = Card.all
    cards_for_test = []

    cards.each do |card|
      rating = card.rating
      updated_at = card.updated_at
      time = (time_now - updated_at)/sec_per_day
      if rating == 0 || rating >= 1 && rating < 5 && time > 1 || rating >= 5 && rating < 10 && time > 2 || rating >= 10 && rating < 15 && time > 3 || rating >= 15 && rating < 15 && time > 7 || rating >= 20 && time > 30
        cards_for_test.push(card)
      end
    end
    @cards = cards_for_test
    @card_length = @cards.length
    @card_plural = nil
    if @card_length == 1 || @card_length != 11 && @card_length - 1 % 10 == 0
      @card_plural = "карточка"
    elsif ( @card_length > 1 && @card_length <= 4 ) || ( @card_length != 12 && @card_length != 13 && @card_length != 14 && @card_length - 2 % 10 == 0 || @card_length - 3 % 10 == 0 || @card_length - 4 % 10 == 0 )
      @card_plural = "карточки"
    else
      @card_plural = "карточек"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      # @card = Card.find(params[:id])
      unless @card = Card.where(user_id: current_user, id: params[:id]).first
        redirect_to root_url, alert: "Доступ запрещен"
      end
    end

    def require_login
      unless user_signed_in?
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:first_side, :second_side, :rating)
    end
end
