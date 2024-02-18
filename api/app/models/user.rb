# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :notes, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :lines, dependent: :destroy
  has_many :operations, dependent: :destroy
  has_one :objective, dependent: :destroy

  after_create :create_default_categories

  DEFAULT_CATEGORIES = [
    { key: 'to_categorize', color: '#9e9e9e', icon: 'mdi-shape-plus-outline' },
    { key: 'home', color: '#2980b9', icon: 'mdi-home-circle-outline' },
    { key: 'bank', color: '#d35400', icon: 'mdi-bank-outline' },
    { key: 'shopping', color: '#e74c3c', icon: 'mdi-shopping-outline' },
    { key: 'food', color: '#f1c40f', icon: 'mdi-food' },
    { key: 'subscriptions', color: '#9b59b6', icon: 'mdi-cash-sync' },
    { key: 'auto_transport', color: '#1abc9c', icon: 'mdi-plane-car' },
    { key: 'beauty_care', color: '#ff9ff3', icon: 'mdi-star-four-points-outline' },
    { key: 'taxes', color: '#bdc3c7', icon: 'mdi-cash-multiple' },
    { key: 'salary', color: '#27ae60', icon: 'mdi-cash-100' }
  ].freeze

  def create_default_categories
    DEFAULT_CATEGORIES.each do |category|
      Category.create!({ user_id: id, **category })
    end
  end
end
