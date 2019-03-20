require "spec_helper"

RSpec.describe EnumerableOnly do
  context "when no items are available" do
    it "returns nil" do
      expect([].only).to be_nil
    end
  end

  context "when exactly one item is available" do
    it "returns the one item" do
      expect([:item].only).to eq(:item)
    end

  end

  context "when more than one items are available" do
    it "raises TooManyItems" do
      expect{
        [:first, :second].only
      }.to raise_error(EnumerableOnly::TooManyItems)
    end

    it "does not iterate the entire list" do
      visited_items = []
      list = Enumerator.new do |yielded|
        visited_items << :a
        yielded << :a
        visited_items << :b
        yielded << :b
        visited_items << :c
        yielded << :c
      end

      expect{
        list.only
      }.to raise_error(EnumerableOnly::TooManyItems)

      expect(visited_items).to_not include(:c)
    end
  end

  context 'block passed' do

    context "when no items pass the block" do
      it "returns nil" do
        expect([2, 4, 6].only{ |item| item.odd? }).to be_nil
      end
    end

    context "when exactly one item passes the block" do
      it "returns the one item" do
        expect([1,2].only{ |item| item.odd? }).to eq(1)
      end

    end

    context "when more than one item passes the block" do
      it "raises TooManyItems" do
        expect{
          [1, 2, 3].only{ |item| item.odd? }
        }.to raise_error(EnumerableOnly::TooManyItems)
      end

      it "does not iterate the entire list" do
        visited_items = []
        list = Enumerator.new do |yielded|
          visited_items << 1
          yielded << 1
          visited_items << 2
          yielded << 2
          visited_items << 3
          yielded << 3
          visited_items << 4
          yielded << 4
        end

        expect{
          list.only{ |item| item.odd? }
        }.to raise_error(EnumerableOnly::TooManyItems)

        expect(visited_items).to_not include(4)
      end
    end
  end
end
