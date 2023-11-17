module Dict
  SULFURAS = 'Sulfuras, Hand of Ragnaros'.freeze
  AGED_BRI = 'Aged Brie'.freeze
  BACKSTAGE = 'Backstage passes to a TAFKAL80ETC concert'.freeze
  CONJURED = 'Conjured'.freeze
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.map do |item|
      created_item = case
      when item.name.include?(Dict::AGED_BRI)
        AgedBrieItemCreator.new
      when item.name.include?(Dict::SULFURAS)
        SulfarusItemCreator.new
      when item.name.include?(Dict::BACKSTAGE)
        BackstagePassesItemCreator.new
      when item.name.include?(Dict::CONJURED)
        ConjuredItemCreator.new
      else
        DefaultItemCreator.new
      end
      item.sell_in, item.quality = created_item.next_day(item.name, item.sell_in, item.quality)
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

class ItemCreator
  def factory_method(name, sell_in, quality)
    DefaultItem.new(name, sell_in, quality)
  end

  def next_day(name, sell_in, quality)
    item = factory_method(name, sell_in, quality)
    item.change_sell_in
    item.change_quality
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
  def change_quality
    @quality -= 1 if @quality > 0
    @quality -= 1 if @quality > 0 && @sell_in < 0
  end

  def change_sell_in
    @sell_in -= 1
  end
end

class SulfarusItem < DefaultItem
  def change_quality;end;
  def change_sell_in;end;
end

class AgedBrieItem < DefaultItem
  def change_quality
    @quality += 1 if @quality < 50
    @quality += 1 if @quality < 50 && @sell_in < 0
  end
end

class BackstagePassesItem < DefaultItem
  def change_quality
    return @quality = 0 if @sell_in < 0
    @quality += 1 if  @quality < 50
    @quality += 1 if  @quality < 50 && @sell_in < 10
    @quality += 1 if  @quality < 50 && @sell_in < 5
  end
end

class ConjuredItem < DefaultItem
  def change_quality
    super
    super
  end
end