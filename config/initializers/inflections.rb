ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular(/Chassis$/, "Chassis")
  inflect.plural(/Chassis$/, "Chassis")
  inflect.singular(/chassis$/, "chassis")
  inflect.plural(/chassis$/, "chassis")
  inflect.singular(/quota$/, "quota")
  inflect.plural(/quota$/, "quotas")
  inflect.singular(/Quota$/, "Quota")
  inflect.plural(/Quota$/, "Quotas")

  inflect.acronym 'ManageIQ'
end
