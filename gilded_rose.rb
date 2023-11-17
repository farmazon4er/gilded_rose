module Dict
  SULFURAS = 'Sulfuras, Hand of Ragnaros'
  AGED_BRI = 'Aged Brie'
  BACKSTAGE = 'Backstage passes to a TAFKAL80ETC concert'
  CONJURED = 'Conjured'
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.map do |item|
      created_item = item_selection(item.name)
      item.sell_in, item.quality = created_item.update(item.name, item.sell_in, item.quality)
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

def item_selection(name)
  case
  when name.include?(Dict::AGED_BRI)
    AgedBrieItemCreator.new
  when name.include?(Dict::SULFURAS)
    SulfarusItemCreator.new
  when name.include?(Dict::BACKSTAGE)
    BackstagePassesItemCreator.new
  when name.include?(Dict::CONJURED)
    ConjuredItemCreator.new
  else
    DefaultItemCreator.new
  end
end

class ItemCreator
  def factory_method(name, sell_in, quality)
    DefaultItem.new(name, sell_in, quality)
  end

  def update(name, sell_in, quality)
    item = factory_method(name, sell_in, quality)
    item.change
    [item.sell_in, item.quality]
  end
end

class DefaultItemCreator < ItemCreator
end

class SulfarusItemCreator < ItemCreator
  def factory_method(name, sell_in, quality)
    SulfarusItem.new(name, sell_in, quality)
  end
end

class AgedBrieItemCreator < ItemCreator
  def factory_method(name, sell_in, quality)
    AgedBrieItem.new(name, sell_in, quality)
  end
end

class BackstagePassesItemCreator < ItemCreator
  def factory_method(name, sell_in, quality)
    BackstagePassesItem.new(name, sell_in, quality)
  end
end

class ConjuredItemCreator < ItemCreator
  def factory_method(name, sell_in, quality)
    ConjuredItem.new(name, sell_in, quality)
  end
end

class DefaultItem < Item
  def change
    @sell_in -= 1
    @quality -= 1 if @quality.positive?
    @quality -= 1 if @quality.positive? && @sell_in.negative?
  end
end

class SulfarusItem < DefaultItem
  def change; end
end

class AgedBrieItem < DefaultItem
  def change
    @sell_in -= 1
    @quality += 1 if @quality < 50
    @quality += 1 if @quality < 50 && @sell_in.negative?
  end
end

class BackstagePassesItem < DefaultItem
  def change
    @sell_in -= 1
    return @quality = 0 if @sell_in.negative?

    @quality += 1 if @quality < 50
    @quality += 1 if @quality < 50 && @sell_in < 10
    @quality += 1 if @quality < 50 && @sell_in < 5
  end
end

class ConjuredItem < DefaultItem
  def change
    @sell_in -= 1
    2.times{ @quality -= 1 if @quality.positive? }
    2.times{ @quality -= 1 if @quality.positive? && @sell_in.negative? }
  end
end
