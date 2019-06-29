class CentsDollarsSerializer
  include FastJsonapi::ObjectSerializer

  attribute :total_revenue do |object|
    ('%.2f' % (object.total_revenue.to_r/100)).to_s
  end
end
