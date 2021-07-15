class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    #フォローしようとしているother_userが自分自身でないかを検査
    unless self == other_user
      #user.follow(other)を実行したとき、userが代入される
      #Userのインスタンスがself
      #見つかればRelationshipモデルのインスタンスを返す
      #見つからなければ、フォロー県警を保存(create=build+save)
      #これにより、すでにフォローされている場合にフォローが重複して保存されることがなくなる
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  #フォローがあればアンフォローする
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    #relationshipが存在すればdestroy
    relationship.destroy if relationship
  end

  #self.followingsによりフォローしているUser達を取得し、
  def following?(other_user)
    #other_userが含まれないかを確認
    #含まれている場合には、ture
    #含まれてない場合には、false
    self.followings.include?(other_user)
  end
end