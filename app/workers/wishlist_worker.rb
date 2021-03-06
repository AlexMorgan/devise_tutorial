class WishlistWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(need_id)
    need = Need.find(need_id)
    if need.isbn.present?
      matches = Book.where(isbn: need.isbn)
    else
      matches = Book.where(isbn13: need.isbn13)
    end

    if matches.length != 0 &&  need.notified == false
        UserMailer.wishlist_match(matches, need).deliver
        need.update!(notified: true)
    end
  end

end
