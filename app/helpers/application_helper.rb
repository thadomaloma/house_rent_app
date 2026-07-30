module ApplicationHelper
  def rupees(amount)
    number_to_currency(amount || 0, unit: "₹", precision: 0, delimiter: ",")
  end

  def property_area_label(property)
    property.area.humanize.titleize
  end

  def property_type_label(property)
    property.property_type.humanize.titleize
  end

  def status_badge_classes(property)
    case property.status
    when "available"
      "bg-emerald-100 text-emerald-700 ring-emerald-200"
    when "rented"
      "bg-amber-100 text-amber-700 ring-amber-200"
    else
      "bg-slate-200 text-slate-600 ring-slate-300"
    end
  end

  def nav_link_classes(path)
    if current_page?(path)
      "text-emerald-700"
    else
      "text-slate-500 hover:text-emerald-700"
    end
  end
end
