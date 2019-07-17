def create_admin_if_new(email, name)
  admin = Admin.find_by(email: email)
  if !admin
    admin = Admin.new(name: name, uid: email, email: email, password: "abcdabcd", password_confirmation: "abcdabcd")
    admin.skip_confirmation!
    admin.save!
  end
end

def create_group_if_new(code, prop_name, name, sort_order, property_segment, parent = nil, property_filter_code = nil)
  item = PropertyGroup.find_by(code: code)
  if item
    item.prop_name = prop_name
    item.name = name
    item.sort_order = sort_order
    item.property_segment = property_segment
  else
    item = PropertyGroup.new(code: code, prop_name: prop_name, name: name, sort_order: sort_order, property_segment: property_segment)
  end
  if parent
    item.parent_id = parent.id
    item.filter_property_id = property_filter_code ? parent.properties.find_by(code: property_filter_code).id : nil
  end

  item.property_filter = item.filter_property_id ? true : false
  item.save!
  item
end

def create_properties(segment, properties)
  properties.each_with_index do |property, idx|
    prop = Property.find_by(code: property[:code], segment: segment)
    if !prop
      item = Property.new(code: property[:code], name: property[:name], sort_order: idx + 1, segment: segment)
      item.save!
    end
  end
end

# Categories
category_group = create_group_if_new("category", "category_id", "Categoria", 1, "category")
create_properties(category_group.property_segment, [{code: "acessory", name: "Acessórios"}, {code: "clothing", name: "Roupas"}, {code: "shoes", name: "Calçados"}, {code: "purse", name: "Bolsas"}])

# Kinds
acessory_kind = create_group_if_new("acessory_kind", "kind_id", "Tipo", 2, "acessory_kind", category_group, "acessory")
create_properties(acessory_kind.property_segment, [{ code: "oculos", name: "óculos" }, { code: "relogio", name: "relógio" }, { code: "bijoux", name: "bijoux" }, { code: "cinto", name: "cinto" }, { code: "joia", name: "jóia" }, { code: "carteira", name: "carteira" }, { code: "lenco", name: "lenço" }, { code: "chapeu", name: "chapeu" }, { code: "cabelo", name: "para cabelo" }])

clothing_kind = create_group_if_new("clothing_kind", "kind_id", "Tipo", 2, "clothing_kind", category_group, "clothing")
create_properties(clothing_kind.property_segment, [ { code: "blusa", name: "blusa" }, { code: "colete", name: "colete" }, { code: "calca", name: "calça" }, { code: "camisa", name: "camisa" }, { code: "camiseta", name: "camiseta" }, { code: "casaquinho", name: "casaquinho" }, { code: "macacao", name: "macacão" }, { code: "saia", name: "saia" }, { code: "short", name: "short" }, { code: "terno", name: "terno" }, { code: "vestidosdefesta", name: "vestidos de festa" }, { code: "vestido", name: "vestido" } ])
shoes_kind = create_group_if_new("shoes_kind", "kind_id", "Tipo", 2, "shoes_kind", category_group, "shoes")
create_properties(shoes_kind.property_segment, [ { code: "bota", name: "bota" }, { code: "sandalia", name: "sandália" }, { code: "rasteirinha", name: "rasteirinha" }, { code: "sapatilha", name: "sapatilha" }, { code: "sapato", name: "sapato" }, { code: "tenis", name: "tênis" } ])
purse_kind = create_group_if_new("purse_kind", "kind_id", "Tipo", 2, "purse_kind", category_group, "purse")
create_properties(purse_kind.property_segment, [ { code: "clutche", name: "clutche" }, { code: "ombro", name: "ombro" }, { code: "mochila", name: "mochila" }, { code: "de mão", name: "de mão" }, { code: "necessaire", name: "necessaire" }, { code: "outro", name: "outro" } ])

# Size Groups & Size
create_properties("pmg_size_group", [{ code: "adult", name: "Adulto" }, { code: "kids", name: "Infantil" }])
create_properties("number_size_group", [{ code: "adult", name: "Adulto" }, { code: "kids", name: "Infantil" }])
create_properties("pmg_size", [ { code: "unico", name: "Único" }, { code: "PP", name: "PP" }, { code: "P", name: "P" }, { code: "M", name: "M" }, { code: "G", name: "G" }, { code: "GG", name: "GG" }])
create_properties("adult_size", [{ code: "unico", name: "Único" }, { code: "34", name: "34" }, { code: "36", name: "36" }, { code: "38 ", name: "38 " }, { code: "40", name: "40" }, { code: "42 ", name: "42 " }, { code: "44", name: "44" }, { code: "46", name: "46" }, { code: "48 ", name: "48 " }, { code: "50", name: "50" }, { code: "52", name: "52" }, { code: "54", name: "54" }, { code: "56", name: "56" }, { code: "58", name: "58" }, { code: "60", name: "60" }, { code: "PP", name: "PP" }, { code: "P", name: "P" }, { code: "M", name: "M" }, { code: "G", name: "G" }, { code: "GG", name: "GG" }, { code: "GGG", name: "GGG" }])
create_properties("kids_size", [{ code: "1", name: "1" }, { code: "2", name: "2" }, { code: "3", name: "3" }, { code: "4", name: "4" }, { code: "5", name: "5" }, { code: "6", name: "6" }, { code: "7", name: "7" }, { code: "8", name: "8" }, { code: "9 ", name: "9 " }, { code: "10 ", name: "10 " }, { code: "11 ", name: "11 " }, { code: "12", name: "12" }, { code: "13 ", name: "13 " }, { code: "14 ", name: "14 " }, { code: "15 ", name: "15 " }, { code: "16", name: "16" }, { code: "17 ", name: "17 " }, { code: "18 ", name: "18 " }, { code: "19 ", name: "19 " }, { code: "20", name: "20" }, { code: "21 ", name: "21 " }, { code: "22 ", name: "22 " }, { code: "23 ", name: "23 " }, { code: "24", name: "24" }, { code: "25 ", name: "25 " }, { code: "26 ", name: "26 " }, { code: "27 ", name: "27 " }, { code: "28", name: "28" }, { code: "29 ", name: "29 " }, { code: "30 ", name: "30 " }, { code: "31 ", name: "31 " }, { code: "32", name: "32" }, { code: "33 ", name: "33 " }, { code: "34 ", name: "34 " }, { code: "35 ", name: "35 " }, { code: "38", name: "38" }, { code: "PP ", name: "PP " }, { code: "P ", name: "P " }, { code: "M ", name: "M " }, { code: "G", name: "G" }, { code: "GG ", name: "GG " }, { code: "RN ", name: "RN " }, { code: "3M", name: "3M" }, { code: "6M", name: "6M" }, { code: "9M", name: "9M" }, { code: "12M ", name: "12M " }, { code: "18M", name: "18 M" }, { code: "24M", name: "24 M" }])


accessories_size_group = create_group_if_new("accessories_size_group", "size_group_id", "Adulto ou Infantil", 3, "pmg_size_group", category_group, "acessory")
accessories_pmg = create_group_if_new("accessories_size", "size_id", "Tamanho", 4, "pmg_size", accessories_size_group)

clothing_size_group = create_group_if_new("clothing_size_group", "size_group_id", "Adulto ou Infantil", 3, "number_size_group", category_group, "clothing")
clothing_size_adult = create_group_if_new("clothing_size_adult", "size_id", "Tamanho", 4, "adult_size", clothing_size_group, "adult")
clothing_size_kids = create_group_if_new("clothing_size_kids", "size_id", "Tamanho", 4, "kids_size", clothing_size_group, "kids")

shoes_size_group = create_group_if_new("shoes_size_group", "size_group_id", "Adulto ou Infantil", 3, "number_size_group", category_group, "shoes")
shoes_size_adult = create_group_if_new("shoes_size_adult", "size_id", "Tamanho", 4, "adult_size", shoes_size_group, "adult")
shoes_size_kids = create_group_if_new("shoes_size_kids", "size_id", "Tamanho", 4, "kids_size", shoes_size_group, "kids")

# purses_size_group = create_group_if_new("purse_size_group", "size_group", "Adulto ou Infantil", 3, "no_options", category_group, "purse")

# Modelagem
create_properties("gender_model", [{ code: "feminina", name: "Feminina" }, { code: "masculina", name: "Masculina" }, { code: "neutra", name: "Neutra" }])
accessories_pattern = create_group_if_new("accessories_model", "model_id", "Modelagem", 5, "gender_model", category_group, "acessory")
clothing_pattern = create_group_if_new("clothing_model", "model_id", "Modelagem", 5, "gender_model", category_group, "clothing")
shoes_pattern = create_group_if_new("shoes_model", "model_id", "Modelagem", 5, "gender_model", category_group, "shoes")
# purses_pattern = create_group_if_new("purse_pattern", "pattern", "Modelagem", 3, "no_options", category_group, "purse")

# Padrão
create_properties("standard_pattern", [{ code: "Liso", name: "Liso" }, { code: "Estampado", name: "Estampado" }, { code: "Listrado", name: "Listrado" }, { code: "Geométrico", name: "Geométrico" }])

accessories_pattern = create_group_if_new("accessories_pattern", "pattern_id", "Padrão", 6, "standard_pattern", category_group, "acessory")
clothing_pattern = create_group_if_new("clothing_pattern", "pattern_id", "Padrão", 6, "standard_pattern", category_group, "clothing")
shoes_pattern = create_group_if_new("shoes_pattern", "pattern_id", "Padrão", 6, "standard_pattern", category_group, "shoes")
purses_pattern = create_group_if_new("purse_pattern", "pattern_id", "Padrão", 6, "standard_pattern", category_group, "purse")

# Cor
create_properties("standard_color", [{ code: "Amarela", name: "Amarela" }, { code: "Azul", name: "Azul" }, { code: "Bege", name: "Bege" }, { code: "Branco", name: "Branco" }, { code: "Bronze", name: "Bronze" }, { code: "Caramelo", name: "Caramelo" }, { code: "Cinza", name: "Cinza" }, { code: "Creme", name: "Creme" }, { code: "Coral", name: "Coral" }, { code: "Dourado", name: "Dourado" }, { code: "Glitter", name: "Glitter" }, { code: "Índigo", name: "Índigo" }, { code: "Laranja", name: "Laranja" }, { code: "Lilás", name: "Lilás" }, { code: "Marrom", name: "Marrom" }, { code: "Preto", name: "Preto" }, { code: "Rosa", name: "Rosa" }, { code: "Roxo", name: "Roxo" }, { code: "Turquesa", name: "Turquesa" }, { code: "Verde", name: "Verde" }, { code: "Vermelha", name: "Vermelha" }])

accessories_color = create_group_if_new("accessories_color", "color_id", "Cor", 7, "standard_color", category_group, "acessory")
clothing_color = create_group_if_new("clothing_color", "color_id", "Cor", 7, "standard_color", category_group, "clothing")
shoes_color = create_group_if_new("shoes_color", "color_id", "Cor", 7, "standard_color", category_group, "shoes")
purses_color = create_group_if_new("purse_color", "color_id", "Cor", 7, "standard_color", category_group, "purse")

# create_admin_if_new("admin@nucleo235.com.br", "Henrique")
