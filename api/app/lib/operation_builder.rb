# frozen_string_literal: true

class OperationBuilder
  include OperationBuilderHelpers

  attr_reader :operation

  def initialize
    @operation = { date: nil, label: nil, amount: nil, comment: '',
                   pointed: false, op_type: nil, category_id: nil, user_id: nil }
  end

  def result
    operation
  end

  def build_date(date)
    operation[:date] = date
  end

  def build_label(label)
    operation[:label] = label
  end

  def build_amount(amount)
    operation[:amount] = amount
  end

  def build_comment(comment)
    operation[:comment] = comment
  end

  def build_pointed(pointed)
    operation[:pointed] = pointed
  end

  def build_op_type(label, supplier, amount)
    type = if vital?(label, supplier)
             :vital
           elsif income?(amount)
             :income
           else
             :unknown
           end

    operation[:op_type] = Operation.op_types[type]
  end

  def build_category(label, user)
    operation[:category_id] = guessed_category(label, user).try(:id)
  end

  def build_user(user)
    operation[:user_id] = user.id
  end
end
