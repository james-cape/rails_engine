class RevenueCentsDollarsSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
    ('%.2f' % (object.revenue.to_r/100)).to_s
  end
end
