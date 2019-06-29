class DateSerializer
  include FastJsonapi::ObjectSerializer

  attribute :best_day do |object|

    object.best_day.to_s[0..9]
  end
end
