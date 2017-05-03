ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular(/Queue$/, "Queue")
  inflect.plural(/Queue$/, "Queue")
  inflect.singular(/queue$/, "queue")
  inflect.plural(/queue$/, "queue")
  inflect.singular(/quota$/, "quota")
  inflect.plural(/quota$/, "quotas")
  inflect.singular(/Quota$/, "Quota")
  inflect.plural(/Quota$/, "Quotas")

  inflect.acronym 'ManageIQ'
end
