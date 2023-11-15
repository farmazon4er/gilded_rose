require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'rspec'
require 'pry'
require 'pry-nav'
RSpec::Matchers.define_negated_matcher(:not_change, :change)

describe GildedRose do
  subject { GildedRose.new(items).update_quality }
  describe "#update_quality" do
    let(:items) { [Item.new("+5 Dexterity Vest", 10, 20)] }
    
    context "does not change name" do
      it "doesnot change name" do
        expect{ subject }.to not_change { items[0].name }
      end
    end

    context "when usual item" do
      it "does change quality, sell_in" do
        expect{ subject }.to (change{ items[0].quality }.from(20).to(19)).and(
          change { items[0].sell_in }.from(10).to(9))
      end

      context "when sell_in < 0" do
        let(:items) { [Item.new("+5 Dexterity Vest", 0, 20)] }

        it "does recude quality by 2 and sell_in by 1" do
          expect{ subject }.to (change{ items[0].quality }.from(20).to(18)).and(
            change { items[0].sell_in }.from(0).to(-1))
        end
      end

      context "when quality 0" do
        let(:items) { [Item.new("+5 Dexterity Vest", 0, 0)] }

        it "does not change quality, reduce sell_in by -1" do
          expect{ subject }.to (not_change{ items[0].quality }.from(0)).and(
            change { items[0].sell_in }.from(0).to(-1))
        end
      end
    end
    
    context "when item Aged Brie " do
      let(:items) { [Item.new("Aged Brie", 2, 0)] }

      it "does change quality by 1, reduce sell_in by -1" do
        expect{ subject }.to (change{ items[0].quality }.from(0).to(1)).and(
          change { items[0].sell_in }.from(2).to(1))
      end

      context "when sell_in < 0" do
        let(:items) { [Item.new("Aged Brie", 0, 0)] }

        it "does change quality by 2, reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(0).to(2)).and(
            change { items[0].sell_in }.from(0).to(-1))
        end
      end

      context "when quality 50" do
        let(:items) { [Item.new("Aged Brie", 0, 50)] }
        it "does not change quality and reduce sell_in by -1" do
          expect{ subject }.to (not_change{ items[0].quality }.from(50)).and(
            change { items[0].sell_in }.from(0).to(-1))
        end
      end
    end

    context "when item Backstage passes" do
      context "when sell_in > 10" do
        let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)] }

        it "does change quality by 1 and reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(20).to(21)).and(
            change { items[0].sell_in }.from(15).to(14))
        end
      end

      context "when sell_in < 10 and > 5 " do
        let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 7, 20)] }

        it "does change quality by 1 and reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(20).to(22)).and(
            change { items[0].sell_in }.from(7).to(6))
        end
      end

      context "when sell_in < 5 " do
        let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 3, 20)] }

        it "does change quality by 1 and reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(20).to(23)).and(
            change { items[0].sell_in }.from(3).to(2))
        end
      end

      context "when sell_in 0 " do
        let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)] }

        it "does change quality by 1 and reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(20).to(0)).and(
            change { items[0].sell_in }.from(0).to(-1))
        end
      end

      context "when quality 49" do
        let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 49)] }

        it "does change quality by 1 and reduce sell_in by -1" do
          expect{ subject }.to (change{ items[0].quality }.from(49).to(50)).and(
            change { items[0].sell_in }.from(4).to(3))
        end
      end
    end

    
    context "when item Sulfuras" do
      let(:items) {[Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]}
        
      it "does not change quality, sell_in" do
        expect{ subject }.to (not_change { items[0].quality }).and(not_change { items[0].sell_in })
        expect(items[0].quality).to eq 80
        expect(items[0].sell_in).to eq 0
      end
    end
  end
end
