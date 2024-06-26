# frozen_string_literal: true

class OperationBuildingDirector
  def initialize(user)
    reset_with!(nil)

    @user = user
  end

  def build_operation(raw_data)
    reset_with!(raw_data)

    builder = OperationBuilder.new
    builder.build_date(data.date)
    builder.build_label(data.label)
    builder.build_amount(data.amount)
    builder.build_pointed(false)
    builder.build_op_type(data.label, data.supplier, data.amount)
    builder.build_category(data.label, @user)
    builder.build_user(@user)
    builder.result
  end

  private

  def data_struct
    @data_struct ||= Struct.new(:date, :label, :amount, :comment, :supplier, :user_id, :category_id)
  end

  def data
    @data ||= data_struct.new(@raw_data[:date_op], @raw_data[:label], @raw_data[:amount],
                              @raw_data[:comment], @raw_data[:supplier_found], @raw_data[:user_id],
                              @raw_data[:category_id])
  end

  def reset_with!(raw)
    @struct = nil
    @data = nil
    @raw_data = raw
  end
end
