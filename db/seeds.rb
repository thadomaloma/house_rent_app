Favorite.destroy_all
Inquiry.destroy_all
Property.destroy_all
User.destroy_all

admin = User.create!(
  name: "Inluah Admin",
  email: "admin@inluah.test",
  password: "password",
  role: :admin
)

owners = [
  User.create!(name: "Lalremruata Sailo", email: "owner1@inluah.test", phone: "+919612345001", password: "password", role: :owner),
  User.create!(name: "Zothanmawia Khiangte", email: "owner2@inluah.test", phone: "+919612345002", password: "password", role: :owner),
  User.create!(name: "Rinpari Tochhawng", email: "owner3@inluah.test", phone: "+919612345003", password: "password", role: :owner)
]

tenant = User.create!(
  name: "Sample Tenant",
  email: "tenant@inluah.test",
  phone: "+919612345099",
  password: "password",
  role: :tenant
)

listings = [
  [ "Bright 2BHK near Chanmari", "A sunny family apartment with good water supply, balcony, and quick access to shops and schools.", :apartment, 22000, 30000, :chanmari, "Upper Chanmari, near main road", 2, 2, "2nd", true ],
  [ "Quiet room for students in Dawrpui", "Single room with shared kitchen, ideal for students or working tenants.", :room, 6500, 8000, :dawrpui, "Dawrpui Vengthar", 1, 1, "1st", false ],
  [ "Independent house at Ramhlun", "Spacious independent house with parking, airy rooms, and hillside views.", :house, 32000, 50000, :ramhlun, "Ramhlun North", 3, 2, "Ground", true ],
  [ "Compact office space Bawngkawn", "Road-facing office with easy public transport access and steady footfall.", :office, 18000, 25000, :bawngkawn, "Bawngkawn main junction", 0, 1, "1st", false ],
  [ "Affordable hostel PG Vaivakawn", "Clean PG beds with food option, Wi-Fi, and common study area.", :hostel_pg, 7000, 7000, :vaivakawn, "Vaivakawn near market", 1, 1, "3rd", true ],
  [ "Family apartment in Kulikawn", "Well maintained 2BHK with modular kitchen and covered two-wheeler parking.", :apartment, 19000, 25000, :kulikawn, "Kulikawn West", 2, 1, "1st", false ],
  [ "Durtlang hillside home", "Peaceful house with wide windows, fresh air, and a small garden patch.", :house, 28000, 40000, :durtlang, "Durtlang Leitan", 3, 2, "Ground", true ],
  [ "Shop space in Zemabawk", "Compact shop suitable for boutique, stationery, or small services.", :shop, 14000, 20000, :zemabawk, "Zemabawk bazar area", 0, 1, "Ground", false ],
  [ "Modern room Thuampui", "Freshly painted room with attached bathroom and separate entrance.", :room, 8500, 10000, :thuampui, "Thuampui Veng", 1, 1, "Ground", false ],
  [ "Bethlehem 1BHK apartment", "Cozy 1BHK for a couple or single professional, close to daily needs.", :apartment, 12500, 15000, :bethlehem, "Bethlehem Vengthlang", 1, 1, "2nd", false ],
  [ "Mission Veng office suite", "Two-room office with reception area, ideal for consultancy or startup.", :office, 24000, 30000, :mission_veng, "Mission Veng main street", 0, 1, "2nd", true ],
  [ "Sihphir family house", "Large home with quiet surroundings and space for kitchen garden.", :house, 21000, 25000, :sihphir, "Sihphir Venghlun", 3, 2, "Ground", false ],
  [ "Budget room near Chanmari", "Simple and clean room for working tenant with shared bathroom.", :room, 5500, 6000, :chanmari, "Chanmari West", 1, 1, "Lower ground", false ],
  [ "Premium 3BHK Dawrpui", "Large apartment with excellent road access, storage, and bright living room.", :apartment, 35000, 60000, :dawrpui, "Dawrpui near church", 3, 2, "3rd", true ],
  [ "Ground floor shop Ramhlun", "Visible shop space suitable for pharmacy, salon, or grocery.", :shop, 16500, 22000, :ramhlun, "Ramhlun Venglai", 0, 1, "Ground", false ],
  [ "Studio apartment Bawngkawn", "Neat studio with attached bathroom, good for one tenant.", :apartment, 10500, 12000, :bawngkawn, "Bawngkawn South", 1, 1, "1st", false ],
  [ "Office room Kulikawn", "Quiet office room with washroom access and flexible lease terms.", :office, 12000, 15000, :kulikawn, "Kulikawn near traffic point", 0, 1, "2nd", false ],
  [ "Shared PG in Durtlang", "Shared accommodation with meals available and peaceful study environment.", :hostel_pg, 6000, 6000, :durtlang, "Durtlang North", 1, 1, "1st", false ],
  [ "Two bedroom home Zemabawk", "Comfortable home with separate kitchen and easy taxi access.", :house, 17500, 20000, :zemabawk, "Zemabawk North", 2, 1, "Ground", false ],
  [ "Other area rental near Aizawl", "Flexible rental option just outside central Aizawl, suitable for a small family.", :house, 15000, 18000, :other, "Near Aizawl bypass", 2, 1, "Ground", false ]
]

listings.each_with_index do |listing, index|
  title, description, property_type, rent, deposit, area, address, bedrooms, bathrooms, floor, featured = listing
  owner = owners[index % owners.length]

  property = owner.properties.create!(
    title: title,
    description: description,
    property_type: property_type,
    rent: rent,
    deposit: deposit,
    area: area,
    address: address,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    floor: floor,
    available_from: Date.current + (index % 5).days,
    contact_name: owner.name,
    phone: owner.phone,
    whatsapp_number: owner.phone,
    status: index == 8 ? :rented : :available,
    featured: featured,
    views_count: rand(12..260)
  )

  property.inquiries.create!(
    name: tenant.name,
    phone: tenant.phone,
    message: "Hi, is this listing still available for viewing this week?",
    user: tenant
  ) if index < 6
end

puts "Seeded #{User.count} users and #{Property.count} properties."
